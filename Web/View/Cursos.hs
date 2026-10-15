module Web.View.Cursos where

import Web.View.Prelude
import qualified Application.Domain.Catalog as Catalog

data IndexView = IndexView { cursos :: [Curso], busca :: Text, resumo :: [(Curso, Int)], vinculados :: [(Text, Text)] }
data FormView = FormView { curso :: Curso }
data ShowView = ShowView { curso :: Curso, alunos :: [Aluno] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1>Cursos</h1>
            {newButton}
        </div>
        <form method="GET" action={CursosAction} class="d-flex gap-2 mb-3">
            <input name="busca" value={busca} class="form-control" placeholder="Nome ou código do curso" aria-label="Buscar cursos"/>
            <button class="btn btn-outline-primary" type="submit">Buscar</button>
        </form>
        <p>{length cursos} curso(s) encontrado(s).</p>
        <div class="table-responsive"><table class="table table-striped">
            <thead><tr><th>Curso</th><th>Código</th><th>Carga horária</th><th>Estudantes</th><th>Ações</th></tr></thead>
            <tbody>{forEach resumo renderCurso}</tbody>
        </table></div>
        {emptyMessage (null cursos) "Nenhum curso encontrado."}
        <h2 class="h4 mt-4">Estudantes por curso</h2>
        <ul>{forEach vinculados renderVinculo}</ul>
        {emptyMessage (null vinculados) "Nenhum estudante vinculado aos cursos encontrados."}
    |]

renderCurso :: (Curso, Int) -> Html
renderCurso (curso, total) = [hsx|
    <tr>
        <td><a href={ShowCursoAction (get #id curso)}>{get #nome curso}</a></td>
        <td>{get #codigo curso}</td><td>{get #cargaHoraria curso} h</td><td>{total}</td>
        <td>{courseActions curso}</td>
    </tr>
|]

courseActions :: Curso -> Html
courseActions curso = when (Catalog.canWrite (get #role_ currentUser)) [hsx|
    <a class="btn btn-sm btn-outline-primary" href={EditCursoAction (get #id curso)}>Editar</a>
    <a class="btn btn-sm btn-outline-danger js-delete" data-confirm="Excluir este curso?" href={DeleteCursoAction (get #id curso)}>Excluir</a>
|]

instance View FormView where
    html FormView { .. } = [hsx|
        <h1>{if isNew curso then "Novo curso" else "Editar curso" :: Text}</h1>
        {renderForm curso}
    |]

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>{get #nome curso}</h1>
        <dl><dt>Código</dt><dd>{get #codigo curso}</dd><dt>Carga horária</dt><dd>{get #cargaHoraria curso} h</dd></dl>
        {courseActions curso}
        <a class="btn btn-outline-secondary" href={CursosAction}>Voltar aos cursos</a>
        <h2 class="h4 mt-4">Estudantes vinculados ({length alunos})</h2>
        <ul>{forEach alunos renderEstudante}</ul>
        {emptyMessage (null alunos) "Nenhum estudante vinculado."}
    |]

newButton :: Html
newButton = when (Catalog.canWrite (get #role_ currentUser)) [hsx|<a class="btn btn-primary" href={NewCursoAction}>Novo curso</a>|]

renderForm :: Curso -> Html
renderForm curso = formFor curso [hsx|
            {(textField #nome) { fieldLabel = "Nome", required = True }}
            {(textField #codigo) { fieldLabel = "Código", required = True, helpText = "De 2 a 20 letras, números ou hífen." }}
            {(numberField #cargaHoraria) { fieldLabel = "Carga horária", required = True, helpText = "De 1 a 10000 horas." }}
            <button class="btn btn-primary" type="submit">Salvar curso</button>
            <a class="btn btn-outline-secondary" href={CursosAction}>Cancelar</a>
        |]

renderVinculo :: (Text, Text) -> Html
renderVinculo (curso, aluno) = [hsx|<li>{curso}: {aluno}</li>|]

renderEstudante :: Aluno -> Html
renderEstudante aluno = [hsx|<li><a href={ShowAlunoAction (get #id aluno)}>{get #nome aluno}</a></li>|]
