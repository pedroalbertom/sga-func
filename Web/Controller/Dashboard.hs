module Web.Controller.Dashboard where

import Web.Controller.Prelude
import Web.View.Dashboard.Index
import qualified Application.Domain.Dashboard as Dashboard

instance Controller DashboardController where
    beforeAction = requireRead

    action DashboardAction = do
        let cursoSelecionado = paramOrNothing @(Id Curso) "cursoId"

        cursos <- query @Curso |> orderBy #nome |> fetch
        turmas <- query @Turma |> fetch
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

        render IndexView
            { metricasGerais
            , metricasCursos
            , topAlunos
            , alunosCriticos
            , cursos
            , cursoSelecionado
            }
