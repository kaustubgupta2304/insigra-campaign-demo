-- 1. Create alpha@test.com and beta@test.com in Supabase Authentication > Users.
-- 2. Copy their real UUIDs. Run the profile INSERT at the bottom separately.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  company_name text not null
);
create table if not exists public.campaign_data (
  id bigint generated always as identity primary key,
  company_name text not null,
  channel text not null,
  leads integer not null default 0 check (leads >= 0)
);
insert into public.campaign_data (company_name, channel, leads) values
('Alpha Ltd','Google',120),('Alpha Ltd','Meta',85),('Alpha Ltd','LinkedIn',45),
('Alpha Ltd','Email',60),('Alpha Ltd','YouTube',30),
('Beta Ltd','Google',70),('Beta Ltd','Meta',110),('Beta Ltd','LinkedIn',90),
('Beta Ltd','Email',40),('Beta Ltd','YouTube',55);
alter table public.profiles enable row level security;
alter table public.campaign_data enable row level security;
drop policy if exists "Users can read their own profile" on public.profiles;
create policy "Users can read their own profile" on public.profiles
for select to authenticated using (id = (select auth.uid()));
drop policy if exists "Users can read their own company campaigns" on public.campaign_data;
create policy "Users can read their own company campaigns" on public.campaign_data
for select to authenticated using (
  company_name = (select p.company_name from public.profiles p where p.id = (select auth.uid()))
);
-- After creating the Auth users, replace the UUIDs and run separately:
-- insert into public.profiles (id, company_name) values
-- ('ACTUAL_ALPHA_AUTH_UUID','Alpha Ltd'), ('ACTUAL_BETA_AUTH_UUID','Beta Ltd');
