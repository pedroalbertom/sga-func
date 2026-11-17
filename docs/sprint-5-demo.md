# Roteiro da Demonstração Final — Sprint 5 (SGA-Func)

Este roteiro guia a apresentação final da Sprint 5 e do sistema completo para o professor.

---

## ⏱️ Roteiro de Demonstração (6 a 8 minutos)

### 1. Suíte Completa de Testes (1 a 2 min)
* No terminal (dentro do ambiente Nix/devenv do projeto), execute:
  ```bash
  nix flake check --impure
  ```
* Aponte que o comando executa:
  * **Testes Unitários** (`AcademicSpec`, `CatalogSpec`, `AdvancedSpec`, `SecuritySpec`, `DashboardSpec`, `ErrorsSpec`).
  * **Testes de Integração** (`Test/Integration.hs`) contra PostgreSQL real temporário.
  * **Build completo** do servidor IHP.

---

### 2. Execução do Teste de Stress em Haskell (2 min)
* Com o banco rodando (`./start` em outra aba), execute o script de stress:
  ```bash
  run-script Application/Script/StressTest.hs
  ```
* Mostre ao professor as 3 etapas impressas no terminal:
  1. **50.000 notas / 5.000 alunos** processados no domínio puro com avaliação estrita.
  2. **16 workers concorrentes (`forkIO`)** executando criptografia + recuperação monádica de erros.
  3. **Consultas concorrentes no PostgreSQL**, destacando o *throughput* (`ops/s`) e a latência `p95`.
* *(Opcional)* Caso tenha `wrk` disponível via Nix, demonstre também carga HTTP direta na página de login/estática:
  ```bash
  nix run nixpkgs#wrk -- -t4 -c50 -d10s http://localhost:8000/NewSession
  ```

---

### 3. Demonstração de Recuperação de Erros e App Completa (3 min)
1. **Recuperação 404 Controlada**:
   * Acesse `http://localhost:8000/Desempenho?turmaId=00000000-0000-0000-0000-000000000000`.
   * Mostre que o sistema trata graciosamente retornando `404` limpo em vez de quebrar com exceção de banco.
2. **Tour Completo pela Aplicação**:
   * **Login** (`/NewSession`) como `admin@example.com` / `senha-de-teste-123`.
   * **Dashboard** (`/Dashboard`): KPIs, filtro por curso e **Simulador Reativo**.
   * **Estudantes** (`/Alunos`): CRUD completo + visualização descriptografada do documento (`admin`) vs mascarada (`consulta`).
   * **Cursos** (`/Cursos`): CRUD + proteção de vínculo (`ON DELETE RESTRICT`).
   * **Ranking Geral** (`/Ranking`) e **Relatórios de Turma** (`/Desempenho`, `/Frequencia`).

---

### 4. Arquitetura e Decisões (1 min)
* Mostre [`docs/arquitetura-e-decisoes.md`](arquitetura-e-decisoes.md) com o diagrama *Functional Core / Imperative Shell* e os ADRs que justificam cada escolha do projeto.
