# V360 Desafio – To-Do App

Aplicação **To-Do fullstack** desenvolvida com **Ruby on Rails**.

Implementação de uma To-do list.

---

## Demo

Deploy: https://v360-desafio-todo.onrender.com

## GitHub Projects

Projeto: https://github.com/users/chicofgdl/projects/3

## Sumário

- [Demo](#demo)
- [GitHub Projects](#github-projects)
- [Principais funcionalidades](#principais-funcionalidades)
- [Stack](#stack)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Icones](#icones)
- [Pré-requisitos](#pré-requisitos)
- [Setup Local](#setup-local)
- [Autenticação e Autorização](#autenticação-e-autorização)
- [IA - Sugestão de tasks](#ia---sugestão-de-tasks)
- [Banco de Dados](#banco-de-dados)
- [Testes](#testes)
- [User Stories](#user-stories)
- [Fluxo de Trabalho (Issues, Branches, Commits e PRs)](#fluxo-de-trabalho-issues-branches-commits-e-prs)
- [Autor](#autor)

## Principais funcionalidades

- Autenticação com Devise (cadastro, login e recuperação de senha).
- Listas por usuário com criação, edição, exclusão e validação de títulos únicos.
- Tasks com conclusão, favoritos, data de vencimento e drag and drop para reordenação.
- Filtros (hoje, em breve, atrasadas, favoritas) e busca por listas/tarefas.
- Sugestões de tasks com IA por lista, evitando duplicadas.

## Stack

- **Ruby**: 3.4.8  
- **Rails**: 8.1.2  
- **Banco de dados (dev/test)**: SQLite  
- **Frontend**: Hotwire (Turbo + Stimulus)  
- **CSS**: Tailwind CSS  
- **Gerenciador de versões Ruby**: Mise  

## Estrutura do Projeto

O projeto segue a arquitetura padrão do **Ruby on Rails (MVC)**:

- **Models**: regras de negócio e persistência
- **Controllers**: orquestração de requisições HTTP
- **Views**: renderização de HTML com suporte a Turbo

## Estrutura de pastas

```text
.
├── app/        # MVC, views e assets
├── bin/        # scripts executáveis
├── config/     # configuração do app e rotas
├── db/         # migrations e dados locais
├── lib/        # código de suporte
├── log/        # logs do ambiente
├── public/     # arquivos estáticos
├── script/     # scripts auxiliares
├── storage/    # Active Storage local
├── tmp/        # arquivos temporários
├── vendor/     # dependências vendorizadas
├── Gemfile
├── Gemfile.lock
└── README.md
```

## Icones

Os SVGs ficam centralizados em `app/views/shared/icons` e devem ser reutilizados
via `render`. Use `currentColor` nos paths para manter compatibilidade com
classes do Tailwind.

Exemplos:

```erb
<%= render "shared/icons/search" %>
<%= render "shared/icons/star", class_name: "h-4 w-4", filled: true, stroke: false %>
```

## Pré-requisitos

- Ruby 3.4.8
- Rails 8.1.2
- Bundler
- SQLite
- Git

> Em ambiente Windows, recomenda-se o uso de **WSL2 (Ubuntu)**.

## Setup Local

Antes de subir a aplicação, configure as variáveis em `.env` (veja `.env.example`).

```bash
# Instalar dependências
bundle install

# Criar e preparar o banco de dados
rails db:create
rails db:migrate

# Subir o servidor
rails s
```

## Banco de Dados

- Development / Test: SQLite
- Production: SQLite (padrão no `config/database.yml`, ajustável conforme infraestrutura)

## Testes

⚠️ Ainda não implementado

Estratégia de testes (ex: RSpec / Minitest) será definida em versões futuras.

## Autenticação e Autorização

- Devise com cadastro, login, recuperação de senha e sessão persistente.
- Escopo por usuário: listas e tarefas ficam vinculadas ao usuário autenticado.
- Em desenvolvimento, o app cria e autentica automaticamente `dev@example.com` (senha `password`).

## IA - Sugestão de tasks

A geração de tasks usa a OpenAI para sugerir itens com base no título da lista e no contexto atual.

Como usar na interface:

1. Abra uma lista.
2. Clique em **Sugerir tasks** para gerar sugestões.
3. As sugestões são inseridas na lista e duplicadas são ignoradas.

Configuração:

- `OPENAI_API_KEY` (obrigatória)
- `AI_SUGGEST_MOCK=true` para rodar sem API (gera sugestões locais)
- Opcionais: `AI_SUGGEST_MODEL`, `AI_SUGGEST_TEMPERATURE`, `AI_SUGGEST_MAX`, `AI_SUGGEST_CONTEXT_MAX`, `AI_SUGGEST_TIMEOUT`

## User Stories
#### Épico: Gerenciamento de Listas

US-01 — Criar lista
> Como usuário, quero criar uma nova lista para organizar minhas tarefas por contexto.

US-02 — Visualizar listas
> Como usuário, quero ver todas as minhas listas para escolher em qual trabalhar.

US-03 — Renomear lista
> Como usuário, quero renomear uma lista para refletir melhor seu propósito.

US-04 — Deletar lista
> Como usuário, quero deletar uma lista para remover conjuntos de tarefas que não são mais relevantes.

#### Épico: Gerenciamento de Tasks
US-05 — Criar task em uma lista
>Como usuário, quero criar uma task dentro de uma lista para registrar algo que preciso fazer.

US-06 — Visualizar tasks da lista
>Como usuário, quero ver todas as tasks de uma lista para acompanhar meu progresso.

US-07 — Editar task
>Como usuário, quero editar uma task (título, descrição ou prazo) para manter as informações atualizadas.

US-08 — Marcar task como concluída
>Como usuário, quero marcar uma task como concluída para sinalizar que ela foi finalizada.

US-09 — Deletar task
>Como usuário, quero deletar uma task para remover algo que não preciso mais fazer.

#### Épico: Organização e Ordem

US-10 — Reordenar tasks
> Como usuário, quero reordenar as tasks dentro de uma lista para priorizar o que é mais importante.

US-11 — Reordenar listas
> Como usuário, quero reordenar minhas listas para organizar melhor meus contextos de trabalho.

## Fluxo de Trabalho (Issues, Branches, Commits e PRs)

Este projeto segue um fluxo simples e explícito para organização do desenvolvimento, priorizando rastreabilidade entre **issues → branches → commits → PRs**.

---

### Issue

Cada issue deve descrever claramente o objetivo, critérios de aceite e impactos técnicos.

#### Template de Issue

```md
## Goal
<Descrever em 1 frase o resultado esperado>

## Acceptance Criteria
- [ ] ...
- [ ] ...
- [ ] ...

## Technical Checklist
- [ ] DB / migration (se aplicável)
- [ ] Model + validações (se aplicável)
- [ ] Controller / Routes
- [ ] Views / Partials ou Turbo
- [ ] Teste mínimo (se aplicável)
- [ ] Ajuste de README (se aplicável)

## Out of scope
- ...
```

### Branch

Cada issue deve possuir uma branch associada, seguindo o padrão:
```
<tipo>/<slug>-#<ID>
```
### Commit
Formato
```
<tipo>: <mensagem curta no imperativo>
```
Tipos de commit utilizados
```
feat: nova funcionalidade
fix: correção de bug
test: testes automatizados
refactor: refatoração sem mudança de comportamento
chore: configuração, build ou dependências
docs: documentação
style: formatação, lint ou ajustes não funcionais
```
### Pull Request (PR)
Título do PR
```
O título deve refletir claramente a principal entrega da issue.
```
Exemplos
```
feat: CRUD de listas
test: specs de models
chore: setup inicial do projeto
deploy: render + postgres
docs: completar README
```
## Autor

Francisco Gabriel | Desenvolvedor Fullstack
