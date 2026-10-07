module Web.View.Static.Welcome where
import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
        <div class="p-5 mb-4 bg-light rounded-3 border">
            <div class="container-fluid py-2">
                <span class="badge bg-primary mb-2">UNIFOR • PROGRAMAÇÃO FUNCIONAL 2026</span>
                <h1 class="display-5 fw-bold">SGA-Func: Sistema de Gestão Acadêmica</h1>
                <p class="col-md-9 fs-5 text-muted">
                    Demonstração prática dos paradigmas de Programação Funcional com Haskell e IHP Framework.
                    Os relatórios acadêmicos utilizam funções puras, currying, pattern matching, list comprehensions e agregações com map e foldr.
                </p>
                <div class="d-flex gap-2 mt-4">
                    <a class="btn btn-primary btn-lg" href="/Relatorios/Ranking">
                        🏆 Ranking Geral
                    </a>
                    <a class="btn btn-outline-primary btn-lg" href="/Relatorios/Desempenho?turmaId=d1111111-1111-1111-1111-111111111111">
                        📊 Desempenho (Turma 2026.1)
                    </a>
                    <a class="btn btn-outline-success btn-lg" href="/Relatorios/Frequencia?turmaId=d1111111-1111-1111-1111-111111111111">
                        📅 Frequência (Turma 2026.1)
                    </a>
                </div>
            </div>
        </div>

        <div class="row align-items-md-stretch g-4 mb-4">
            <div class="col-md-4">
                <div class="h-100 p-4 bg-white rounded-3 border shadow-sm">
                    <h4>⚙️ Núcleo Funcional Puro</h4>
                    <p class="text-muted">
                        Regras de negócio isoladas em <code>Application/Domain/Academic.hs</code> sem efeitos colaterais:
                        cálculo de média ponderada, closures, e validações.
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="h-100 p-4 bg-white rounded-3 border shadow-sm">
                    <h4>🔄 Map &amp; Foldr na Prática</h4>
                    <p class="text-muted">
                        Transformação e redução de dados conforme pág. 5 do guia, agrupando notas e frequências com
                        <code>foldr</code> e <code>Map.insertWith</code>.
                    </p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="h-100 p-4 bg-white rounded-3 border shadow-sm">
                    <h4>🎯 Tipos Algébricos &amp; Pattern Matching</h4>
                    <p class="text-muted">
                        Classificação de situações acadêmicas (<code>Aprovado</code>, <code>ProvaFinal</code>, <code>Reprovado</code>)
                        e conceitos (<code>A</code> até <code>F</code>) com casamento de padrão exaustivo.
                    </p>
                </div>
            </div>
        </div>
    |]