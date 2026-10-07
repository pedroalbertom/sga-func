module Test.AcademicSpec where

import Test.Hspec
import IHP.Prelude
import Application.Domain.Academic

spec :: Spec
spec = describe "Application.Domain.Academic" do

    describe "Closures e Currying" do
        it "calcula média ponderada curried corretamente" do
            let pesos = [2.0, 3.0, 5.0]
            let notas = [8.0, 7.0, 9.0]
            -- (2*8 + 3*7 + 5*9) / 10 = (16 + 21 + 45) / 10 = 8.2
            calcularMediaPonderada pesos notas `shouldBe` Just 8.2

        it "retorna Nothing para listas de tamanhos divergentes" do
            calcularMediaPonderada [2.0, 3.0] [8.0] `shouldBe` Nothing

        it "closure com pesos semestrais fixos funciona via currying" do
            calculadoraMediaSemestral [10.0, 10.0, 10.0] `shouldBe` Just 10.0

        it "calcula média aritmética simples" do
            calcularMediaSimples [8.0, 6.0, 10.0] `shouldBe` Just 8.0
            calcularMediaSimples [] `shouldBe` Nothing

    describe "Pattern Matching e Guards" do
        it "aprova aluno com média >= 7.0 e frequência >= 75%" do
            avaliarSituacao 8.5 90.0 `shouldBe` Aprovado

        it "reprova por falta quando frequência < 75% mesmo com nota 10" do
            avaliarSituacao 10.0 70.0 `shouldBe` ReprovadoPorFalta

        it "coloca em prova final quem tem média entre 4.0 e 7.0 com presença regular" do
            case avaliarSituacao 5.5 80.0 of
                ProvaFinal notaFinal -> notaFinal `shouldSatisfy` (> 0)
                _                    -> expectationFailure "Deveria estar em prova final"

        it "reprova por nota com média < 4.0" do
            avaliarSituacao 3.5 80.0 `shouldBe` ReprovadoPorNota

        it "classifica conceitos por faixas de notas" do
            classificarConceito 9.5 `shouldBe` ConceitoA
            classificarConceito 8.5 `shouldBe` ConceitoB
            classificarConceito 7.2 `shouldBe` ConceitoC
            classificarConceito 5.5 `shouldBe` ConceitoD
            classificarConceito 3.0 `shouldBe` ConceitoF

        it "formata situacao por pattern matching exaustivo" do
            formatarSituacao Aprovado `shouldBe` "Aprovado por Média"
            formatarSituacao ReprovadoPorFalta `shouldBe` "Reprovado por Frequência"

    describe "List Comprehensions" do
        let turma = [ ("Alice", 9.0, 100.0)
                    , ("Bruno", 7.5, 80.0)
                    , ("Carla", 5.5, 60.0)
                    , ("Daniel", 3.0, 40.0)
                    ]

        it "filtra nomes aprovados usando list comprehension" do
            obterNomesAprovados turma `shouldBe` ["Alice", "Bruno"]

        it "identifica alunos em situação de risco" do
            let emRisco = obterAlunosEmRisco turma
            map fst emRisco `shouldBe` ["Carla", "Daniel"]

    describe "Agregações Funcionais (map, foldr, composição)" do
        it "agrupa notas e calcula médias individuais com foldr e map" do
            let notas = [ ("aluno1", 8.0)
                        , ("aluno1", 10.0)
                        , ("aluno2", 6.0)
                        , ("aluno2", 8.0)
                        ]
            let resultado = agruparECalcularMedias notas
            resultado `shouldBe` [("aluno1", 9.0), ("aluno2", 7.0)]

        it "agrupa frequências e calcula percentual de presença com foldr e map" do
            let freqs = [ ("aluno1", True)
                        , ("aluno1", True)
                        , ("aluno2", True)
                        , ("aluno2", False)
                        ]
            let resultado = agruparECalcularFrequencias freqs
            resultado `shouldBe` [("aluno1", 100.0), ("aluno2", 50.0)]

        it "ordena ranking em ordem decrescente via composição de funções" do
            let ranking = ordenarRanking [("aluno2", 7.0), ("aluno1", 9.5), ("aluno3", 5.0)]
            map fst ranking `shouldBe` ["aluno1", "aluno2", "aluno3"]
