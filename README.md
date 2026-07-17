# K Digital — invitation showcase

Two pages that share one live database:

- **`admin.html`** — where you add, edit, and delete invitations. Passcode-protected.
- **`index.html`** — the public showcase. Read-only, safe to share with anyone.

Anything you save in `admin.html` appears in `index.html` automatically — both pages
read from the same Supabase database. This is what makes them "talk to each other"
once deployed, instead of only working inside Claude.

---

## 1. Create a free Supabase project

1. Go to [supabase.com](https://supabase.com) and sign up (free tier is plenty for this).
2. Click **New project**. Pick any name and password (the password is just for
   Supabase's own dashboard — you won't need it in the code).
3. Wait about a minute for the project to finish setting up.

## 2. Create the database table

1. In your new project, open the **SQL Editor** (left sidebar).
2. Click **New query**.
3. Open `supabase-setup.sql` from this folder, copy all of it, paste it into the editor.
4. Click **Run**.

This creates one table, `invitations`, with a policy that lets the pages read and
write to it.

## 3. Get your API keys

1. In Supabase, go to **Project Settings → API**.
2. Copy the **Project URL** (looks like `https://xxxxx.supabase.co`).
3. Copy the **anon public** key (a long string) — not the `service_role` key.

## 4. Fill in the config

Open **both** `admin.html` and `index.html` in a text editor. Near the top of the
`<script>` section in each, you'll see:

```js
const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
```

Replace both placeholders with the values from step 3. **Both files need the same
values** — that's what lets them share data.

In `admin.html` only, also change:

```js
const ADMIN_PASSCODE = "changeme123";
```

to something only you know.

## 5. Put it on GitHub

1. Create a new repository on GitHub (public or private both work for this).
2. Upload `admin.html` and `index.html` to it (drag-and-drop on the GitHub website
   works fine, or use git if you're comfortable with it).
3. Go to the repo's **Settings → Pages**.
4. Under **Branch**, choose `main` (or `master`) and `/ (root)`, then **Save**.
5. GitHub will give you a URL like `https://yourusername.github.io/your-repo/`.
   That's your public showcase — it loads `index.html` automatically.
6. Your admin page is at `https://yourusername.github.io/your-repo/admin.html`.
   Don't link to it from anywhere; just bookmark it for yourself.

Changes take a minute or two to go live after each upload.

---

## Important limitations, read before you rely on this

**The admin passcode is not real security.** It's a plain string sitting in the
page's JavaScript — anyone who opens "View Page Source" on `admin.html` can read it.
It stops a casual visitor from stumbling in; it will not stop someone who goes
looking. Don't store anything truly sensitive here.

**The database itself is open to anyone with the anon key**, and the anon key is
necessarily visible in your public code (that's normal for this kind of simple
setup, not a mistake). In practice this means: anyone who really wanted to could
read, add, or delete rows in your `invitations` table directly, bypassing your
pages entirely. For a personal invitation showcase this is usually a fine
trade-off for the simplicity — but if you want real protection later, the
upgrade path is **Supabase Auth**: you'd log into `admin.html` with an email
and password, and the database policies would check that login instead of
allowing anyone in. That's a bigger change — ask if you'd like it built.

**Cover images are stored as text (base64)** inside each row, which keeps things
simple but isn't the most space-efficient approach. Supabase's free tier gives
you 500MB of database space, which comfortably fits hundreds of invitations —
but if you ever plan to store thousands of images, moving them to Supabase
Storage (a proper file bucket) would scale better. Not necessary for now.

---

## Files in this folder

- `admin.html` — the admin page
- `index.html` — the public viewer page
- `supabase-setup.sql` — run once in Supabase to create the database table
- `README.md` — this file
