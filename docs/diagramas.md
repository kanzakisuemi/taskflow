# TaskFlow – Diagramas


### DER
```mermaid
erDiagram
    USUARIOS ||--o{ PROJETOS : "e responsavel por"
    PROJETOS ||--o{ TAREFAS : contem
    USUARIOS |o--o{ TAREFAS : executa

    USUARIOS {
        bigint id PK
        string nome
        string email UK
        datetime created_at
        datetime updated_at
    }
    PROJETOS {
        bigint id PK
        string nome
        text descricao
        int status "0 ativo, 1 concluido, 2 arquivado"
        date data_inicio
        date data_fim_prevista
        bigint usuario_id FK
    }
    TAREFAS {
        bigint id PK
        string titulo
        text descricao
        int status "0 pendente, 1 em_andamento, 2 concluida"
        int prioridade "0 baixa, 1 media, 2 alta"
        date prazo
        bigint projeto_id FK
        bigint usuario_id FK "opcional"
    }
```

### Diagrama de classes
```mermaid
classDiagram
    class Usuario {
        -Integer id
        -String nome
        -String email
        +valid?() Boolean
    }
    class Projeto {
        -Integer id
        -String nome
        -Text descricao
        -StatusProjeto status
        -Date data_inicio
        -Date data_fim_prevista
        +percentual_concluido() Integer
    }
    class Tarefa {
        -Integer id
        -String titulo
        -Text descricao
        -StatusTarefa status
        -Prioridade prioridade
        -Date prazo
        +atrasada?() Boolean
        +filtrar(params) Relation
    }
    Usuario "1" --> "0..*" Projeto : responsavel
    Projeto "1" *-- "0..*" Tarefa : possui
    Usuario "0..1" --> "0..*" Tarefa : executa
```

### Casos de uso
```mermaid
flowchart LR
    U(["Usuário"])
    subgraph S["Sistema TaskFlow"]
        UC1(["UC01 – Gerenciar usuários"])
        UC2(["UC02 – Gerenciar projetos"])
        UC3(["UC03 – Gerenciar tarefas"])
        UC4(["UC04 – Atualizar status da tarefa"])
        UC5(["UC05 – Consultar e filtrar tarefas"])
    end
    U --- UC1 & UC2 & UC3 & UC4 & UC5
    UC4 -. "«extend»" .-> UC3
```

### Atividade (fluxo principal)
```mermaid
flowchart TD
    A([Início]) --> B[Acessar lista de projetos]
    B --> C{Projeto já existe?}
    C -- Não --> D[Preencher dados do projeto]
    D --> E{Dados válidos?}
    E -- Não --> F[Exibir erros] --> D
    E -- Sim --> G[Salvar projeto]
    C -- Sim --> H[Abrir o projeto]
    G --> H
    H --> I[Clicar em Nova tarefa]
    I --> J[Informar título, prioridade, prazo e responsável]
    J --> K{Dados válidos?}
    K -- Não --> L[Exibir erros] --> J
    K -- Sim --> M[Salvar tarefa - status Pendente]
    M --> N[Exibir tarefa na lista do projeto]
    N --> O{Atualizar status de uma tarefa?}
    O -- Não --> Z([Fim])
    O -- Sim --> P[Selecionar novo status]
    P --> Q[Salvar novo status]
    Q --> R[Recalcular % de conclusão]
    R --> S{Todas concluídas?}
    S -- Não --> O
    S -- Sim --> T[Marcar projeto como concluído - opcional]
    T --> Z
```

### Sequência – UC01 (cadastrar usuário)
```mermaid
sequenceDiagram
    actor U as Usuário
    participant V as View (ERB)
    participant C as Controller
    participant M as Model
    participant B as Banco (PostgreSQL)
    U->>V: Preencher formulário
    V->>C: POST /usuarios
    C->>M: Usuario.new(params).save
    M->>M: validar nome e e-mail
    alt dados válidos
        M->>B: INSERT INTO usuarios
        B-->>M: registro gravado
        M-->>C: true
        C->>V: redirect_to @usuario
        V-->>U: Usuário criado com sucesso
    else dados inválidos
        M-->>C: false (errors)
        C->>V: render :new
        V-->>U: Exibe erros de validação
    end
```

### Sequência – UC02 (criar projeto)
```mermaid
sequenceDiagram
    actor U as Usuário
    participant V as View (ERB)
    participant C as Controller
    participant M as Model
    participant B as Banco (PostgreSQL)
    U->>V: Preencher dados do projeto
    V->>C: POST /projetos
    C->>M: Projeto.new(params).save
    M->>M: validar nome e responsável
    alt dados válidos
        M->>B: INSERT INTO projetos
        B-->>M: registro gravado
        M-->>C: true
        C->>V: redirect_to @projeto
        V-->>U: Projeto criado com sucesso
    else dados inválidos
        M-->>C: false (errors)
        C->>V: render :new
        V-->>U: Exibe erros de validação
    end
```

### Sequência – UC03 (criar tarefa)
```mermaid
sequenceDiagram
    actor U as Usuário
    participant V as View (ERB)
    participant C as Controller
    participant M as Model
    participant B as Banco (PostgreSQL)
    U->>V: Preencher dados da tarefa
    V->>C: POST /projetos/:id/tarefas
    C->>M: Projeto.find(id)
    M->>B: SELECT * FROM projetos
    B-->>M: projeto
    C->>M: tarefas.build(params).save
    M->>M: validar título e prazo
    alt dados válidos
        M->>B: INSERT INTO tarefas
        B-->>M: gravada (status pendente)
        M-->>C: true
        C->>V: redirect_to @projeto
        V-->>U: Tarefa criada com sucesso
    else dados inválidos
        M-->>C: false (errors)
        C->>V: render :new
        V-->>U: Exibe erros de validação
    end
```

### Sequência – UC04 (atualizar status)
```mermaid
sequenceDiagram
    actor U as Usuário
    participant V as View (ERB)
    participant C as Controller
    participant M as Model
    participant B as Banco (PostgreSQL)
    U->>V: Escolher novo status
    V->>C: PATCH /tarefas/:id/atualizar_status
    C->>M: Tarefa.find(id)
    M->>B: SELECT * FROM tarefas
    B-->>M: tarefa
    C->>M: tarefa.update(status:)
    M->>M: validar status
    alt status válido
        M->>B: UPDATE tarefas SET status
        B-->>M: atualizada
        M-->>C: true
        C->>V: redirect_to projeto
        V-->>U: Exibe novo status e %
    else status inválido
        M-->>C: false (errors)
        C->>V: render erro
        V-->>U: Exibe mensagem de erro
    end
```

### Sequência – UC05 (consultar e filtrar)
```mermaid
sequenceDiagram
    actor U as Usuário
    participant V as View (ERB)
    participant C as Controller
    participant M as Model
    participant B as Banco (PostgreSQL)
    U->>V: Informar filtros
    V->>C: GET /tarefas?filtros
    C->>M: Tarefa.filtrar(params)
    M->>M: encadear scopes
    M->>B: SELECT ... WHERE filtros
    B-->>M: registros filtrados
    M-->>C: coleção de tarefas
    C->>V: render :index
    V-->>U: Lista de tarefas filtrada
```

