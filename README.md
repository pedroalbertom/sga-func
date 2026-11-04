# 🎓 SGA-Func: Sistema de Gestão Acadêmica Funcional

> **Universidade de Fortaleza (UNIFOR)**  
> **Curso:** Análise e Desenvolvimento de Sistemas / Ciência da Computação  
> **Disciplina:** Programação Funcional (2026)  
> **Tecnologias:** Haskell, IHP Framework, PostgreSQL, Nix Flakes, HSpec  

O **SGA-Func** é um sistema acadêmico em **Haskell** utilizando o framework **IHP**, desenvolvido para aplicar na prática os conceitos fundamentais do paradigma funcional na gestão e geração de relatórios de desempenho e frequência.

---

## 📑 Conceitos de Programação Funcional Aplicados

Adotamos a separação entre **Functional Core** (regras de negócio 100% puras em [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs)) e a casca web do IHP para banco e rotas.

| Conceito | Onde está no código | Como explicar ao professor |
| :--- | :--- | :--- |
| **Tipos Algébricos (ADTs)** | [`Academic.hs`](Application/Domain/Academic.hs#L13-L20) | Criamos `Situacao` (`Aprovado`, `ProvaFinal`, `ReprovadoPorNota`, `ReprovadoPorFalta`) e `Conceito` (`A` até `F`) para modelar estados possíveis sem usar strings soltas ou inteiros mágicos. |
| **Currying & Closures** | [`Academic.hs`](Application/Domain/Academic.hs#L27-L38) | `mediaPonderada` recebe pesos e depois as notas. A função `mediaSemestre` é uma closure que fixa os pesos da matéria (`[2, 3, 5]`), exemplificando aplicação parcial de argumentos. |
| **Pattern Matching & Guards** | [`Academic.hs`](Application/Domain/Academic.hs#L45-L66) | `situacaoAluno` usa guards para checar limite de frequência (< 75%) e média (>= 7.0 / >= 4.0). `formataSituacao` usa pattern matching exaustivo nos construtores do ADT. |
| **List Comprehensions** | [`Academic.hs`](Application/Domain/Academic.hs#L73-L89) | `nomesAprovados` e `alunosEmRisco` realizam filtragens e projeções declarativas diretamente sobre listas de tuplas. |
| **Map & Foldr (Agregações)** | [`Academic.hs`](Application/Domain/Academic.hs#L96-L113) | `calcularDesempenho` e `calcularFrequencia` agrupam notas e presenças por aluno em um `Map` com `foldr` e `Map.insertWith (++)`, calculando médias e percentuais via `map`. |
| **Composição de Funções (`.`)** | [`Academic.hs`](Application/Domain/Academic.hs#L116) | `calcularRanking = sortBy (comparing (Down . snd)) . calcularDesempenho` encadeia o cálculo das médias e a ordenação decrescente de forma limpa. |
| **Funções Puras & Imutabilidade** | [`Academic.hs`](Application/Domain/Academic.hs) | Nenhuma função altera dados existentes; todas recebem dados imutáveis e devolvem novos valores, livres de efeitos colaterais. |

---

## 🗄️ Modelo de Dados

O banco relacional em [`Application/Schema.sql`](Application/Schema.sql) organiza as entidades em português:
* `alunos` (nome, matrícula, email)
* `professores` (nome, email)
* `disciplinas` (nome, código, carga horária)
* `turmas` (disciplina, professor, semestre)
* `notas` (aluno, turma, valor, descrição)
* `frequencias` (aluno, turma, data, presente)

As fixtures em [`Application/Fixtures.sql`](Application/Fixtures.sql) inserem dados para teste com perfis reais (alunos aprovados, em prova final e reprovados por falta).

---

## 🚀 Como Executar

### 1. Iniciar o Servidor
```bash
./start
```
* **Aplicação Web:** `http://localhost:8000`
* **Painel do IHP:** `http://localhost:8001`

### 2. Navegação nos Relatórios
A navegação é dinâmica:
* **Página Inicial (`/`):** Lista todas as turmas cadastradas com botões diretos para `[ Ver Desempenho ]` e `[ Ver Frequência ]`.
* **Ranking Geral (`/Ranking`):** Exibe a classificação geral de todos os alunos ordenada por média.

### 3. Executar os Testes Unitários
```bash
nix flake check --impure
```

---

## 🎤 Roteiro Simples para Apresentar ao Professor (5 Minutos)

1. **Abertura (1 min)**:
   > *"Nosso projeto é o SGA-Func, desenvolvido em Haskell com IHP. Escolhemos a stack para aproveitar tipagem estática e imutabilidade nativa."*
2. **Núcleo Funcional (2 min)** — Abrir `Application/Domain/Academic.hs`:
   > *"Separamos a lógica em funções puras. Criamos o tipo algébrico `Situacao` e usamos guards em `situacaoAluno`. Aplicamos currying em `mediaPonderada` e closure em `mediaSemestre`. E implementamos exatamente as funções do slide (`calcularDesempenho`, `calcularFrequencia` e `calcularRanking`) usando foldr, map e composição de funções."*
3. **Testes Unitários (1 min)** — Abrir `Test/AcademicSpec.hs`:
   > *"Como as funções são puras, escrevemos testes com HSpec validando currying, list comprehensions e aprovações sem precisar de mocks ou banco."*
4. **Demonstração Web (1 min)** — Abrir `http://localhost:8000`:
   > *"No navegador, a Home lista as turmas. Ao clicar em 'Ver Desempenho' e 'Ver Frequência', os relatórios calculam os resultados em tempo real. No 'Ranking Geral', o pódio é gerado por composição funcional."*

## Sprint 2 — CRUD de estudantes e cursos

A navegação agora inclui **Estudantes** (`/Alunos`) e **Cursos** (`/Cursos`), com criação, busca, detalhes, edição e exclusão. Os estudantes reutilizam `alunos`; cursos são independentes de disciplinas. O vínculo estudante/curso é opcional para preservar os cadastros existentes.

A aplicação exige login em `/NewSession`. O perfil `admin` gerencia os cadastros; `consulta` lê cadastros e relatórios. Novas contas podem ser criadas com `Application/Script/CreateUser.hs`. Para desenvolvimento e testes locais, [`Application/Fixtures.sql`](Application/Fixtures.sql) fornece as contas de demonstração:
* **Administrador:** `admin@example.com` / `senha-de-teste-123`
* **Consulta:** `consulta@example.com` / `senha-de-teste-123`

- [Slides da apresentação (HTML)](docs/apresentacao-sprint-2.html) e [notas da apresentação](docs/sprint-2-apresentacao.md)
- [Preparação e roteiro da demo](docs/sprint-2-demo.md)
- [Domínio: validações e consultas com map, filter, foldr e concatMap](Application/Domain/Catalog.hs)
- [Testes de domínio](Test/CatalogSpec.hs) e [integração](Test/Integration.hs)

A integridade é validada no servidor e no PostgreSQL por `CHECK`, `UNIQUE` e chaves estrangeiras. Cursos com estudantes e estudantes com histórico acadêmico não podem ser excluídos. O comando de verificação continua sendo `nix flake check --impure`.

---

## 🛡️ Sprint 3 — Tópicos Avançados & Segurança

A Sprint 3 incorpora os conceitos de ponta do paradigma funcional e introduz criptografia de campos confidenciais:
* **Monads**: `Reader AcademicConfig` para injeção pura de parâmetros institucionais e `Either Text a` para pipelines de validação encadeada (*Railway-Oriented Programming*).
* **Functors**: Mapeamento e transformação sobre coleções e tipos customizados (`ItemRelatorio a`).
* **Continuation Passing Style (CPS)**: Implementação de fluxo de matrícula em `realizarMatriculaCPS` com continuações de sucesso e falha explicitadas.
* **Lazy Evaluation**: Gerador infinito de protocolos sob demanda (`geradorProtocolos`) consumido via `take n`.
* **Criptografia Simétrica & Segurança**: Cifragem reversível do documento do aluno (CPF/RG) via keystream cipher puro no banco de dados. Exibição descriptografada para `admin` e mascaramento automático para `consulta`.

- [Slides da apresentação Sprint 3 (HTML)](docs/apresentacao-sprint-3.html) e [notas da apresentação](docs/sprint-3-apresentacao.md)
- [Roteiro prático da demo da Sprint 3](docs/sprint-3-demo.md)
- [Domínio avançado: Monads, CPS, Lazy Evaluation](Application/Domain/Advanced.hs)
- [Domínio de segurança: Criptografia e mascaramento](Application/Domain/Security.hs)
- [Testes unitários da Sprint 3](Test/AdvancedSpec.hs) e [Testes de segurança](Test/SecuritySpec.hs)

---

## 📊 Sprint 4 — Frontend Completo, SSR & Relatórios

A Sprint 4 conclui o sistema com uma visão panorâmica e interativa da instituição:
* **Dashboard Acadêmico (`/Dashboard`)**: Agregações puras de KPIs globais (média geral institucional, taxa de aprovação, contagem de turmas e alunos em risco).
* **Consolidação por Curso**: Tabela com total de alunos e média ponderada agrupada por curso.
* **Pódio & Atenção Pedagógica**: Ranking dos maiores desempenhos e tabela filtrada de estudantes em situação de risco (reprovação ou final).
* **Filtros Dinâmicos**: Filtragem por curso em tempo real diretamente na interface SSR.
* **Componentes Reativos**: Simulador interativo de notas e frequência no frontend sem requisição ao servidor, além de suporte a AutoRefresh com WebSockets/morphdom do IHP.

- [Slides da apresentação Sprint 4 (HTML)](docs/apresentacao-sprint-4.html) e [notas da apresentação](docs/sprint-4-apresentacao.md)
- [Roteiro prático da demo da Sprint 4](docs/sprint-4-demo.md)
- [Domínio do Dashboard: agregações puras e métricas](Application/Domain/Dashboard.hs)
- [View SSR em HSX do Dashboard](Web/View/Dashboard/Index.hs)
- [Testes de unidade do Dashboard](Test/DashboardSpec.hs)
