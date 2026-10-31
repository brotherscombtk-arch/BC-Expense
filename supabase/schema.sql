-- Brothers Communication – database setup
-- Run once: Supabase dashboard → SQL Editor → New query → paste → Run

create table if not exists public.entries (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid default auth.uid() references auth.users(id) on delete set null,
  date        date not null,
  type        text not null check (type in ('income','expense','pocket','topup')),
  cat         text not null default '',
  svc         text not null default '',
  amt         numeric(14,2) not null check (amt > 0),
  bill        numeric(14,2) not null default 0 check (bill >= 0),
  wallet      text check (wallet in ('nadra','cash')),
  note        text not null default '',
  legacy_id   text unique,            -- id from the old localStorage version (prevents double imports)
  created_at  timestamptz not null default now()
);

create index if not exists entries_date_idx on public.entries (date);

-- Security: only signed-in shop users can touch the data. Visitors (anon) get nothing.
alter table public.entries enable row level security;
revoke all on public.entries from anon;

drop policy if exists "staff read"   on public.entries;
drop policy if exists "staff insert" on public.entries;
drop policy if exists "staff delete" on public.entries;

create policy "staff read"   on public.entries for select to authenticated using (true);
create policy "staff insert" on public.entries for insert to authenticated with check (true);
create policy "staff delete" on public.entries for delete to authenticated using (true);
-- (No UPDATE policy on purpose: the app only adds and deletes entries.)
