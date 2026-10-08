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
* **Ranking Geral (`/Relatorios/Ranking`):** Exibe a classificação geral de todos os alunos ordenada por média.

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
