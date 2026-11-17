module Web.Controller.Dashboard where

import Web.Controller.Prelude
import Web.View.Dashboard.Index
import qualified Application.Domain.Dashboard as Dashboard
import qualified Data.Map.Strict as Map
import qualified Data.Text as Text

instance Controller DashboardController where
    beforeAction = requireStaff

    action DashboardAction = do
        let cursoSelecionado = paramOrNothing @(Id Curso) "cursoId"

        cursos <- query @Curso |> orderBy #nome |> fetch
        turmas <- query @Turma |> fetch
        disciplinas <- query @Disciplina |> fetch
        notas  <- query @Nota |> fetch
        freqs  <- query @Frequencia |> fetch

        alunosBrutos <- case cursoSelecionado of
            Nothing -> query @Aluno |> orderBy #nome |> fetch
            Just cId -> query @Aluno |> filterWhere (#cursoId, Just cId) |> orderBy #nome |> fetch

        let resumos = Dashboard.gerarResumoAlunos alunosBrutos notas freqs
        let metricasGerais = Dashboard.calcularMetricasGerais alunosBrutos cursos turmas resumos
        let metricasCursos = Dashboard.calcularMetricasPorCurso cursos alunosBrutos resumos
        let topAlunos = Dashboard.obterRankingTopN 5 resumos
        let alunosCriticos = Dashboard.obterEstudantesCriticos resumos
        let disciplinaMap = Map.fromList (map (\d -> (get #id d, d)) disciplinas)

        render IndexView
            { metricasGerais
            , metricasCursos
            , topAlunos
            , alunosCriticos
            , cursos
            , cursoSelecionado
            , turmas
            , disciplinaMap
            }

    action RegistrarRecuperacaoAction = do
        requireWrite
        let alunoId = param @(Id Aluno) "alunoId"
        let turmaId = param @(Id Turma) "turmaId"
        let tipo    = paramOrDefault @Text "nota" "tipo"

        _ <- findOr404 alunoId
        _ <- findOr404 turmaId

        if tipo == "presenca"
            then do
                _ <- newRecord @Frequencia
                    |> set #alunoId alunoId
                    |> set #turmaId turmaId
                    |> set #presente True
                    |> createRecord
                setSuccessMessage "Presença de reposição registrada."
            else do
                let valor = paramOrDefault @Double 7.0 "valor"
                let descricao = Text.strip (paramOrDefault @Text "Recuperação" "descricao")
                if valor < 0.0 || valor > 10.0
                    then setErrorMessage "A nota de recuperação deve ficar entre 0 e 10."
                    else do
                        _ <- newRecord @Nota
                            |> set #alunoId alunoId
                            |> set #turmaId turmaId
                            |> set #valor valor
                            |> set #descricao (if Text.null descricao then "Recuperação" else descricao)
                            |> createRecord
                        setSuccessMessage "Nota de recuperação lançada."

        redirectTo DashboardAction
