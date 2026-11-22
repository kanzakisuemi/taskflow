# TaskFlow

Aplicação web para gerenciar projetos e tarefas. Cada projeto tem um usuário responsável e várias tarefas, que podem ser atribuídas a usuários. O sistema calcula o percentual de conclusão de cada projeto e destaca as tarefas atrasadas.

Trabalho da disciplina Projeto de Desenvolvimento de Software I (UniFil).

## Autoria

- Julia Suemi Kanzaki

## Stack

- Ruby 3.1.2 e Ruby on Rails 7.0
- PostgreSQL
- ERB, Hotwire/Turbo e CSS próprio
- Minitest

## Como rodar

Pré-requisitos: Ruby 3.1.2 e PostgreSQL rodando localmente.

```bash
bundle install
bin/rails db:setup   # cria o banco, roda as migrations e carrega os dados de exemplo
bin/rails server
```

Acesse http://localhost:3000.

Para recarregar os dados de exemplo: `bin/rails db:reset`.

## Testes

```bash
bin/rails test
```

## Casos de uso

| UC | Nome | Onde |
|---|---|---|
| UC01 | Gerenciar usuários | `/usuarios` |
| UC02 | Gerenciar projetos | `/projetos` (a página do projeto lista as tarefas e o % de conclusão) |
| UC03 | Gerenciar tarefas | "Nova tarefa" na página do projeto; editar e excluir na página da tarefa |
| UC04 | Atualizar status da tarefa | Seletor de status na lista do projeto e na página da tarefa |
| UC05 | Consultar e filtrar tarefas | `/tarefas`, com filtros por status, prioridade, projeto e responsável |

## Regras de negócio

- E-mail do usuário obrigatório, válido e único.
- Projeto exige nome e responsável. A data de término prevista não pode ser anterior à de início.
- Tarefa nasce pendente e exige título. O responsável é opcional.
- Usuário com projetos não pode ser excluído. Ao excluir um usuário, suas tarefas ficam sem responsável.
- Excluir um projeto exclui suas tarefas.
- Tarefa atrasada: prazo anterior a hoje e status diferente de concluída.
- % de conclusão: tarefas concluídas ÷ total × 100 (0 quando não há tarefas).

## Documentação

- [Diagramas (DER, classes, casos de uso, atividade e sequência)](docs/diagramas.md)
- [Documentação completa (PDF)](docs/TaskFlow_Documentacao.pdf)
