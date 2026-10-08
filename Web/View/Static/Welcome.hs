module Web.View.Static.Welcome where
import Web.View.Prelude
import qualified Data.Map.Strict as Map

data WelcomeView = WelcomeView
    { turmas :: [Turma]
    , disciplinaMap :: Map.Map (Id Disciplina) Disciplina
    }

instance View WelcomeView where
    html WelcomeView { .. } = [hsx|
        <div class="p-5 mb-4 bg-light rounded-3 border">
            <div class="container-fluid py-2">
                <span class="badge bg-primary mb-2">UNIFOR • PROGRAMAÇÃO FUNCIONAL 2026</span>
                <h1 class="display-5 fw-bold">SGA-Func: Gestão Acadêmica</h1>
                <p class="col-md-9 fs-5 text-muted">
                    Aplicação prática dos conceitos de Programação Funcional em Haskell:
                    funções puras, currying, pattern matching, list comprehensions e agregações com map e foldr.
                </p>
                <div class="mt-4">
                    <a class="btn btn-primary btn-lg" href={pathTo RankingAction}>
                        🏆 Ver Ranking Geral de Alunos
                    </a>
                </div>
            </div>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h4 class="card-title mb-0">Turmas Disponíveis</h4>
            </div>
            <div class="card-body">
                {renderListaTurmas}
            </div>
        </div>
    |]
      where
        renderListaTurmas =
            if null turmas
                then [hsx|<p class="text-muted">Nenhuma turma cadastrada no momento.</p>|]
                else [hsx|
                    <div class="row g-3">
                        {forEach turmas renderTurma}
                    </div>
                |]

        renderTurma turma =
            let maybeDisc = Map.lookup (get #disciplinaId turma) disciplinaMap
                nomeDisc = maybe "Disciplina" (get #nome) maybeDisc
                codDisc = maybe "" (get #codigo) maybeDisc
            in [hsx|
                <div class="col-md-6">
                    <div class="p-3 border rounded-3 bg-white h-100 d-flex flex-column justify-content-between">
                        <div>
                            <span class="badge bg-secondary mb-2">{codDisc}</span>
                            <h5 class="fw-bold mb-1">{nomeDisc}</h5>
                            <p class="text-muted small mb-3">Semestre: {get #semestre turma}</p>
                        </div>
                        <div class="d-flex gap-2">
                            <a class="btn btn-outline-primary btn-sm" href={pathTo (DesempenhoAction (get #id turma))}>
                                📊 Ver Desempenho
                            </a>
                            <a class="btn btn-outline-success btn-sm" href={pathTo (FrequenciaAction (get #id turma))}>
                                📅 Ver Frequência
                            </a>
                        </div>
                    </div>
                </div>
            |]