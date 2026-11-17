# Sprint 5 — SGA-Func: Qualidade, Recuperação e Stress

Abra [`apresentacao-sprint-5.html`](apresentacao-sprint-5.html) no navegador para exibir os slides com transição via teclado ou exportar para PDF.

---

## 🎯 Visão Geral dos Entregáveis

A **Sprint 5** consolida a robustez técnica, a qualidade automatizada, a performance sob carga e a documentação arquitetural completa do **SGA-Func**.

### 1. Tratamento de Erros Monádico Robusto
* Implementado em [`Application/Domain/Errors.hs`](../Application/Domain/Errors.hs):
  * **ADT `AppError`**: Tipagem explícita de falhas (`ValidationError`, `NotFoundError`, `AuthorizationError`, `CryptoError`, `EmptyDataError`).
  * **Combinadores de Recuperação**: `note`, `mapError`, `recoverWith` e `withFallback` permitem compor fluxos com recuperação graciosa sem lançar exceções.
  * **Blindagem Web**: [`Web/Controller/Relatorios.hs`](../Web/Controller/Relatorios.hs) utiliza `findTurmaOr404` (`fetchOneOrNothing` + `earlyReturn renderNotFound`), garantindo resposta `404` controlada em URLs inválidas.

### 2. Testes Unitários + de Integração
* **Unitários ([`Test/ErrorsSpec.hs`](../Test/ErrorsSpec.hs))**: Valida formatação de erros, `note`, `recoverWith`, `withFallback`, rejeição de notas fora de `[0, 10]` e recuperação de falhas criptográficas.
* **Integração ([`Test/Integration.hs`](../Test/Integration.hs))**: Expandido para cobrir `DashboardAction`, `RankingAction`, `DesempenhoAction`, `FrequenciaAction`, retorno `404` controlado em turmas inexistentes e persistência cifrada de documentos em `CreateAlunoAction`.

### 3. Teste de Stress em Haskell
* Implementado em [`Application/Script/StressTest.hs`](../Application/Script/StressTest.hs):
  * **Domínio Puro**: Estressa `calcularRanking`, `gerarResumoAlunos` e `calcularMetricasGerais` com **5.000 alunos e 50.000 notas**.
  * **Concorrência Multi-Thread**: Executa 16 *green threads* (`forkIO` + `MVar`) rodando 8.000 pipelines de criptografia, decifragem e fallback simultaneamente.
  * **PostgreSQL Concorrente**: Dispara 8 workers realizando queries concorrentes no banco via IHP, reportando *throughput* (`ops/s`), latência média e `p95`.

### 4. Documentação de Arquitetura e Decisões
* Consolidada em [`docs/arquitetura-e-decisoes.md`](arquitetura-e-decisoes.md), contendo o diagrama *Functional Core / Imperative Shell* e 6 ADRs explicando todas as escolhas técnicas do projeto.
