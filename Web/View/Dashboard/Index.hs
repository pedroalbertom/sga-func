module Web.View.Dashboard.Index where

import Web.View.Prelude
import Application.Domain.Dashboard
import Application.Domain.Academic (Situacao(..), formataSituacao)

data IndexView = IndexView
    { metricasGerais   :: MetricasGerais
    , metricasCursos   :: [MetricaCurso]
    , topAlunos        :: [AlunoResumoDashboard]
    , alunosCriticos   :: [AlunoResumoDashboard]
    , cursos           :: [Curso]
    , cursoSelecionado :: Maybe (Id Curso)
    }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h2 mb-1">📊 Dashboard Acadêmico</h1>
                <p class="text-muted mb-0">Agregações puras, KPIs em SSR e análise de desempenho.</p>
            </div>
            <div>
                <form method="GET" action={DashboardAction} class="d-flex align-items-center gap-2">
                    <label class="fw-semibold text-nowrap" for="cursoId">Filtrar por Curso:</label>
                    <select id="cursoId" name="cursoId" class="form-select form-select-sm" onchange="this.form.submit()">
                        <option value="">Todos os Cursos</option>
                        {forEach cursos (renderOpcaoCurso cursoSelecionado)}
                    </select>
                </form>
            </div>
        </div>

        <!-- CARDS DE KPIS INSTITUCIONAIS -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm bg-primary text-white">
                    <div class="card-body">
                        <span class="text-white-50 text-uppercase small fw-bold">Total de Alunos</span>
                        <h2 class="display-6 fw-bold mb-0">{get #totalEstudantes metricasGerais}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm bg-success text-white">
                    <div class="card-body">
                        <span class="text-white-50 text-uppercase small fw-bold">Média Institucional</span>
                        <h2 class="display-6 fw-bold mb-0">{get #mediaInstitucional metricasGerais}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm bg-info text-white">
                    <div class="card-body">
                        <span class="text-white-50 text-uppercase small fw-bold">Taxa de Aprovação</span>
                        <h2 class="display-6 fw-bold mb-0">{get #percentualAprovacao metricasGerais}%</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm bg-warning text-dark">
                    <div class="card-body">
                        <span class="text-black-50 text-uppercase small fw-bold">Alunos em Risco</span>
                        <h2 class="display-6 fw-bold mb-0">{get #quantidadeEmRisco metricasGerais}</h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- CONTEÚDO PRINCIPAL EM DUAS COLUNAS -->
        <div class="row g-4">
            <!-- Coluna da Esquerda: Métricas por Curso + Simulador Reativo -->
            <div class="col-lg-6">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-white fw-bold py-3">
                        📚 Desempenho Consolidado por Curso
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Curso</th>
                                        <th>Código</th>
                                        <th class="text-center">Alunos</th>
                                        <th class="text-end">Média Geral</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {forEach metricasCursos renderLinhaCurso}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- COMPONENTE REATIVO (Simulador Dinâmico sem reload) -->
                <div class="card shadow-sm border-0 border-start border-primary border-4">
                    <div class="card-header bg-white fw-bold py-3 d-flex justify-content-between align-items-center">
                        <span>⚡ Simulador Reativo de Desempenho</span>
                        <span class="badge bg-primary">Componente Reativo</span>
                    </div>
                    <div class="card-body">
                        <p class="small text-muted mb-3">
                            Ajuste as notas e presença abaixo para simular instantaneamente a média ponderada e a situação final calculada no cliente:
                        </p>
                        <div class="row g-2 mb-3">
                            <div class="col-4">
                                <label class="form-label small fw-semibold">AV1 (Peso 2)</label>
                                <input type="number" id="sim-av1" class="form-control form-control-sm" value="7.0" min="0" max="10" step="0.5" oninput="simularDesempenho()"/>
                            </div>
                            <div class="col-4">
                                <label class="form-label small fw-semibold">AV2 (Peso 3)</label>
                                <input type="number" id="sim-av2" class="form-control form-control-sm" value="8.0" min="0" max="10" step="0.5" oninput="simularDesempenho()"/>
                            </div>
                            <div class="col-4">
                                <label class="form-label small fw-semibold">Trabalho (Peso 5)</label>
                                <input type="number" id="sim-trab" class="form-control form-control-sm" value="9.0" min="0" max="10" step="0.5" oninput="simularDesempenho()"/>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between small">
                                <label class="form-label fw-semibold mb-1">Presença</label>
                                <span id="sim-presenca-val" class="fw-bold">85%</span>
                            </div>
                            <input type="range" id="sim-presenca" class="form-range" value="85" min="0" max="100" oninput="simularDesempenho()"/>
                        </div>
                        <div class="p-3 bg-light rounded d-flex justify-content-between align-items-center">
                            <div>
                                <span class="small text-muted d-block">Média Ponderada:</span>
                                <span id="sim-resultado-media" class="h4 fw-bold text-primary mb-0">8.3</span>
                            </div>
                            <div class="text-end">
                                <span class="small text-muted d-block">Situação Prevista:</span>
                                <span id="sim-resultado-situacao" class="badge bg-success fs-6">Aprovado</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Coluna da Direita: Top Ranking e Alunos em Situação Crítica -->
            <div class="col-lg-6">
                <!-- Top Ranking -->
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-white fw-bold py-3 d-flex justify-content-between align-items-center">
                        <span>🏆 Pódio de Melhores Desempenhos</span>
                        <a href={RankingAction} class="small text-decoration-none">Ver ranking geral →</a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 50px;">Pos.</th>
                                        <th>Estudante</th>
                                        <th>Matrícula</th>
                                        <th class="text-end">Média</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {forEachWithIndex topAlunos renderLinhaTop}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Alunos em Risco -->
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white fw-bold py-3 text-danger d-flex justify-content-between align-items-center">
                        <span>⚠️ Alunos que Demandam Atenção</span>
                        <span class="badge bg-danger">{length alunosCriticos}</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Estudante</th>
                                        <th>Média</th>
                                        <th>Presença</th>
                                        <th>Condição</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {forEach alunosCriticos renderLinhaCritico}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- SCRIPT DO COMPONENTE REATIVO -->
        <script>
            function simularDesempenho() {
                const av1 = parseFloat(document.getElementById('sim-av1').value) || 0;
                const av2 = parseFloat(document.getElementById('sim-av2').value) || 0;
                const trab = parseFloat(document.getElementById('sim-trab').value) || 0;
                const pres = parseFloat(document.getElementById('sim-presenca').value) || 0;

                document.getElementById('sim-presenca-val').innerText = pres + '%';

                const media = ((av1 * 2) + (av2 * 3) + (trab * 5)) / 10;
                const mediaArred = Math.round(media * 100) / 100;
                document.getElementById('sim-resultado-media').innerText = mediaArred.toFixed(1);

                const elSit = document.getElementById('sim-resultado-situacao');
                if (pres < 75) {
                    elSit.className = 'badge bg-danger fs-6';
                    elSit.innerText = 'Reprovado por Falta';
                } else if (media >= 7.0) {
                    elSit.className = 'badge bg-success fs-6';
                    elSit.innerText = 'Aprovado';
                } else if (media >= 4.0) {
                    elSit.className = 'badge bg-warning text-dark fs-6';
                    elSit.innerText = 'Prova Final';
                } else {
                    elSit.className = 'badge bg-danger fs-6';
                    elSit.innerText = 'Reprovado por Nota';
                }
            }
        </script>
    |]

renderOpcaoCurso :: Maybe (Id Curso) -> Curso -> Html
renderOpcaoCurso sel curso =
    let cId = get #id curso
        isSelected = sel == Just cId
    in [hsx|<option value={show cId} selected={isSelected}>{get #nome curso} ({get #codigo curso})</option>|]

renderLinhaCurso :: MetricaCurso -> Html
renderLinhaCurso MetricaCurso { .. } = [hsx|
    <tr>
        <td class="fw-semibold">{get #nome curso}</td>
        <td><span class="badge bg-secondary">{get #codigo curso}</span></td>
        <td class="text-center">{qtdEstudantes}</td>
        <td class="text-end fw-bold text-primary">{mediaNotas}</td>
    </tr>
|]

renderLinhaTop :: (Int, AlunoResumoDashboard) -> Html
renderLinhaTop (idx, AlunoResumoDashboard { .. }) =
    let posBadge = case idx of
            0 -> [hsx|<span class="badge bg-warning text-dark">1º 🥇</span>|]
            1 -> [hsx|<span class="badge bg-secondary text-white">2º 🥈</span>|]
            2 -> [hsx|<span class="badge bg-danger text-white">3º 🥉</span>|]
            _ -> [hsx|<span class="text-muted fw-bold">{idx + 1}º</span>|]
    in [hsx|
        <tr>
            <td>{posBadge}</td>
            <td><a href={ShowAlunoAction (get #id aluno)} class="text-decoration-none fw-semibold">{get #nome aluno}</a></td>
            <td><code>{get #matricula aluno}</code></td>
            <td class="text-end fw-bold text-success">{media}</td>
        </tr>
    |]

renderLinhaCritico :: AlunoResumoDashboard -> Html
renderLinhaCritico AlunoResumoDashboard { .. } =
    let badgeClass = case situacao of
            ProvaFinal        -> "badge bg-warning text-dark"
            ReprovadoPorFalta -> "badge bg-danger"
            ReprovadoPorNota  -> "badge bg-danger"
            Aprovado          -> "badge bg-success"
    in [hsx|
        <tr>
            <td><a href={ShowAlunoAction (get #id aluno)} class="text-decoration-none fw-semibold">{get #nome aluno}</a></td>
            <td><strong>{media}</strong></td>
            <td>{presenca}%</td>
            <td><span class={badgeClass}>{formataSituacao situacao}</span></td>
        </tr>
    |]
