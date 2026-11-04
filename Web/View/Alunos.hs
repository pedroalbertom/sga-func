module Web.View.Alunos where

import Web.View.Prelude
import qualified Application.Domain.Catalog as Catalog
import qualified Application.Domain.Security as Security

-- Optional course selection keeps legacy students valid.
instance CanSelect Curso where
    type SelectValue Curso = Maybe (Id Curso)
    selectValue curso = Just (get #id curso)
    selectLabel curso = get #nome curso

data IndexView = IndexView { alunos :: [Aluno], cursos :: [Curso], busca :: Text }
data FormView = FormView { aluno :: Aluno, cursos :: [Curso] }
data ShowView = ShowView { aluno :: Aluno, curso :: Maybe Curso }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1>Estudantes</h1>
            {newButton}
        </div>
        <form method="GET" action={AlunosAction} class="d-flex gap-2 mb-3">
            <input name="busca" value={busca} class="form-control" placeholder="Nome, matrícula ou e-mail" aria-label="Buscar estudantes"/>
            <button class="btn btn-outline-primary" type="submit">Buscar</button>
        </form>
        <p>{length alunos} estudante(s) encontrado(s).</p>
        <div class="table-responsive"><table class="table table-striped">
            <thead><tr><th>Nome</th><th>Matrícula</th><th>E-mail</th><th>Curso</th><th>Ações</th></tr></thead>
            <tbody>{forEach alunos (renderAluno cursos)}</tbody>
        </table></div>
        {emptyMessage (null alunos) "Nenhum estudante encontrado."}
    |]

renderAluno :: [Curso] -> Aluno -> Html
renderAluno cursos aluno = [hsx|
    <tr>
        <td><a href={ShowAlunoAction (get #id aluno)}>{get #nome aluno}</a></td>
        <td>{get #matricula aluno}</td><td>{get #email aluno}</td>
        <td>{maybe "Sem curso" (get #nome) (find (\c -> Just (get #id c) == get #cursoId aluno) cursos)}</td>
        <td>{studentActions aluno}</td>
    </tr>
|]

studentActions :: Aluno -> Html
studentActions aluno = when (Catalog.canWrite (get #role_ currentUser)) [hsx|
    <a class="btn btn-sm btn-outline-primary" href={EditAlunoAction (get #id aluno)}>Editar</a>
    <a class="btn btn-sm btn-outline-danger js-delete" data-confirm="Excluir este estudante?" href={DeleteAlunoAction (get #id aluno)}>Excluir</a>
|]

instance View FormView where
    html FormView { .. } = [hsx|
        <h1>{if isNew aluno then "Novo estudante" else "Editar estudante" :: Text}</h1>
        {renderForm aluno cursos}
    |]

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>{get #nome aluno}</h1>
        <dl>
            <dt>Matrícula</dt><dd>{get #matricula aluno}</dd>
            <dt>E-mail</dt><dd>{get #email aluno}</dd>
            <dt>Curso</dt><dd>{maybe "Sem curso" (get #nome) curso}</dd>
            <dt>Documento Confidencial</dt>
            <dd>{renderDocumento aluno}</dd>
        </dl>
        {studentActions aluno}
        <a class="btn btn-outline-secondary" href={AlunosAction}>Voltar aos estudantes</a>
    |]

renderDocumento :: Aluno -> Html
renderDocumento aluno = case get #documentoCriptografado aluno of
    Nothing -> [hsx|<span class="text-muted">Não cadastrado</span>|]
    Just docHex ->
        if Catalog.canWrite (get #role_ currentUser)
            then case Security.descriptografarTexto Security.chaveMestraPadrao docHex of
                Right texto -> [hsx|<span><code>{texto}</code> <span class="badge bg-success ms-2">Descriptografado (Admin)</span></span>|]
                Left _      -> [hsx|<span class="text-danger">Erro de descriptografia</span>|]
            else case Security.descriptografarTexto Security.chaveMestraPadrao docHex of
                Right texto -> [hsx|<span><code>{Security.mascararDocumento texto}</code> <span class="badge bg-secondary ms-2">Mascarado (Consulta)</span></span>|]
                Left _      -> [hsx|<span class="text-muted">***</span>|]

newButton :: Html
newButton = when (Catalog.canWrite (get #role_ currentUser)) [hsx|<a class="btn btn-primary" href={NewAlunoAction}>Novo estudante</a>|]

renderForm :: Aluno -> [Curso] -> Html
renderForm aluno cursos = formFor aluno [hsx|
            {(textField #nome) { fieldLabel = "Nome", required = True }}
            {(textField #matricula) { fieldLabel = "Matrícula", required = True, helpText = "De 4 a 20 dígitos." }}
            {(textField #email) { fieldLabel = "E-mail", required = True }}
            {(selectField #cursoId cursos) { fieldLabel = "Curso", placeholder = "Sem curso" }}
            <div class="form-group mb-3">
                <label class="form-label" for="aluno_documento">Documento Confidencial (CPF/RG)</label>
                <input type="text" name="documento" id="aluno_documento" class="form-control" placeholder="Cifrado com chave simétrica no banco"/>
                <div class="form-text">Armazenado com criptografia simétrica; visível apenas para administradores.</div>
            </div>
            <button class="btn btn-primary" type="submit">Salvar estudante</button>
            <a class="btn btn-outline-secondary" href={AlunosAction}>Cancelar</a>
        |]
