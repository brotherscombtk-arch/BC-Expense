# Brothers Communication – Shop Closing (Supabase + Netlify)

Same app and same screens as before. The only change: data now lives in a Supabase
database (safe, backed up, available on every phone/PC) behind a login.

```
public/index.html      the app          (your original code, storage swapped to Supabase)
public/config.js       <- you edit this (Supabase URL + anon key)
supabase/schema.sql    database setup   (run once)
netlify.toml           Netlify settings (publish folder = public, no build step)
tools/export-old-data.html   helper to rescue your old browser data
```

## 1. Supabase (about 5 min)
1. https://supabase.com -> **New project** (pick a region near you, save the DB password).
2. **SQL Editor -> New query** -> paste all of `supabase/schema.sql` -> **Run**.
3. **Authentication -> Sign In / Providers** (or *Settings*) -> turn **OFF "Allow new users to sign up"**.
   (Important: only users you create below can see the shop data; nobody else can.)
4. **Authentication -> Users -> Add user -> Create new user**: email + password,
   tick **Auto Confirm User**. Repeat for each partner/employee who needs access.
5. **Project Settings -> API**: copy the **Project URL** and the **anon public** key.
6. Open `public/config.js` and paste both values. (The anon key is meant to be public;
   the login + Row Level Security from the SQL is what protects your data.
   **Never** put the `service_role` key anywhere in this project.)

## 2. GitHub
```bash
cd bc-shop
git init && git add . && git commit -m "Brothers Communication"
git branch -M main
git remote add origin https://github.com/YOUR_USER/bc-shop.git   # create an empty repo first (Private is fine)
git push -u origin main
```
No git? On github.com create a repo -> **Add file -> Upload files** -> drag in the *contents* of this folder.

## 3. Netlify
1. https://app.netlify.com -> **Add new site -> Import an existing project -> GitHub** -> pick the repo.
2. Settings come from `netlify.toml` (publish directory `public`, empty build command). Click **Deploy**.
3. Optional: **Site configuration -> Change site name** for a nicer URL. Open it and sign in. Done.
   Every `git push` redeploys automatically.
4. Optional: Supabase -> **Authentication -> URL Configuration** -> set *Site URL* to your Netlify URL.

## 4. Move your old data (one time)
Browser storage is tied to where the old file was opened, so it can't follow you automatically:
- **PC:** put `tools/export-old-data.html` in the same folder as your old file and open it in the
  **same browser** -> Download. In the new app click the **upload icon** (top right) and choose that file.
- **Or console method:** open the old file -> F12 -> Console -> run
  `copy(localStorage.getItem('bc_entries'))` -> paste into Notepad -> save as `old.json` -> import with the upload icon.
- Import is safe to repeat: entries already imported are skipped. Keep your old file until you've checked the totals match.

## 5. Test before relying on it
Sign in -> add one entry of each kind -> check Dashboard totals -> open on your phone (new entries from
another device appear after the refresh icon or when you reopen the tab) -> delete test entries -> Reports -> Print A4.

## Good to know
- **Backups:** the download icon saves all entries as JSON. Do it monthly.
- **Free-tier pause:** Supabase free projects pause after ~7 days of no activity. Daily shop use prevents it;
  if it ever pauses, press *Restore* in the dashboard.
- **Shared data:** every user you add sees the same ledger (intended for partners). No per-user separation.
- "Could not load data / relation entries does not exist" = step 1.2 not run. "Invalid API key" = recheck `config.js`.
- Forgot a password: Supabase -> Authentication -> Users -> menu -> *Send password recovery*, or delete and re-add the user.
