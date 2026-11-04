# Roteiro da Demonstração Prática — Sprint 4 (SGA-Func)

Este roteiro guia a apresentação final do frontend completo, SSR e Dashboard para o professor.

---

## ⏱️ Roteiro de Demonstração (5 a 7 minutos)

### 1. Testes Automatizados do Dashboard e SSR (1 min)
* Execute a suíte de testes com HSpec:
  ```bash
  nix flake check --impure
  ```
* Mostre a aprovação dos testes em [`Test/DashboardSpec.hs`](../Test/DashboardSpec.hs) cobrindo:
  * Agregação individual (médias e frequências).
  * KPIs institucionais globais.
  * Agrupamento por curso.
  * Pódio e filtragem de estudantes críticos.

---

### 2. Demonstração Visual do Dashboard Acadêmico (3 a 4 min)
1. **Iniciar a aplicação**:
   ```bash
   ./start
   ```
2. **Navegação**:
   * Faça login com `admin@example.com` / `senha-de-teste-123` (ou `consulta@example.com`).
   * No menu de navegação superior, clique no novo item **Dashboard** (`/Dashboard`).
3. **Exploração dos Cards de KPI**:
   * Mostre os 4 cartões no topo da página:
     * **Total de Alunos** cadastrados.
     * **Média Institucional** calculada de forma pura.
     * **Taxa de Aprovação** global (%).
     * **Alunos em Risco**.
4. **Filtro Dinâmico por Curso**:
   * Selecione um curso específico no seletor *"Filtrar por Curso"*.
   * Mostre que a listagem de alunos e as estatísticas se recalculam imediatamente no servidor via SSR.
5. **Demonstração do Componente Reativo**:
   * Na seção *"⚡ Simulador Reativo de Desempenho"*, altere os campos de AV1, AV2 e Trabalho.
   * Deslize o controle de **Presença** para menos de 75%.
   * Mostre a mudança instantânea da badge para `[ Reprovado por Falta ]` em vermelho, demonstrando a reatividade sem reload.
6. **Pódio & Alunos que Demandam Atenção**:
   * Aponte para o pódio com as medalhas de 1º 🥇, 2º 🥈 e 3º 🥉 lugares.
   * Mostre a tabela de alunos em risco com links diretos para a ficha detalhada de cada aluno.

---

### 3. Conclusão da Apresentação (1 min)
* Ressalte como o projeto integrou com elegância os conceitos de **Programação Funcional** (tipos algébricos, currying, composição, Monads, CPS, Lazy evaluation e agregações com foldr/map) com uma arquitetura web de produção moderna baseada no framework **IHP** e **PostgreSQL**.
