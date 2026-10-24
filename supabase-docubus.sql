-- DocuBus : tables et espace de stockage dans la base Supabase de l'annuaire (Annubus).
-- À coller dans Supabase > SQL Editor > New query, puis « Run ».
-- Prérequis : supabase-schema.sql d'Annubus déjà installé (table « membres », fonctions est_membre() et est_admin()).
-- Peut être relancé sans risque : rien n'est effacé, les données de départ ne sont ajoutées qu'une fois.
--
-- Qui peut faire quoi :
--   - personne sans connexion : rien ;
--   - membre de l'annuaire (table membres) : lire les documents, les destinataires et les textes ;
--   - administrateur (membres.admin) : ajouter, modifier, supprimer.
-- AUCUNE donnée patient n'est enregistrée ici : le formulaire de délivrance reste dans le téléphone.

-- 1. Tables -----------------------------------------------------------------
create table if not exists public.docubus_categories (
  id    text primary key,
  nom   text not null,
  ordre integer not null default 0,
  maj      timestamptz not null default now(),
  maj_par  text
);

create table if not exists public.docubus_documents (
  id          uuid primary key default gen_random_uuid(),
  titre       text not null,
  categorie   text not null references public.docubus_categories(id) on update cascade on delete restrict,
  chemin      text not null unique,          -- emplacement du fichier dans l'espace de stockage « docubus »
  nom_fichier text not null,                 -- nom du fichier tel que déposé
  type        text,
  taille      bigint,
  maj         timestamptz not null default now(),
  maj_par     text
);
-- date d'ajout du document (mise à jour du script : sans effet si la colonne existe déjà)
alter table public.docubus_documents add column if not exists ajoute_le timestamptz not null default now();

create table if not exists public.docubus_destinataires (
  id        uuid primary key default gen_random_uuid(),
  nom       text not null,                   -- nom dans la liste « CSAPA de suivi »
  structure text not null,                   -- nom imprimé sur l'attestation
  attention text not null default '',        -- « À l'attention de », prérempli (facultatif)
  adresses  text[] not null default '{}',
  ordre     integer not null default 0,
  maj       timestamptz not null default now(),
  maj_par   text
);

create table if not exists public.docubus_reglages (
  cle     text primary key,
  valeur  jsonb not null,
  maj     timestamptz not null default now(),
  maj_par text
);

-- 2. Date et auteur de chaque modification, remplis par la base (impossibles à falsifier depuis l'appli)
create or replace function public.docubus_trace()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.maj := now();
  new.maj_par := lower(coalesce(auth.jwt() ->> 'email', 'sql'));
  return new;
end;
$$;
do $$
declare t text;
begin
  foreach t in array array['docubus_categories','docubus_documents','docubus_destinataires','docubus_reglages'] loop
    execute format('drop trigger if exists docubus_trace on public.%I', t);
    execute format('create trigger docubus_trace before insert or update on public.%I for each row execute function public.docubus_trace()', t);
  end loop;
end $$;

-- 3. Règles d'accès -----------------------------------------------------------
alter table public.docubus_categories    enable row level security;
alter table public.docubus_documents     enable row level security;
alter table public.docubus_destinataires enable row level security;
alter table public.docubus_reglages      enable row level security;

do $$
declare t text;
begin
  foreach t in array array['docubus_categories','docubus_documents','docubus_destinataires','docubus_reglages'] loop
    execute format('drop policy if exists "membres lisent" on public.%I', t);
    execute format('create policy "membres lisent" on public.%I for select to authenticated using (public.est_membre())', t);
    execute format('drop policy if exists "admins ajoutent" on public.%I', t);
    execute format('create policy "admins ajoutent" on public.%I for insert to authenticated with check (public.est_admin())', t);
    execute format('drop policy if exists "admins modifient" on public.%I', t);
    execute format('create policy "admins modifient" on public.%I for update to authenticated using (public.est_admin()) with check (public.est_admin())', t);
    execute format('drop policy if exists "admins suppriment" on public.%I', t);
    execute format('create policy "admins suppriment" on public.%I for delete to authenticated using (public.est_admin())', t);
  end loop;
end $$;

-- 4. Espace de stockage privé pour les documents vierges (25 Mo max par fichier)
insert into storage.buckets (id, name, public, file_size_limit)
values ('docubus', 'docubus', false, 26214400)
on conflict (id) do update set public = false, file_size_limit = excluded.file_size_limit;

drop policy if exists "docubus : membres lisent" on storage.objects;
create policy "docubus : membres lisent" on storage.objects
  for select to authenticated using (bucket_id = 'docubus' and public.est_membre());
drop policy if exists "docubus : admins ajoutent" on storage.objects;
create policy "docubus : admins ajoutent" on storage.objects
  for insert to authenticated with check (bucket_id = 'docubus' and public.est_admin());
drop policy if exists "docubus : admins modifient" on storage.objects;
create policy "docubus : admins modifient" on storage.objects
  for update to authenticated using (bucket_id = 'docubus' and public.est_admin()) with check (bucket_id = 'docubus' and public.est_admin());
drop policy if exists "docubus : admins suppriment" on storage.objects;
create policy "docubus : admins suppriment" on storage.objects
  for delete to authenticated using (bucket_id = 'docubus' and public.est_admin());

-- 5. Données de départ (ajoutées seulement si absentes) ------------------------
insert into public.docubus_categories (id, nom, ordre) values
  ('informations',              'Informations',              1),
  ('orientations',              'Orientations',              2),
  ('dossier-inclusion',         'Dossier Inclusion',         3),
  ('delivrance-exceptionnelle', 'Délivrance exceptionnelle', 4),
  ('classeur-bus',              'Classeur bus',              5)
on conflict (id) do nothing;

insert into public.docubus_destinataires (nom, structure, attention, adresses, ordre)
select * from (values
  ('Puget',     'CSAPA Puget Corderie', '', array['infpugetcorderie@ch-edouard-toulouse.fr'], 1),
  ('Dr Lutaud', 'Dr Romain Lutaud',     '', array['dr.lutaud.romain@gmail.com'],              2),
  ('Casanova',  'CSAPA Casanova',       '', array['patrice.garnero@groupe-sos.org'],          3)
) as v(nom, structure, attention, adresses, ordre)
where not exists (select 1 from public.docubus_destinataires);

insert into public.docubus_reglages (cle, valeur) values
  ('envoi', jsonb_build_object('adresses', jsonb_build_array('medical@bus3132.org', 'social@bus3132.org'))),
  ('attestation', jsonb_build_object(
    'nom', 'Bus 31/32',
    'signataire', 'Équipe médicale Bus3132',
    'ville', 'Marseille',
    'entete', jsonb_build_array('Association loi 1901', '129, avenue de Toulon', '13005 MARSEILLE'),
    'pied', jsonb_build_array(
      'Association loi 1901',
      '129 avenue de Toulon – 13005 MARSEILLE',
      'Tél. : 04 86 11 09 14 – Email : bus3132@bus3132.org',
      'SIRET 490 478 062 00014 – APE 8899B')))
on conflict (cle) do nothing;
