module Web.Controller.Professores where

import Web.Controller.Prelude
import Web.View.Professores
import qualified Application.Domain.Catalog as Catalog
import qualified Data.Map.Strict as Map
import qualified Data.Text as Text

instance Controller ProfessoresController where
    beforeAction = requireRead

    action ProfessoresAction = do
        todos <- query @Professore |> orderBy #nome |> fetch
        let busca = paramOrDefault "" "busca"
        let professores = Catalog.buscarProfessores busca todos
        render IndexView { professores, busca }

    action NewProfessorAction = do
        requireWrite
        let professor = newRecord @Professore
        render FormView { professor }

    action ShowProfessorAction { professorId } = do
        professor <- findOr404 professorId
        turmas <- query @Turma |> filterWhere (#professorId, professorId) |> orderByDesc #semestre |> fetch
        disciplinas <- query @Disciplina |> fetch
        let disciplinaMap = Map.fromList (map (\d -> (get #id d, d)) disciplinas)
        render ShowView { professor, turmas, disciplinaMap }

    action EditProfessorAction { professorId } = do
        requireWrite
        professor <- findOr404 professorId
        render FormView { professor }

    action CreateProfessorAction = do
        requireWrite
        professor <- buildProfessor (newRecord @Professore)
        professor |> ifValid \case
            Left professor -> render FormView { professor }
            Right professor -> do
                professor <- createRecord professor
                setSuccessMessage "Professor cadastrado."
                redirectTo ShowProfessorAction { professorId = get #id professor }

    action UpdateProfessorAction { professorId } = do
        requireWrite
        professor <- findOr404 professorId >>= buildProfessor
        professor |> ifValid \case
            Left professor -> render FormView { professor }
            Right professor -> do
                professor <- updateRecord professor
                setSuccessMessage "Cadastro atualizado."
                redirectTo ShowProfessorAction { professorId = get #id professor }

    action DeleteProfessorAction { professorId } = do
        requireWrite
        professor <- findOr404 professorId
        turmas <- query @Turma |> filterWhere (#professorId, professorId) |> fetchCount
        if turmas > 0
            then setErrorMessage "Este professor possui turmas vinculadas e não pode ser excluído."
            else do
                deleteRecord professor
                setSuccessMessage "Professor excluído."
        redirectTo ProfessoresAction

buildProfessor :: (?request :: Request, ?modelContext :: ModelContext) => Professore -> IO Professore
buildProfessor professor = professor
    |> fill @'["nome", "email"]
    |> modify #nome Text.strip
    |> modify #email (Text.toLower . Text.strip)
    |> validateField #nome Catalog.validName
    |> validateField #email Catalog.validEmail
    |> validateIsUnique #email
