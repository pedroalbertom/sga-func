module Web.Controller.Alunos where

import Web.Controller.Prelude
import Data.Traversable (traverse)
import Web.View.Alunos
import qualified Application.Domain.Catalog as Catalog
import qualified Data.Text as Text

instance Controller AlunosController where
    beforeAction = requireRead

    action AlunosAction = do
        todos <- query @Aluno |> orderBy #nome |> fetch
        let busca = paramOrDefault "" "busca"
        cursos <- query @Curso |> orderBy #nome |> fetch
        let alunos = Catalog.buscarAlunos busca todos
        render IndexView { alunos, cursos, busca }

    action NewAlunoAction = do
        requireWrite
        let aluno = newRecord @Aluno
        cursos <- query @Curso |> orderBy #nome |> fetch
        render FormView { aluno, cursos }

    action ShowAlunoAction { alunoId } = do
        aluno <- findAlunoOr404 alunoId
        curso <- traverse fetch (get #cursoId aluno)
        render ShowView { aluno, curso }

    action EditAlunoAction { alunoId } = do
        requireWrite
        aluno <- findAlunoOr404 alunoId
        cursos <- query @Curso |> orderBy #nome |> fetch
        render FormView { aluno, cursos }

    action CreateAlunoAction = do
        requireWrite
        cursos <- query @Curso |> orderBy #nome |> fetch
        aluno <- buildAluno (newRecord @Aluno)
        aluno |> ifValid \case
            Left aluno -> render FormView { aluno, cursos }
            Right aluno -> do
                aluno <- createRecord aluno
                setSuccessMessage "Cadastro criado."
                redirectTo ShowAlunoAction { alunoId = get #id aluno }

    action UpdateAlunoAction { alunoId } = do
        requireWrite
        cursos <- query @Curso |> orderBy #nome |> fetch
        aluno <- findAlunoOr404 alunoId >>= buildAluno
        aluno |> ifValid \case
            Left aluno -> render FormView { aluno, cursos }
            Right aluno -> do
                aluno <- updateRecord aluno
                setSuccessMessage "Cadastro atualizado."
                redirectTo ShowAlunoAction { alunoId = get #id aluno }

    action DeleteAlunoAction { alunoId } = do
        requireWrite
        aluno <- findAlunoOr404 alunoId
        notas <- query @Nota |> filterWhere (#alunoId, alunoId) |> fetchCount
        frequencias <- query @Frequencia |> filterWhere (#alunoId, alunoId) |> fetchCount
        if notas > 0 || frequencias > 0
            then setErrorMessage "Este estudante possui notas ou frequências e não pode ser excluído."
            else do
                deleteRecord aluno
                setSuccessMessage "Estudante excluído."
        redirectTo AlunosAction

buildAluno :: (?request :: Request, ?modelContext :: ModelContext) => Aluno -> IO Aluno
buildAluno aluno = do
    aluno <- aluno
        |> fill @'["nome", "matricula", "email", "cursoId"]
        |> modify #nome Text.strip
        |> modify #matricula Text.strip
        |> modify #email (Text.toLower . Text.strip)
        |> validateField #nome Catalog.validName
        |> validateField #matricula Catalog.validMatricula
        |> validateField #email Catalog.validEmail
        |> validateIsUnique #matricula

    case get #cursoId aluno of
        Nothing -> pure aluno
        Just cursoId -> do
            exists <- query @Curso |> filterWhere (#id, cursoId) |> fetchExists
            pure (if exists then aluno else attachValidatorResult #cursoId (Failure "Selecione um curso existente.") aluno)

findAlunoOr404 :: (?request :: Request, ?respond :: Respond, ?modelContext :: ModelContext) => Id Aluno -> IO Aluno
findAlunoOr404 alunoId = do
    record <- fetchOneOrNothing alunoId
    case record of
        Nothing -> earlyReturn renderNotFound
        Just record -> pure record
