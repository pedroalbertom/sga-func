# SGA-Func — Sistema de Gestão Acadêmica

Sistema acadêmico desenvolvido em **Haskell** com **IHP Framework**, **PostgreSQL**, **Nix Flakes** e **HSpec** para a disciplina de Programação Funcional (UNIFOR, 2026).

---

## Como Executar

```bash
./start
```

* **Aplicação Web:** `http://localhost:8000`
* **Painel do IHP:** `http://localhost:8001`

### Contas de Teste (`/NewSession`)

As fixtures em [`Application/Fixtures.sql`](Application/Fixtures.sql) carregam duas contas locais (senha padrão: `senha-de-teste-123`):
* **Administrador (`admin`):** `admin@example.com` — acesso completo aos cadastros, documentos e relatórios.
* **Consulta (`consulta`):** `consulta@example.com` — somente leitura; documentos confidenciais aparecem mascarados.

Novas contas podem ser criadas via [`Application/Script/CreateUser.hs`](Application/Script/CreateUser.hs).

### Testes e Stress Test

```bash
# Suíte completa (unitários + integração + build)
nix flake check --impure

# Bateria de stress em Haskell (com o ambiente ativo via ./start)
run-script Application/Script/StressTest.hs
```

---

## Arquitetura e Módulos

O projeto segue a separação **Functional Core / Imperative Shell** (documentada em [`docs/arquitetura-e-decisoes.md`](docs/arquitetura-e-decisoes.md)):

* **Domínio Puro (`Application/Domain/`):**
  * [`Academic.hs`](Application/Domain/Academic.hs): tipos algébricos (`Situacao`, `Conceito`), currying e closure (`mediaPonderada`, `mediaSemestre`), list comprehensions e agregações com `map`/`foldr`/`sortBy`.
  * [`Catalog.hs`](Application/Domain/Catalog.hs): controle de permissões (`canRead`, `canWrite`), validadores e consultas com `filter`, `map`, `foldr` e `concatMap`.
  * [`Advanced.hs`](Application/Domain/Advanced.hs): `Reader AcademicConfig`, pipeline `Either`, `Functor` (`ItemRelatorio`), CPS (`realizarMatriculaCPS`) e streams preguiçosos (`geradorProtocolos`).
  * [`Security.hs`](Application/Domain/Security.hs): cifra simétrica em bytes UTF-8 para campos sensíveis, mascaramento e checagem de formato de hash.
  * [`Dashboard.hs`](Application/Domain/Dashboard.hs): agregações de KPIs institucionais, médias por curso e rankings.
  * [`Errors.hs`](Application/Domain/Errors.hs): ADT `AppError` e combinadores de recuperação (`note`, `recoverWith`, `withFallback`, `calcularMediaSegura`, `decifrarOuFallback`).
* **Camada Web (`Web/`):** controllers (`Alunos`, `Cursos`, `Dashboard`, `Relatorios`, `Sessions`, `Static`), views SSR em HSX e simulador de média no cliente.
* **Banco de Dados (`Application/Schema.sql` & `Application/Migration/`):** `alunos`, `cursos`, `professores`, `disciplinas`, `turmas`, `notas`, `frequencias` e `users`, com constraints `CHECK`, `UNIQUE` e `ON DELETE RESTRICT`.

---

## Documentação e Apresentações

* [Arquitetura e Decisões Técnicas (ADRs)](docs/arquitetura-e-decisoes.md)
* Sprint 2: [Slides](docs/apresentacao-sprint-2.html) · [Notas](docs/sprint-2-apresentacao.md) · [Demo](docs/sprint-2-demo.md)
* Sprint 3: [Slides](docs/apresentacao-sprint-3.html) · [Notas](docs/sprint-3-apresentacao.md) · [Demo](docs/sprint-3-demo.md)
* Sprint 4: [Slides](docs/apresentacao-sprint-4.html) · [Notas](docs/sprint-4-apresentacao.md) · [Demo](docs/sprint-4-demo.md)
* Sprint 5: [Slides](docs/apresentacao-sprint-5.html) · [Notas](docs/sprint-5-apresentacao.md) · [Demo](docs/sprint-5-demo.md)
