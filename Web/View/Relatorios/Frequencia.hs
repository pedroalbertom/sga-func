module Web.View.Relatorios.Frequencia where
import Web.View.Prelude
import qualified Application.Domain.Academic as Academic
import qualified Data.Map.Strict as Map

data FrequenciaView = FrequenciaView
    { turma :: Turma
    , disciplina :: Disciplina
    , frequenciasCalculadas :: [(Id Aluno, Double)]
    , alunoMap :: Map.Map (Id Aluno) Aluno
    }

instance View FrequenciaView where
    html FrequenciaView { .. } = [hsx|
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/">Início</a></li>
                <li class="breadcrumb-item active" aria-current="page">Relatório de Frequência</li>
            </ol>
        </nav>

        <div class="mb-4">
            <h1 class="h2 mb-1">Frequência da Turma</h1>
            <p class="text-muted mb-0">
                Disciplina: <strong>{get #nome disciplina}</strong> ({get #codigo disciplina}) | Semestre: <strong>{get #semestre turma}</strong>
            </p>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">Percentual de Presença por Aluno (Cálculo com Map &amp; Foldr)</h5>
                <span class="badge bg-info text-dark">Limite Institucional: 75%</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Matrícula</th>
                            <th>Aluno</th>
                            <th class="text-center" style="width: 30%;">Presença (%)</th>
                            <th class="text-center">Percentual</th>
                            <th class="text-center">Status de Frequência</th>
                        </tr>
                    </thead>
                    <tbody>
                        {forEach frequenciasCalculadas renderLinha}
                    </tbody>
                </table>
            </div>
        </div>
    |]
        where
            renderLinha (alunoId, pct) =
                let maybeAluno = Map.lookup alunoId alunoMap
                    nome = maybe "Aluno não encontrado" (get #nome) maybeAluno
                    matricula = maybe "-" (get #matricula) maybeAluno
                    pctFormatado = Academic.arredondar pct
                    barClass :: Text
                    barClass = if emRisco then "bg-danger" else "bg-success"
                    badgeClass :: Text
                    badgeClass = if emRisco then "bg-danger" else "bg-success"
                    statusTexto = if emRisco then ("Risco de Reprovação (< 75%)" :: Text) else "Frequência Regular"
                    widthStyle = "width: " <> tshow pctFormatado <> "%"
                in [hsx|
                    <tr>
                        <td><code>{matricula}</code></td>
                        <td class="fw-semibold">{nome}</td>
                        <td class="text-center">
                            <div class="progress" style="height: 18px;">
                                <div class={"progress-bar " <> barClass} role="progressbar" style={widthStyle} aria-valuenow={tshow pctFormatado} aria-valuemin="0" aria-valuemax="100">
                                    {tshow pctFormatado}%
                                </div>
                            </div>
                        </td>
                        <td class="text-center fw-bold">{tshow pctFormatado}%</td>
                        <td class="text-center">
                            <span class={"badge " <> badgeClass}>{statusTexto}</span>
                        </td>
                    </tr>
                |]
