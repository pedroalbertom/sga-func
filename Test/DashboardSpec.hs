module Test.DashboardSpec where

import Test.Hspec
import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import Application.Domain.Dashboard
import Application.Domain.Academic (Situacao(..))

spec :: Spec
spec = describe "Sprint 4: Dashboard Acadêmico, Agregações & SSR" do

    let a1 = newRecord @Aluno
            |> set #id (Id "00000000-0000-0000-0000-000000000101")
            |> set #nome "Alice Silva"
            |> set #matricula "241001"
            |> set #email "alice@unifor.br"
            |> set #cursoId (Just (Id "00000000-0000-0000-0000-000000000001"))

    let a2 = newRecord @Aluno
            |> set #id (Id "00000000-0000-0000-0000-000000000102")
            |> set #nome "Bruno Santos"
            |> set #matricula "241002"
            |> set #email "bruno@unifor.br"
            |> set #cursoId (Just (Id "00000000-0000-0000-0000-000000000001"))

    let a3 = newRecord @Aluno
            |> set #id (Id "00000000-0000-0000-0000-000000000103")
            |> set #nome "Carla Lima"
            |> set #matricula "241003"
            |> set #email "carla@unifor.br"
            |> set #cursoId Nothing

    let curso1 = newRecord @Curso
            |> set #id (Id "00000000-0000-0000-0000-000000000001")
            |> set #nome "Ciência da Computação"
            |> set #codigo "CC"
            |> set #cargaHoraria 3000

    let turma1 = newRecord @Turma
            |> set #id (Id "00000000-0000-0000-0000-000000000020")
            |> set #semestre "2026.1"

    let n1 = newRecord @Nota |> set #alunoId (get #id a1) |> set #valor 9.0
    let n2 = newRecord @Nota |> set #alunoId (get #id a1) |> set #valor 10.0
    let n3 = newRecord @Nota |> set #alunoId (get #id a2) |> set #valor 5.0
    let n4 = newRecord @Nota |> set #alunoId (get #id a3) |> set #valor 3.0

    let f1 = newRecord @Frequencia |> set #alunoId (get #id a1) |> set #presente True
    let f2 = newRecord @Frequencia |> set #alunoId (get #id a2) |> set #presente True
    let f3 = newRecord @Frequencia |> set #alunoId (get #id a2) |> set #presente False

    let resumos = gerarResumoAlunos [a1, a2, a3] [n1, n2, n3, n4] [f1, f2, f3]

    describe "Resumo e Consolidação Individual" do
        it "calcula corretamente as médias e presenças de cada aluno" do
            let resumoAlice = find (\r -> get #id (aluno r) == get #id a1) resumos
            fmap media resumoAlice `shouldBe` Just 9.5
            fmap situacao resumoAlice `shouldBe` Just Aprovado

            let resumoBruno = find (\r -> get #id (aluno r) == get #id a2) resumos
            fmap media resumoBruno `shouldBe` Just 5.0
            fmap presenca resumoBruno `shouldBe` Just 50.0
            fmap situacao resumoBruno `shouldBe` Just ReprovadoPorFalta

    describe "Agregações Globais do Dashboard" do
        it "calcula KPIs institucionais com precisão" do
            let metricas = calcularMetricasGerais [a1, a2, a3] [curso1] [turma1] resumos
            totalEstudantes metricas `shouldBe` 3
            totalCursosCadastrados metricas `shouldBe` 1
            quantidadeEmRisco metricas `shouldBe` 2
            mediaInstitucional metricas `shouldBe` 5.83

    describe "Métricas por Curso" do
        it "agrupa quantidades e médias por curso" do
            let metricasCursos = calcularMetricasPorCurso [curso1] [a1, a2, a3] resumos
            length metricasCursos `shouldBe` 1
            let mc = head metricasCursos
            qtdEstudantes mc `shouldBe` 2
            mediaNotas mc `shouldBe` 7.25

    describe "Ranking e Alertas Críticos" do
        it "ordena o top ranking de forma decrescente por média" do
            let top2 = obterRankingTopN 2 resumos
            map (get #nome . aluno) top2 `shouldBe` ["Alice Silva", "Bruno Santos"]

        it "filtra os estudantes em situação crítica (não aprovados)" do
            let criticos = obterEstudantesCriticos resumos
            map (get #nome . aluno) criticos `shouldBe` ["Bruno Santos", "Carla Lima"]
