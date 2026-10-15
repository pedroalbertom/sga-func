module Web.Controller.Cursos where

import Web.Controller.Prelude
import Web.View.Cursos
import qualified Application.Domain.Catalog as Catalog
import qualified Data.Text as Text

instance Controller CursosController where
    beforeAction = requireRead

    action CursosAction = do
        todos <- query @Curso |> orderBy #nome |> fetch
        let busca = paramOrDefault "" "busca"
        alunos <- query @Aluno |> fetch
        let cursos = Catalog.buscarCursos busca todos
        let resumo = Catalog.resumoCursos cursos alunos
        let vinculados = Catalog.estudantesPorCurso cursos alunos
        render IndexView { cursos, busca, resumo, vinculados }

    action NewCursoAction = do
        requireWrite
        let curso = newRecord @Curso
        render FormView { curso }

    action ShowCursoAction { cursoId } = do
        curso <- findCursoOr404 cursoId
        alunos <- query @Aluno |> filterWhere (#cursoId, Just cursoId) |> orderBy #nome |> fetch
        render ShowView { curso, alunos }

    action EditCursoAction { cursoId } = do
        requireWrite
        curso <- findCursoOr404 cursoId
        render FormView { curso }

    action CreateCursoAction = do
        requireWrite
        curso <- buildCurso (newRecord @Curso)
        curso |> ifValid \case
            Left curso -> render FormView { curso }
            Right curso -> do
                curso <- createRecord curso
                setSuccessMessage "Cadastro criado."
                redirectTo ShowCursoAction { cursoId = get #id curso }

    action UpdateCursoAction { cursoId } = do
        requireWrite
        curso <- findCursoOr404 cursoId >>= buildCurso
        curso |> ifValid \case
            Left curso -> render FormView { curso }
            Right curso -> do
                curso <- updateRecord curso
                setSuccessMessage "Cadastro atualizado."
                redirectTo ShowCursoAction { cursoId = get #id curso }

    action DeleteCursoAction { cursoId } = do
        requireWrite
        curso <- findCursoOr404 cursoId
        alunos <- query @Aluno |> filterWhere (#cursoId, Just cursoId) |> fetchCount
        if alunos > 0
            then setErrorMessage "O curso possui estudantes vinculados. Transfira-os antes de excluir."
            else do
                deleteRecord curso
                setSuccessMessage "Curso excluído."
        redirectTo CursosAction

buildCurso :: (?request :: Request, ?modelContext :: ModelContext) => Curso -> IO Curso
buildCurso curso = do
    curso <- curso
        |> fill @'["nome", "codigo", "cargaHoraria"]
        |> modify #nome Text.strip
        |> modify #codigo (Text.toUpper . Text.strip)
        |> validateField #nome Catalog.validName
        |> validateField #codigo Catalog.validCode
        |> validateField #cargaHoraria (isInRange (1, 10000) |> withCustomErrorMessage "A carga horária deve ficar entre 1 e 10000 horas.")
        |> validateIsUnique #codigo

    pure curso

findCursoOr404 :: (?request :: Request, ?respond :: Respond, ?modelContext :: ModelContext) => Id Curso -> IO Curso
findCursoOr404 cursoId = do
    record <- fetchOneOrNothing cursoId
    case record of
        Nothing -> earlyReturn renderNotFound
        Just record -> pure record
