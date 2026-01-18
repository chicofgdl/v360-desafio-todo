# V360 Desafio – To-Do App

Aplicação **To-Do fullstack** desenvolvida com **Ruby on Rails**.

Implementação de uma To-do list.

---

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

## Pré-requisitos

- Ruby 3.4.8
- Rails 8.1.2
- Bundler
- SQLite
- Git

> Em ambiente Windows, recomenda-se o uso de **WSL2 (Ubuntu)**.

## Setup Local

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

Development / Test: SQLite

Production: PostgreSQL (a definir)

## Testes

⚠️ Ainda não implementado

Estratégia de testes (ex: RSpec / Minitest) será definida em versões futuras.

## Autenticação e Autorização

⚠️ Ainda não implementado

Planejado:

Autenticação de usuários

Controle de permissões por recurso

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
