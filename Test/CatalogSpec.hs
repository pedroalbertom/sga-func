module Test.CatalogSpec where

import IHP.Prelude
import IHP.ModelSupport
import IHP.ValidationSupport
import Generated.Types
import Application.Domain.Catalog
import Test.Hspec

spec :: Spec
spec = describe "Sprint 2: catálogo e permissões" do
    it "permite leitura aos dois perfis e escrita apenas ao admin" do
        map canRead ["admin", "consulta", "", "professor"] `shouldBe` [True, True, False, False]
        map canWrite ["admin", "consulta", "", "ADMIN"] `shouldBe` [True, False, False, False]
    it "rejeita nomes vazios e matrículas não numéricas" do
        validName "  " `shouldNotBe` Success
        validName "Ana" `shouldBe` Success
        validMatricula "1234" `shouldBe` Success
        map validMatricula ["123", "12ab", "１２３４", "123456789012345678901"] `shouldSatisfy` all (/= Success)
    it "valida código, e-mail e limites" do
        map validCode ["ADS", "CC-01"] `shouldBe` [Success, Success]
        map validCode ["-ADS", "a", "A B", ""] `shouldSatisfy` all (/= Success)
        validEmail "ana@unifor.br" `shouldBe` Success
        map validEmail ["ana", "ana@", "a@@b.br", "a@b", "a b@c.br", "a@b."] `shouldSatisfy` all (/= Success)
    let c1 = newRecord @Curso |> set #id (Id "00000000-0000-0000-0000-000000000001") |> set #nome "Computação" |> set #codigo "CC"
    let c2 = newRecord @Curso |> set #id (Id "00000000-0000-0000-0000-000000000002") |> set #nome "Direito" |> set #codigo "DIR"
    let a1 = newRecord @Aluno |> set #nome "Ana" |> set #matricula "202601" |> set #email "ana@unifor.br" |> set #cursoId (Just (get #id c1))
    let a2 = newRecord @Aluno |> set #nome "Bruno" |> set #matricula "202602" |> set #email "bruno@unifor.br" |> set #cursoId Nothing
    it "filter busca sem diferenciar maiúsculas por nome, matrícula e email" do
        map (get #nome) (buscarAlunos "ANA" [a1,a2]) `shouldBe` ["Ana"]
        map (get #nome) (buscarAlunos "202602" [a1,a2]) `shouldBe` ["Bruno"]
        length (buscarAlunos "unifor.br" [a1,a2]) `shouldBe` 2
        buscarAlunos "inexistente" [a1,a2] `shouldBe` []
        length (buscarCursos "dir" [c1,c2]) `shouldBe` 1
    it "map e foldr contam vínculos, inclusive cursos vazios" do
        map snd (resumoCursos [c1,c2] [a1,a2]) `shouldBe` [1,0]
        resumoCursos [] [a1,a2] `shouldBe` []
    it "concatMap achata somente estudantes com curso correspondente" do
        estudantesPorCurso [c1,c2] [a1,a2] `shouldBe` [("Computação", "Ana")]
        estudantesPorCurso [c1] [] `shouldBe` []
