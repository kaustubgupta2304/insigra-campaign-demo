# CampaignIQ — Insigra Reports Practical Task

React + Supabase demo with database-enforced company isolation using Row-Level Security (RLS).

## Supabase setup
1. Create a Supabase project.
2. In Authentication > Users, create `alpha@test.com` and `beta@test.com` with separate test-only passwords. Confirm users if required.
3. Copy the actual UUID for each user.
4. Run `supabase/setup.sql` in SQL Editor.
5. Replace the UUID placeholders in this query and run it separately:
```sql
insert into public.profiles (id, company_name) values
('ACTUAL_ALPHA_AUTH_UUID','Alpha Ltd'),
('ACTUAL_BETA_AUTH_UUID','Beta Ltd');
```
6. Copy the project URL and publishable/anon key from Supabase API settings.

## Run locally
Install Node.js 18+ (Node 20+ recommended), then:
```bash
npm install
cp .env.example .env
```
Edit `.env` with your project URL and publishable/anon key:
```env
VITE_SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
VITE_SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_OR_ANON_KEY
```
Then run `npm run dev` and open the local URL Vite prints.

## Test
Sign in as Alpha, verify only Alpha rows appear; sign out and sign in as Beta, verify only Beta rows appear. The frontend intentionally does not filter campaigns by company name; the RLS policy does the enforcement. A user with no profile should see no campaign rows.

## Deploy
Deploy the Vite app to Vercel or Netlify. Set both `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in project environment variables. Never put the Supabase `service_role` key in frontend code or commit `.env`.
