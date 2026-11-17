module Web.View.Professores where

import Web.View.Prelude
import qualified Application.Domain.Catalog as Catalog
import qualified Data.Map.Strict as Map

data IndexView = IndexView { professores :: [Professore], busca :: Text }
data FormView = FormView { professor :: Professore }
data ShowView = ShowView
    { professor :: Professore
    , turmas :: [Turma]
    , disciplinaMap :: Map.Map (Id Disciplina) Disciplina
    }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1>Professores</h1>
            {newButton}
        </div>
        <form method="GET" action={ProfessoresAction} class="d-flex gap-2 mb-3">
            <input name="busca" value={busca} class="form-control" placeholder="Nome ou e-mail do professor" aria-label="Buscar professores"/>
            <button class="btn btn-outline-primary" type="submit">Buscar</button>
        </form>
        <p>{length professores} professor(es) encontrado(s).</p>
        <div class="table-responsive"><table class="table table-striped">
            <thead><tr><th>Nome</th><th>E-mail</th><th>Ações</th></tr></thead>
            <tbody>{forEach professores renderProfessor}</tbody>
        </table></div>
        {emptyMessage (null professores) "Nenhum professor encontrado."}
    |]

renderProfessor :: Professore -> Html
renderProfessor professor = [hsx|
    <tr>
        <td><a href={ShowProfessorAction (get #id professor)}>{get #nome professor}</a></td>
        <td>{get #email professor}</td>
        <td>{professorActions professor}</td>
    </tr>
|]

professorActions :: Professore -> Html
professorActions professor = when (Catalog.canWrite (get #role_ currentUser)) [hsx|
    <a class="btn btn-sm btn-outline-primary" href={EditProfessorAction (get #id professor)}>Editar</a>
    <a class="btn btn-sm btn-outline-danger js-delete" data-confirm="Excluir este professor?" href={DeleteProfessorAction (get #id professor)}>Excluir</a>
|]

instance View FormView where
    html FormView { .. } = [hsx|
        <h1>{if isNew professor then "Novo professor" else "Editar professor" :: Text}</h1>
        {renderForm professor}
    |]

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>{get #nome professor}</h1>
        <dl><dt>E-mail</dt><dd>{get #email professor}</dd></dl>
        {professorActions professor}
        <a class="btn btn-outline-secondary" href={ProfessoresAction}>Voltar aos professores</a>
        <h2 class="h4 mt-4">Turmas ministradas ({length turmas})</h2>
        <ul>{forEach turmas (renderTurma disciplinaMap)}</ul>
        {emptyMessage (null turmas) "Nenhuma turma vinculada."}
    |]

renderTurma :: Map.Map (Id Disciplina) Disciplina -> Turma -> Html
renderTurma disciplinaMap turma =
    let nomeDisc = maybe "Disciplina" (get #nome) (Map.lookup (get #disciplinaId turma) disciplinaMap)
    in [hsx|
        <li>
            {nomeDisc} ({get #semestre turma}) —
            <a href={DesempenhoAction (get #id turma)}>Desempenho</a> ·
            <a href={FrequenciaAction (get #id turma)}>Frequência</a>
        </li>
    |]

newButton :: Html
newButton = when (Catalog.canWrite (get #role_ currentUser)) [hsx|<a class="btn btn-primary" href={NewProfessorAction}>Novo professor</a>|]

renderForm :: Professore -> Html
renderForm professor = formFor professor [hsx|
    {(textField #nome) { fieldLabel = "Nome", required = True }}
    {(textField #email) { fieldLabel = "E-mail", required = True }}
    <button class="btn btn-primary" type="submit">Salvar professor</button>
    <a class="btn btn-outline-secondary" href={ProfessoresAction}>Cancelar</a>
|]
