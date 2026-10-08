module Test.AcademicSpec where

import Test.Hspec
import IHP.Prelude
import Application.Domain.Academic

spec :: Spec
spec = describe "Application.Domain.Academic" do

    describe "Currying e Closures" do
        it "calcula média ponderada com currying" do
            mediaPonderada [2.0, 3.0, 5.0] [8.0, 7.0, 9.0] `shouldBe` 8.2

        it "closure com pesos fixos calcula corretamente" do
            mediaSemestre [10.0, 10.0, 10.0] `shouldBe` 10.0

        it "calcula média simples" do
            mediaSimples [8.0, 6.0, 10.0] `shouldBe` 8.0

    describe "Pattern Matching e Guards" do
        it "aprova aluno com média >= 7 e presença >= 75%" do
            situacaoAluno 8.0 90.0 `shouldBe` Aprovado

        it "reprova por falta se presença for menor que 75%" do
            situacaoAluno 10.0 70.0 `shouldBe` ReprovadoPorFalta

        it "coloca em final se a média for entre 4 e 7" do
            situacaoAluno 5.5 80.0 `shouldBe` ProvaFinal

        it "reprova por nota se a média for menor que 4" do
            situacaoAluno 3.0 80.0 `shouldBe` ReprovadoPorNota

        it "classifica os conceitos de A até F" do
            conceitoAluno 9.5 `shouldBe` A
            conceitoAluno 8.5 `shouldBe` B
            conceitoAluno 7.5 `shouldBe` C
            conceitoAluno 5.5 `shouldBe` D
            conceitoAluno 3.0 `shouldBe` F

        it "formata situacao para exibição na tela" do
            formataSituacao Aprovado `shouldBe` "Aprovado"
            formataSituacao ReprovadoPorFalta `shouldBe` "Reprovado por Falta"

    describe "List Comprehensions" do
        let turma = [ ("Alice", 9.0, 100.0)
                    , ("Bruno", 7.5, 80.0)
                    , ("Carla", 5.5, 60.0)
                    , ("Daniel", 3.0, 40.0)
                    ]

        it "filtra nomes dos aprovados com list comprehension" do
            nomesAprovados turma `shouldBe` ["Alice", "Bruno"]

        it "filtra alunos em situação de risco com list comprehension" do
            let emRisco = alunosEmRisco turma
            map fst emRisco `shouldBe` ["Carla", "Daniel"]
