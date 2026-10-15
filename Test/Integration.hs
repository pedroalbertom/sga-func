module Main where

import Test.Hspec
import IHP.Prelude
import IHP.ControllerPrelude
import IHP.Test.Mocking
import Generated.Types
import Config
import Web.Types
import Web.FrontController ()
import System.Environment (getEnv)
import System.Process (callProcess)
import Network.Wai (responseStatus)
import Network.HTTP.Types.Status (statusCode)

main :: IO ()
main = do
    databaseUrl <- getEnv "DATABASE_URL"
    -- Test-only DDL is loaded by psql; application queries remain typed.
    callProcess "psql" [databaseUrl, "-v", "ON_ERROR_STOP=1", "-c", "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";", "-f", "Application/Schema.sql"]
    callProcess "psql" [databaseUrl, "-v", "ON_ERROR_STOP=1", "-f", "Application/Fixtures.sql"]
    hspec $ aroundAll (withMockContext WebApplication config) do
        describe "Sprint 2: autorização HTTP" do
            it "redireciona visitante ao login" $ withContext do
                response <- callAction AlunosAction
                statusCode (responseStatus response) `shouldSatisfy` (`elem` [302,303])
            it "consulta lê mas não cria, edita ou exclui por URL direta" $ withContext do
                let user = newRecord @User |> set #role_ "consulta"
                withUser user do
                    response <- callAction CursosAction
                    statusCode (responseStatus response) `shouldBe` 200
                    forEach [NewCursoAction, CreateCursoAction, EditCursoAction def, UpdateCursoAction def, DeleteCursoAction def] \action -> do
                        response <- callAction action
                        statusCode (responseStatus response) `shouldBe` 403
                    forEach [NewAlunoAction, CreateAlunoAction, EditAlunoAction def, UpdateAlunoAction def, DeleteAlunoAction def] \action -> do
                        response <- callAction action
                        statusCode (responseStatus response) `shouldBe` 403
            it "admin executa CRUD, valida duplicidade e protege curso com estudantes" $ withContext do
                let user = newRecord @User |> set #role_ "admin"
                withUser user do
                    response <- callActionWithParams CreateCursoAction [("nome", "Curso Demo"), ("codigo", "DEMO"), ("cargaHoraria", "60")]
                    statusCode (responseStatus response) `shouldBe` 302
                    curso <- query @Curso |> filterWhere (#codigo, "DEMO") |> fetchOne
                    response <- callActionWithParams CreateCursoAction [("nome", "Duplicado"), ("codigo", "DEMO"), ("cargaHoraria", "60")]
                    statusCode (responseStatus response) `shouldBe` 200
                    (query @Curso |> filterWhere (#codigo, "DEMO") |> fetchCount) >>= (`shouldBe` 1)
                    response <- callActionWithParams CreateAlunoAction [("nome", "Estudante Demo"), ("matricula", "20269999"), ("email", "demo@unifor.br"), ("cursoId", cs (tshow (get #id curso)))]
                    statusCode (responseStatus response) `shouldBe` 302
                    aluno <- query @Aluno |> filterWhere (#matricula, "20269999") |> fetchOne
                    response <- callActionWithParams CreateAlunoAction [("nome", "Outro"), ("matricula", "20269999"), ("email", "outro@unifor.br"), ("cursoId", "")]
                    statusCode (responseStatus response) `shouldBe` 200
                    (query @Aluno |> filterWhere (#matricula, "20269999") |> fetchCount) >>= (`shouldBe` 1)
                    response <- callAction (DeleteCursoAction (get #id curso))
                    statusCode (responseStatus response) `shouldBe` 302
                    fetch (get #id curso) >>= (\c -> get #nome c `shouldBe` "Curso Demo")
                    response <- callActionWithParams (UpdateCursoAction (get #id curso)) [("nome", "Curso Atualizado"), ("codigo", "DEMO"), ("cargaHoraria", "120")]
                    statusCode (responseStatus response) `shouldBe` 302
                    fetch (get #id curso) >>= (\c -> get #cargaHoraria c `shouldBe` 120)
                    response <- callActionWithParams (UpdateAlunoAction (get #id aluno)) [("nome", "Estudante Atualizado"), ("matricula", "20269999"), ("email", "novo@unifor.br"), ("cursoId", "")]
                    statusCode (responseStatus response) `shouldBe` 302
                    fetch (get #id aluno) >>= (\a -> get #nome a `shouldBe` "Estudante Atualizado")
                    response <- callAction (ShowAlunoAction (get #id aluno))
                    statusCode (responseStatus response) `shouldBe` 200
                    response <- callAction (ShowCursoAction (get #id curso))
                    statusCode (responseStatus response) `shouldBe` 200
                    _ <- callAction (DeleteAlunoAction (get #id aluno))
                    _ <- callAction (DeleteCursoAction (get #id curso))
                    (query @Aluno |> filterWhere (#matricula, "20269999") |> fetchCount) >>= (`shouldBe` 0)
                    (query @Curso |> filterWhere (#codigo, "DEMO") |> fetchCount) >>= (`shouldBe` 0)
            it "protege estudante com histórico e rejeita dados inválidos no formulário" $ withContext do
                let user = newRecord @User |> set #role_ "admin"
                withUser user do
                    aluno <- query @Aluno |> filterWhere (#matricula, "241001") |> fetchOne
                    _ <- callAction (DeleteAlunoAction (get #id aluno))
                    (query @Aluno |> filterWhere (#matricula, "241001") |> fetchCount) >>= (`shouldBe` 1)
                    response <- callActionWithParams CreateAlunoAction [("nome", " "), ("matricula", "abc"), ("email", "invalido"), ("cursoId", "")]
                    statusCode (responseStatus response) `shouldBe` 200
                    (query @Aluno |> filterWhere (#matricula, "abc") |> fetchCount) >>= (`shouldBe` 0)
            it "retorna 404 para cadastros inexistentes" $ withContext do
                let user = newRecord @User |> set #role_ "admin"
                withUser user do
                    forEach [ShowAlunoAction def, EditAlunoAction def, DeleteAlunoAction def] \action -> do
                        response <- callAction action
                        statusCode (responseStatus response) `shouldBe` 404
                    forEach [ShowCursoAction def, EditCursoAction def, DeleteCursoAction def] \action -> do
                        response <- callAction action
                        statusCode (responseStatus response) `shouldBe` 404
            it "valida senha e registra tentativas incorretas" $ withContext do
                passwordHash <- hashPassword "senha-de-teste-123"
                user <- newRecord @User |> set #email "login@example.com" |> set #passwordHash passwordHash |> set #role_ "consulta" |> createRecord
                _ <- callActionWithParams CreateSessionAction [("email", "login@example.com"), ("password", "incorreta")]
                fetch (get #id user) >>= (\u -> get #failedLoginAttempts u `shouldBe` 1)
                response <- callActionWithParams CreateSessionAction [("email", "login@example.com"), ("password", "senha-de-teste-123")]
                statusCode (responseStatus response) `shouldBe` 303
                fetch (get #id user) >>= (\u -> get #failedLoginAttempts u `shouldBe` 0)
        describe "Constraints PostgreSQL" do
            it "rejeita curso com carga horária inválida mesmo fora do formulário" $ withContext do
                (newRecord @Curso |> set #nome "Inválido" |> set #codigo "INV" |> set #cargaHoraria 0 |> createRecord) `shouldThrow` anyException
            it "rejeita perfil desconhecido no banco" $ withContext do
                (newRecord @User |> set #email "x@example.com" |> set #passwordHash "unused" |> set #role_ "superuser" |> createRecord) `shouldThrow` anyException
            it "rejeita vínculo a curso inexistente" $ withContext do
                (newRecord @Aluno |> set #nome "Ana" |> set #matricula "20260001" |> set #email "ana@example.com" |> set #cursoId (Just (Id "ffffffff-ffff-ffff-ffff-ffffffffffff")) |> createRecord) `shouldThrow` anyException
