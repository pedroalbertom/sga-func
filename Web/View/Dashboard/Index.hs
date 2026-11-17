module Web.View.Dashboard.Index where

import Web.View.Prelude
import Application.Domain.Dashboard
import Application.Domain.Academic (Situacao(..), formataSituacao)
import qualified Application.Domain.Catalog as Catalog
import qualified Data.Map.Strict as Map

data IndexView = IndexView
    { metricasGerais   :: MetricasGerais
    , metricasCursos   :: [MetricaCurso]
    , topAlunos        :: [AlunoResumoDashboard]
    , alunosCriticos   :: [AlunoResumoDashboard]
    , cursos           :: [Curso]
    , cursoSelecionado :: Maybe (Id Curso)
    , turmas           :: [Turma]
    , disciplinaMap    :: Map.Map (Id Disciplina) Disciplina
    }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h2 mb-1">Dashboard Acadêmico</h1>
                <p class="text-muted mb-0">Visão geral de desempenho, frequência e indicadores por curso.</p>
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

        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white fw-bold py-3">
                        Desempenho por Curso
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
            </div>

            <div class="col-lg-6">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white fw-bold py-3 d-flex justify-content-between align-items-center">
                        <span>Melhores Desempenhos</span>
                        <a href={RankingAction} class="small text-decoration-none">Ver ranking geral</a>
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
            </div>
        </div>

        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header bg-white py-3 d-flex flex-wrap justify-content-between align-items-center gap-2">
                <div class="fw-bold text-danger d-flex align-items-center gap-2">
                    <span>Alunos em Situação de Atenção</span>
                    <span id="atencao-contador" class="badge bg-danger">{length alunosCriticos}</span>
                </div>
                <div class="d-flex flex-wrap align-items-center gap-2">
                    <input
                        type="text"
                        id="atencao-busca"
                        class="form-control form-control-sm"
                        style="width: 210px;"
                        placeholder="Filtrar estudante..."
                        oninput="filtrarAtencao()"
                    />
                    <div class="btn-group btn-group-sm" role="group" aria-label="Filtro por situação">
                        <button type="button" class="btn btn-outline-secondary active" onclick="selecionarCondicao(this, '')">Todos</button>
                        <button type="button" class="btn btn-outline-warning" onclick="selecionarCondicao(this, 'Prova Final')">Prova Final</button>
                        <button type="button" class="btn btn-outline-danger" onclick="selecionarCondicao(this, 'Reprovado por Nota')">Por Nota</button>
                        <button type="button" class="btn btn-outline-danger" onclick="selecionarCondicao(this, 'Reprovado por Falta')">Por Falta</button>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                {renderTabelaAtencao alunosCriticos}
            </div>
        </div>

        {when (Catalog.canWrite (get #role_ currentUser)) (renderModalRecuperacao turmas disciplinaMap)}

        <script>
            let condicaoAtiva = '';

            function selecionarCondicao(btn, condicao) {
                condicaoAtiva = condicao;
                btn.parentElement.querySelectorAll('button').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                filtrarAtencao();
            }

            function filtrarAtencao() {
                const termo = (document.getElementById('atencao-busca')?.value || '').toLowerCase().trim();
                const linhas = document.querySelectorAll('tr.linha-atencao');
                let visiveis = 0;

                linhas.forEach(tr => {
                    const nome = (tr.dataset.nome || '').toLowerCase();
                    const cond = tr.dataset.condicao || '';
                    const bateNome = nome.includes(termo);
                    const bateCond = !condicaoAtiva || cond === condicaoAtiva;
                    const mostrar = bateNome && bateCond;
                    tr.style.display = mostrar ? '' : 'none';
                    if (mostrar) visiveis++;
                });

                const badge = document.getElementById('atencao-contador');
                if (badge) badge.innerText = visiveis;
            }

            function abrirRecuperacao(btn) {
                document.getElementById('rec-aluno-id').value = btn.dataset.alunoId;
                document.getElementById('rec-aluno-nome').innerText = btn.dataset.alunoNome;
                const tipoSelect = document.getElementById('rec-tipo');
                tipoSelect.value = btn.dataset.sugestao || 'nota';
                alternarCamposRecuperacao();
                const modal = new bootstrap.Modal(document.getElementById('modalRecuperacao'));
                modal.show();
            }

            function alternarCamposRecuperacao() {
                const tipo = document.getElementById('rec-tipo').value;
                document.getElementById('rec-campos-nota').style.display = (tipo === 'nota') ? '' : 'none';
            }
        </script>
    |]

renderTabelaAtencao :: [AlunoResumoDashboard] -> Html
renderTabelaAtencao alunosCriticos =
    if null alunosCriticos
        then [hsx|<p class="p-3 mb-0 text-muted">Nenhum estudante em situação de atenção.</p>|]
        else [hsx|
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Estudante</th>
                            <th>Média</th>
                            <th>Presença</th>
                            <th>Condição</th>
                            {acaoHeader}
                        </tr>
                    </thead>
                    <tbody>
                        {forEach alunosCriticos renderLinhaCritico}
                    </tbody>
                </table>
            </div>
        |]
  where
    acaoHeader = when (Catalog.canWrite (get #role_ currentUser)) [hsx|<th class="text-end">Ação</th>|]

renderModalRecuperacao :: [Turma] -> Map.Map (Id Disciplina) Disciplina -> Html
renderModalRecuperacao turmas disciplinaMap = [hsx|
    <div class="modal fade" id="modalRecuperacao" tabindex="-1" aria-labelledby="modalRecuperacaoLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form method="POST" action={RegistrarRecuperacaoAction} class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalRecuperacaoLabel">Registrar Apoio / Recuperação</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="alunoId" id="rec-aluno-id"/>
                    <p class="mb-3">Estudante: <strong id="rec-aluno-nome"></strong></p>

                    <div class="mb-3">
                        <label class="form-label" for="rec-turma">Turma</label>
                        <select class="form-select" name="turmaId" id="rec-turma" required="required">
                            {forEach turmas (renderOpcaoTurma disciplinaMap)}
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="rec-tipo">Ação</label>
                        <select class="form-select" name="tipo" id="rec-tipo" onchange="alternarCamposRecuperacao()">
                            <option value="nota">Lançar Nota de Recuperação / Atividade Extra</option>
                            <option value="presenca">Registrar Presença de Reposição</option>
                        </select>
                    </div>

                    <div id="rec-campos-nota">
                        <div class="mb-3">
                            <label class="form-label" for="rec-valor">Nota (0 a 10)</label>
                            <input type="number" class="form-control" name="valor" id="rec-valor" value="8.0" min="0" max="10" step="0.1"/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="rec-descricao">Descrição</label>
                            <input type="text" class="form-control" name="descricao" id="rec-descricao" value="Recuperação"/>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Salvar lançamento</button>
                </div>
            </form>
        </div>
    </div>
|]

renderOpcaoTurma :: Map.Map (Id Disciplina) Disciplina -> Turma -> Html
renderOpcaoTurma disciplinaMap turma =
    let nomeDisc = maybe "Disciplina" (get #nome) (Map.lookup (get #disciplinaId turma) disciplinaMap)
    in [hsx|<option value={tshow (get #id turma)}>{nomeDisc} ({get #semestre turma})</option>|]

renderOpcaoCurso :: Maybe (Id Curso) -> Curso -> Html
renderOpcaoCurso sel curso =
    let cId = get #id curso
        isSelected = sel == Just cId
    in [hsx|<option value={tshow cId} selected={isSelected}>{get #nome curso} ({get #codigo curso})</option>|]

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
            0 -> [hsx|<span class="badge bg-warning text-dark">1º</span>|]
            1 -> [hsx|<span class="badge bg-secondary text-white">2º</span>|]
            2 -> [hsx|<span class="badge bg-danger text-white">3º</span>|]
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
    let badgeClass :: Text
        badgeClass = case situacao of
            ProvaFinal        -> "badge bg-warning text-dark"
            ReprovadoPorFalta -> "badge bg-danger"
            ReprovadoPorNota  -> "badge bg-danger"
            Aprovado          -> "badge bg-success"
        condTexto :: Text
        condTexto = formataSituacao situacao
        sugestao :: Text
        sugestao = case situacao of
            ReprovadoPorFalta -> "presenca"
            _                 -> "nota"
        aId :: Text
        aId = tshow (get #id aluno)
        aNome :: Text
        aNome = get #nome aluno
    in [hsx|
        <tr class="linha-atencao" data-nome={aNome} data-condicao={condTexto}>
            <td><a href={ShowAlunoAction (get #id aluno)} class="text-decoration-none fw-semibold">{aNome}</a></td>
            <td><strong>{media}</strong></td>
            <td>{presenca}%</td>
            <td><span class={badgeClass}>{condTexto}</span></td>
            {acaoBotao}
        </tr>
    |]
  where
    acaoBotao = when (Catalog.canWrite (get #role_ currentUser)) [hsx|
        <td class="text-end">
            <button
                type="button"
                class="btn btn-sm btn-outline-primary"
                data-aluno-id={tshow (get #id aluno)}
                data-aluno-nome={get #nome aluno}
                data-sugestao={if situacao == ReprovadoPorFalta then ("presenca" :: Text) else "nota"}
                onclick="abrirRecuperacao(this)"
            >
                Registrar Recuperação
            </button>
        </td>
    |]
