module Web.View.Relatorios.MeuBoletim where

import Web.View.Prelude
import qualified Application.Domain.Academic as Academic
import qualified Data.Map.Strict as Map

data MeuBoletimView = MeuBoletimView
    { maybeAluno    :: Maybe Aluno
    , notas         :: [Nota]
    , frequencias   :: [Frequencia]
    , turmaMap      :: Map.Map (Id Turma) Turma
    , disciplinaMap :: Map.Map (Id Disciplina) Disciplina
    }

instance View MeuBoletimView where
    html MeuBoletimView { .. } = case maybeAluno of
        Nothing -> [hsx|
            <h1>Meu Boletim</h1>
            <div class="alert alert-info">
                Nenhum registro acadêmico de estudante está vinculado ao e-mail <strong>{get #email currentUser}</strong>.
            </div>
        |]
        Just aluno ->
            let mediaGeral = if null notas then 0.0 else sum (map (get #valor) notas) / fromIntegral (length notas)
                totalFreqs = length frequencias
                presencas = length (filter (get #presente) frequencias)
                pctPresenca = if totalFreqs == 0 then 100.0 else (fromIntegral presencas / fromIntegral totalFreqs) * 100.0
                situacao = Academic.situacaoAluno mediaGeral pctPresenca
                badgeClass :: Text
                badgeClass = case situacao of
                    Academic.Aprovado          -> "badge bg-success fs-6"
                    Academic.ProvaFinal        -> "badge bg-warning text-dark fs-6"
                    Academic.ReprovadoPorFalta -> "badge bg-danger fs-6"
                    Academic.ReprovadoPorNota  -> "badge bg-danger fs-6"
            in [hsx|
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h2 mb-1">Meu Boletim</h1>
                        <p class="text-muted mb-0">{get #nome aluno} · Matrícula <code>{get #matricula aluno}</code></p>
                    </div>
                    <span class={badgeClass}>{Academic.formataSituacao situacao}</span>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm bg-primary text-white">
                            <div class="card-body">
                                <span class="text-white-50 text-uppercase small fw-bold">Média Geral</span>
                                <h2 class="display-6 fw-bold mb-0">{Academic.arredondar mediaGeral}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm bg-info text-white">
                            <div class="card-body">
                                <span class="text-white-50 text-uppercase small fw-bold">Frequência Geral</span>
                                <h2 class="display-6 fw-bold mb-0">{Academic.arredondar pctPresenca}%</h2>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-white fw-bold py-3">Lançamentos de Notas</div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr><th>Disciplina</th><th>Semestre</th><th>Avaliação</th><th class="text-end">Nota</th></tr>
                                </thead>
                                <tbody>{forEach notas (renderNota turmaMap disciplinaMap)}</tbody>
                            </table>
                        </div>
                    </div>
                </div>
                {emptyMessage (null notas) "Nenhuma nota lançada até o momento."}
            |]

renderNota :: Map.Map (Id Turma) Turma -> Map.Map (Id Disciplina) Disciplina -> Nota -> Html
renderNota turmaMap disciplinaMap nota =
    let maybeTurma = Map.lookup (get #turmaId nota) turmaMap
        maybeDisc = maybeTurma >>= \t -> Map.lookup (get #disciplinaId t) disciplinaMap
        nomeDisc = maybe "Disciplina" (get #nome) maybeDisc
        semestre = maybe "-" (get #semestre) maybeTurma
    in [hsx|
        <tr>
            <td class="fw-semibold">{nomeDisc}</td>
            <td>{semestre}</td>
            <td>{get #descricao nota}</td>
            <td class="text-end fw-bold">{get #valor nota}</td>
        </tr>
    |]
