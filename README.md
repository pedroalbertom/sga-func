# 🎓 SGA-Func: Sistema de Gestão Acadêmica Funcional

> **Universidade de Fortaleza (UNIFOR)**  
> **Curso:** Análise e Desenvolvimento de Sistemas / Ciência da Computação  
> **Disciplina:** Programação Funcional (2026)  
> **Tecnologias:** Haskell, IHP Framework, PostgreSQL, Nix Flakes, HSpec  

O **SGA-Func** é um sistema acadêmico desenvolvido em **Haskell** utilizando o framework **IHP (Integrated Haskell Platform)**, concebido para demonstrar na prática os fundamentos do paradigma funcional aplicados à gestão e geração de relatórios de desempenho escolar.

---

## 📑 Sumário dos Conceitos de Programação Funcional Aplicados

O projeto adota rigorosamente a arquitetura **Functional Core / Imperative Shell**, mantendo todas as regras de negócio em funções 100% puras no módulo [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs), enquanto o IHP lida com a persistência e renderização web.

| Conceito Funcional | Onde está no código | Descrição Prática |
| :--- | :--- | :--- |
| **Tipos Algébricos (ADTs) & Records** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs#L28-L55) | Modela `SituacaoAcademica` (`Aprovado`, `ProvaFinal`, `Reprovado...`), `Conceito` (`A` a `F`) e o record puro `AlunoDesempenho`. |
| **Closures e Currying** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs#L65-L84) | Função curried de alta ordem `calcularMediaPonderada` e closure especializada `calculadoraMediaSemestral` pré-fixada com pesos `[2.0, 3.0, 5.0]`. |
| **Pattern Matching & Guards** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs#L95-L135) | `avaliarSituacao` com guards para corte institucional, `classificarConceito` e casamento de padrão exaustivo em `formatarSituacao`. |
| **List Comprehensions** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs#L143-L162) | Filtragem declarativa de `obterNomesAprovados` e identificação com let binding em `obterAlunosEmRisco`. |
| **Transformação (`map`)** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs#L173-L197) | Converte agrupamentos em tuplas `(Id Aluno, Double)` com as médias e percentuais calculados. |
| **Agregação (`foldr`)** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs#L173-L197) | Reduz listas de notas e presenças agrupando por chave de aluno em `Map` via `Map.insertWith (++)`. |
| **Composição de Funções (`.`)** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs#L201-L203) | `ordenarRanking = sortBy (comparing (Down . snd))` encadeando operações sem variáveis intermediárias. |
| **Imutabilidade e Pureza** | [`Application/Domain/Academic.hs`](Application/Domain/Academic.hs) | Nenhuma função altera dados existentes no banco ou em memória; transformações geram novas estruturas. |

---

## 🗄️ Modelo de Dados (PostgreSQL + IHP Schema)

O esquema relacional em [`Application/Schema.sql`](Application/Schema.sql) estrutura as seguintes entidades:
* **Alunos**: `id`, `nome`, `matricula`, `email`
* **Professores**: `id`, `nome`, `email`
* **Disciplinas**: `id`, `nome`, `codigo`, `carga_horaria`
* **Turmas**: `id`, `disciplina_id`, `professor_id`, `semestre`
* **Notas**: `id`, `aluno_id`, `turma_id`, `valor`, `descricao`
* **Frequências**: `id`, `aluno_id`, `turma_id`, `data`, `presente`

As fixtures pré-configuradas em [`Application/Fixtures.sql`](Application/Fixtures.sql) carregam alunos com perfis de notas e frequências variados (aprovados, prova final e reprovados por falta) para viabilizar testes imediatos.

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
* Nix com suporte a flakes e devenv instalados.

### 1. Iniciar o Servidor de Desenvolvimento
No diretório do projeto, execute:
```bash
./start
```
O servidor IHP iniciará na porta padrão:
* **Aplicação Web:** `http://localhost:8000`
* **Painel do Desenvolvedor (Schema Designer / Code Generator):** `http://localhost:8001`

### 2. Rotas dos Relatórios Disponíveis
Com o servidor rodando e as fixtures carregadas:
* **Ranking Geral:** [`/Relatorios/Ranking`](http://localhost:8000/Relatorios/Ranking)
* **Desempenho da Turma:** [`/Relatorios/Desempenho?turmaId=d1111111-1111-1111-1111-111111111111`](http://localhost:8000/Relatorios/Desempenho?turmaId=d1111111-1111-1111-1111-111111111111)
* **Frequência da Turma:** [`/Relatorios/Frequencia?turmaId=d1111111-1111-1111-1111-111111111111`](http://localhost:8000/Relatorios/Frequencia?turmaId=d1111111-1111-1111-1111-111111111111)

### 3. Executar os Testes Automatizados (HSpec)
Para validar o núcleo funcional puro e os testes do projeto:
```bash
nix flake check --impure
```

---

## 🎤 Roteiro Sugerido para Apresentação Oral (5 Minutos)

1. **Minuto 1: Contexto e Fundamentação (Ambiente)**
   - Apresente o projeto: Sistema de Gestão Acadêmica Funcional (SGA-Func) feito em Haskell + IHP.
   - Explique a escolha da stack: Tipagem estática forte, imutabilidade por padrão e reprodutibilidade de ambiente via Nix.
2. **Minuto 2: Núcleo Funcional Puro (`Application/Domain/Academic.hs`)**
   - Mostre o código de domínio isolado:
     - Os Tipos Algébricos de Dados (`SituacaoAcademica` e `Conceito`).
     - A função curried `calcularMediaPonderada` e a closure `calculadoraMediaSemestral`.
     - O uso de List Comprehension para filtrar alunos em risco.
     - As agregações com `foldr` e `map` recomendadas pelo guia da disciplina.
3. **Minuto 3: Verificação por Testes Unitários (`Test/AcademicSpec.hs`)**
   - Destaque que as funções puras são trivialmente testáveis sem precisar subir banco ou mockar requisições.
   - Demonstre a execução dos testes cobrindo todos os cenários da ementa.
4. **Minuto 4: Demonstração Prática no Navegador (Demo)**
   - Acesse a Home (`http://localhost:8000`), mostrando a barra de navegação integrada.
   - Clique no **Relatório de Desempenho**: mostre o cálculo de médias por aluno e o card de média geral da turma.
   - Clique no **Relatório de Frequência**: aponte a barra de progresso visual com o badge de risco de reprovação para quem tem menos de 75%.
   - Clique no **Ranking Geral**: mostre a ordenação decrescente por média calculada via composição funcional com as medalhas de destaque.
5. **Minuto 5: Conclusão e Encerramento**
   - Recapitule como o paradigma funcional previne bugs em cálculos críticos e deixe aberto para perguntas do professor.
