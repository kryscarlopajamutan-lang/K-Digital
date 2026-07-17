-- Run this once in your Supabase project's SQL Editor
-- (Project → SQL Editor → New query → paste this in → Run).
-- It creates the one table K Digital needs, plus open read/write policies.

create table if not exists invitations (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  occasion text not null default 'other',
  custom_occasion text,
  event_date date,
  link text,
  note text,
  cover_image text,
  created_at timestamptz not null default now()
);

alter table invitations enable row level security;

-- Anyone can read (this is what lets the public viewer page work)
create policy "Public can read invitations"
  on invitations for select
  using (true);

-- Anyone with the anon key can write (this is what lets the admin page work,
-- but note it is NOT restricted to just you — see README.md for what this means)
create policy "Public can write invitations"
  on invitations for all
  using (true)
  with check (true);
