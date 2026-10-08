module Web.View.Relatorios.Ranking where
import Web.View.Prelude
import qualified Application.Domain.Academic as Academic
import qualified Data.Map.Strict as Map

data RankingView = RankingView
    { ranking :: [(Id Aluno, Double)]
    , alunoMap :: Map.Map (Id Aluno) Aluno
    }

instance View RankingView where
    html RankingView { .. } = [hsx|
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/">Início</a></li>
                <li class="breadcrumb-item active" aria-current="page">Ranking Geral</li>
            </ol>
        </nav>

        <div class="mb-4">
            <h1 class="h2 mb-1">Ranking Geral de Alunos</h1>
            <p class="text-muted mb-0">
                Classificação decrescente por média de notas consolidada (Composição funcional: <code>sortBy (comparing (Down . snd)) . calcularDesempenho</code>)
            </p>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">Quadro de Honra &amp; Classificação Geral</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 80px;">Posição</th>
                            <th>Matrícula</th>
                            <th>Aluno</th>
                            <th class="text-center">Média Geral</th>
                            <th class="text-center">Conceito</th>
                        </tr>
                    </thead>
                    <tbody>
                        {forEach (zip [1::Int ..] ranking) renderPosicao}
                    </tbody>
                </table>
            </div>
        </div>
    |]
        where
            renderPosicao (pos, (alunoId, media)) =
                let maybeAluno = Map.lookup alunoId alunoMap
                    nome = maybe "Aluno não encontrado" (get #nome) maybeAluno
                    matricula = maybe "-" (get #matricula) maybeAluno
                    conceito = Academic.conceitoAluno media
                    badgePosicao = case pos of
                        1 -> ("badge bg-warning text-dark fs-6" :: Text, "🥇 1º")
                        2 -> ("badge bg-secondary fs-6", "🥈 2º")
                        3 -> ("badge bg-info text-dark fs-6", "🥉 3º")
                        n -> ("badge bg-light text-dark border", tshow n <> "º")
                in [hsx|
                    <tr>
                        <td class="text-center">
                            <span class={fst badgePosicao}>{snd badgePosicao}</span>
                        </td>
                        <td><code>{matricula}</code></td>
                        <td class="fw-semibold">{nome}</td>
                        <td class="text-center fw-bold fs-5 text-primary">{Academic.arredondar media}</td>
                        <td class="text-center">
                            <span class="badge bg-secondary fs-6">{tshow conceito}</span>
                        </td>
                    </tr>
                |]
