# Sprint 4 — SGA-Func: Frontend Completo, SSR & Relatórios

Abra `docs/apresentacao-sprint-4.html` no navegador para exibir os slides com transição via teclado ou exportar para PDF usando a impressão do navegador.

---

## 🎯 Visão Geral dos Tópicos

A Sprint 4 entrega a consolidação visual do **SGA-Func**, unificando relatórios e cadastros sob um **Dashboard Acadêmico** analítico moderno com renderização no servidor (SSR) em Haskell e suporte à reatividade.

### 1. Server-Side Rendering (SSR) com HSX
* Utilização de **HSX** (Haskell Source eXtension) do IHP:
  * Templates compilados diretamente em código Haskell nativo, com verificação de tipos e garantia de que nenhum erro de sintaxe HTML ou variável inexistente atinja produção.
  * Proteção nativa contra ataques de XSS (Cross-Site Scripting) por meio de escape automático de texto.
  * Renderização ultrarrápida diretamente do servidor.

### 2. Dashboard Analítico e Agregações Funcionais
* Implementado em [`Application/Domain/Dashboard.hs`](../Application/Domain/Dashboard.hs):
  * **Cálculo de Média Institucional**: Combina notas de todas as turmas cadastradas com filtragem de notas válidas.
  * **Taxa de Aprovação**: Proporção percentual de estudantes que atendem simultaneamente aos critérios de nota (>= 7.0) e frequência (>= 75%).
  * **Consolidação por Curso**: Agrupa total de alunos e média por curso universitário.
  * **Pódio dos Melhores Desempenhos**: Composição funcional de ordenação e `take n`.
  * **Alunos em Situação Crítica**: Filtragem dos alunos com necessidade de intervenção acadêmica (prova final ou reprovações).

### 3. Filtros Dinâmicos
* O Dashboard oferece filtro instantâneo por curso (`GET /Dashboard?cursoId=...`), permitindo que a coordenação pedagógica analise o desempenho de cursos individuais ou da instituição como um todo.

### 4. Componentes Reativos no Frontend
* **Simulador Reativo de Desempenho**:
  * Micro-componente dinâmico que recalcula instantaneamente a média ponderada e a situação acadêmica no momento em que o usuário altera os campos de notas ou desliza o seletor de frequência, sem requisição ao servidor.
* **IHP AutoRefresh**:
  * Mecanismo integrado de WebSockets que atualiza visualizações no cliente de forma transparente quando ocorrem mudanças no banco de dados.
