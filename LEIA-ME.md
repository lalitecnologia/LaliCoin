# LaliCoin — Como configurar

## 1. Crie um projeto no Supabase
Se for usar um projeto novo (separado do LaliChangeViews), crie em https://supabase.com.
Se preferir, pode usar o mesmo projeto do LaliChangeViews — as tabelas `profiles` e `miners`
deste app têm nomes independentes e não conflitam com as tabelas existentes.

## 2. Rode o schema
Abra o **SQL Editor** do projeto e execute o arquivo `lalicoin-schema.sql`. Ele cria:
- `profiles` — guarda o tipo de cada usuário (`C` = criador, `U` = usuário)
- `miners` — guarda nome, poder e bônus de cada miner cadastrado

## 3. Configure as credenciais no app
Abra `lalicoin.html` e substitua no topo do `<script>`:

```js
const SUPABASE_URL = "SUA_SUPABASE_URL_AQUI";
const SUPABASE_ANON_KEY = "SUA_SUPABASE_ANON_KEY_AQUI";
```

Esses valores estão em **Project Settings → API** no painel do Supabase.

## 4. Vire o criador (C)
1. Abra o app e crie sua conta normalmente (todo cadastro entra como `U`).
2. No SQL Editor do Supabase, rode:
```sql
update profiles set tipo = 'C' where email = 'seu-email@exemplo.com';
```
3. Saia e entre de novo no app — o selo no topo vai mostrar "Criador".

## 5. Publique no GitHub Pages
Suba o `lalicoin.html` (renomeado para `index.html` se quiser) no mesmo padrão que você já usa
para o LaliChangeViews.

## Como funciona o cálculo do rack
- Você cadastra os miners com **nome**, **poder** e **percentual de bônus**.
- Na tela "Cálculo", o app testa todas as combinações possíveis de 4 miners.
- Combinações com **dois miners de mesmo nome são descartadas** (não podem ocupar o rack juntos).
- Para cada combinação válida: soma o poder dos 4, soma os bônus dos 4, e aplica o bônus total
  sobre o poder total (`poder_total × (1 + bônus_total / 100)`).
- A combinação com o maior valor final é apresentada como a melhor, com as próximas 5 melhores
  listadas logo abaixo para comparação.
