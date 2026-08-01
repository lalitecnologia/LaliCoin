-- =========================================================
-- LaliCoin — Setup do banco (Supabase)
-- Rode este script inteiro no SQL Editor do seu projeto Supabase
-- =========================================================

-- Tabela de perfis (papel do usuário: C = criador, U = usuário)
create table if not exists profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  nome text,
  tipo text not null default 'U' check (tipo in ('C','U')),
  created_at timestamp with time zone default now()
);

-- Tabela de miners cadastrados por cada usuário
create table if not exists miners (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  nome text not null,
  poder numeric not null,
  unidade text not null default 'H/s',
  poder_hs numeric not null default 0,
  bonus numeric not null,
  created_at timestamp with time zone default now()
);

-- Se a tabela miners já existia (projeto criado antes desta atualização),
-- rode as duas linhas abaixo para adicionar as colunas novas sem perder dados:
alter table miners add column if not exists unidade text not null default 'H/s';
alter table miners add column if not exists poder_hs numeric not null default 0;

-- =========================================================
-- Row Level Security
-- =========================================================
alter table profiles enable row level security;
alter table miners enable row level security;

create policy "Usuário vê o próprio perfil"
  on profiles for select
  using (auth.uid() = id);

create policy "Usuário cria o próprio perfil"
  on profiles for insert
  with check (auth.uid() = id);

create policy "Usuário atualiza o próprio perfil"
  on profiles for update
  using (auth.uid() = id);

create policy "Usuário gerencia os próprios miners"
  on miners for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- =========================================================
-- Depois de rodar este script:
-- 1) Crie sua conta normalmente pelo app (ela entra como tipo 'U').
-- 2) No SQL Editor, promova sua conta para criadora trocando o e-mail abaixo:
--
--    update profiles set tipo = 'C' where email = 'seu-email@exemplo.com';
--
-- =========================================================
