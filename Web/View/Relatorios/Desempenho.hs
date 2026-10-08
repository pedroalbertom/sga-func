module Web.View.Relatorios.Desempenho where
import Web.View.Prelude
import qualified Application.Domain.Academic as Academic
import qualified Data.Map.Strict as Map

data DesempenhoView = DesempenhoView
    { turma :: Turma
    , disciplina :: Disciplina
    , mediasCalculadas :: [(Id Aluno, Double)]
    , alunoMap :: Map.Map (Id Aluno) Aluno
    , mediaGeral :: Double
    }

instance View DesempenhoView where
    html DesempenhoView { .. } = [hsx|
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/">Início</a></li>
                <li class="breadcrumb-item active" aria-current="page">Relatório de Desempenho</li>
            </ol>
        </nav>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h2 mb-1">Desempenho da Turma</h1>
                <p class="text-muted mb-0">
                    Disciplina: <strong>{get #nome disciplina}</strong> ({get #codigo disciplina}) | Semestre: <strong>{get #semestre turma}</strong>
                </p>
            </div>
            <div class="card bg-primary text-white text-center p-3">
                <span class="small text-uppercase">Média Geral da Turma</span>
                <span class="fs-3 fw-bold">{Academic.arredondar mediaGeral}</span>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">Médias dos Alunos (Cálculo com Map &amp; Foldr)</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Matrícula</th>
                            <th>Aluno</th>
                            <th class="text-center">Média Calculada</th>
                            <th class="text-center">Conceito</th>
                            <th class="text-center">Situação (Preliminar)</th>
                        </tr>
                    </thead>
                    <tbody>
                        {forEach mediasCalculadas renderLinha}
                    </tbody>
                </table>
            </div>
        </div>
    |]
        where
            renderLinha (alunoId, media) =
                let maybeAluno = Map.lookup alunoId alunoMap
                    nome = maybe "Aluno não encontrado" (get #nome) maybeAluno
                    matricula = maybe "-" (get #matricula) maybeAluno
                    conceito = Academic.conceitoAluno media
                    situacaoTexto = Academic.formataSituacao (Academic.situacaoAluno media 100.0)
                    badgeClass = if media >= 7.0 then "bg-success" else if media >= 4.0 then "bg-warning text-dark" else "bg-danger"
                in [hsx|
                    <tr>
                        <td><code>{matricula}</code></td>
                        <td class="fw-semibold">{nome}</td>
                        <td class="text-center fw-bold fs-5">{Academic.arredondar media}</td>
                        <td class="text-center">
                            <span class="badge bg-secondary fs-6">{tshow conceito}</span>
                        </td>
                        <td class="text-center">
                            <span class={"badge " <> badgeClass}>
                                {situacaoTexto}
                            </span>
                        </td>
                    </tr>
                |]
