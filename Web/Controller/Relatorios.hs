module Web.Controller.Relatorios where

import Web.Controller.Prelude
import Web.View.Relatorios.Desempenho
import Web.View.Relatorios.Frequencia
import Web.View.Relatorios.Ranking
import qualified Application.Domain.Academic as Academic
import qualified Data.Map.Strict as Map

instance Controller RelatoriosController where
    action DesempenhoAction { turmaId } = do
        turma <- fetch turmaId
        disciplina <- fetch (get #disciplinaId turma)
        notas <- query @Nota
            |> filterWhere (#turmaId, turmaId)
            |> fetch
        alunos <- query @Aluno |> fetch

        let alunoMap = Map.fromList (map (\a -> (get #id a, a)) alunos)
        -- Chamada da função pura do guia da disciplina
        let mediasCalculadas = Academic.calcularDesempenho notas

        let mediaGeral = case mediasCalculadas of
                [] -> 0.0
                xs -> sum (map snd xs) / fromIntegral (length xs)

        render DesempenhoView { turma, disciplina, mediasCalculadas, alunoMap, mediaGeral }

    action FrequenciaAction { turmaId } = do
        turma <- fetch turmaId
        disciplina <- fetch (get #disciplinaId turma)
        frequencias <- query @Frequencia
            |> filterWhere (#turmaId, turmaId)
            |> fetch
        alunos <- query @Aluno |> fetch

        let alunoMap = Map.fromList (map (\a -> (get #id a, a)) alunos)
        -- Chamada da função pura do guia da disciplina
        let frequenciasCalculadas = Academic.calcularFrequencia frequencias

        render FrequenciaView { turma, disciplina, frequenciasCalculadas, alunoMap }

    action RankingAction = do
        notas <- query @Nota |> fetch
        alunos <- query @Aluno |> fetch

        let alunoMap = Map.fromList (map (\a -> (get #id a, a)) alunos)
        -- Chamada da função pura com composição de funções (.)
        let ranking = Academic.calcularRanking notas

        render RankingView { ranking, alunoMap }
