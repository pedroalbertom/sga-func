module Web.Controller.Relatorios where

import Web.Controller.Prelude
import Web.View.Relatorios.Desempenho
import Web.View.Relatorios.Frequencia
import Web.View.Relatorios.Ranking
import Web.View.Relatorios.MeuBoletim
import qualified Application.Domain.Academic as Academic
import qualified Data.Map.Strict as Map

instance Controller RelatoriosController where
    beforeAction = requireRead

    action DesempenhoAction { turmaId } = do
        requireStaff
        turma <- findOr404 turmaId
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
        requireStaff
        turma <- findOr404 turmaId
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
        requireStaff
        notas <- query @Nota |> fetch
        alunos <- query @Aluno |> fetch

        let alunoMap = Map.fromList (map (\a -> (get #id a, a)) alunos)
        -- Chamada da função pura com composição de funções (.)
        let ranking = Academic.calcularRanking notas

        render RankingView { ranking, alunoMap }

    action MeuBoletimAction = do
        maybeAluno <- query @Aluno |> filterWhere (#email, get #email currentUser) |> fetchOneOrNothing
        case maybeAluno of
            Nothing -> render MeuBoletimView
                { maybeAluno = Nothing
                , notas = []
                , frequencias = []
                , turmaMap = Map.empty
                , disciplinaMap = Map.empty
                }
            Just aluno -> do
                notas <- query @Nota |> filterWhere (#alunoId, get #id aluno) |> fetch
                frequencias <- query @Frequencia |> filterWhere (#alunoId, get #id aluno) |> fetch
                turmas <- query @Turma |> fetch
                disciplinas <- query @Disciplina |> fetch
                let turmaMap = Map.fromList (map (\t -> (get #id t, t)) turmas)
                let disciplinaMap = Map.fromList (map (\d -> (get #id d, d)) disciplinas)
                render MeuBoletimView { maybeAluno = Just aluno, notas, frequencias, turmaMap, disciplinaMap }
