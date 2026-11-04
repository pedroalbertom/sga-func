module Application.Domain.Dashboard where

import IHP.Prelude
import Generated.Types
import qualified Data.Map.Strict as Map
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))
import Application.Domain.Academic (Situacao(..), situacaoAluno, arredondar)

-- ============================================================================
-- 1. TIPOS DE DADOS PARA MÉTRICAS AGREGADAS DO DASHBOARD
-- ============================================================================

data MetricasGerais = MetricasGerais
    { totalEstudantes       :: Int
    , totalCursosCadastrados :: Int
    , totalTurmasAtivas     :: Int
    , mediaInstitucional    :: Double
    , percentualAprovacao   :: Double
    , quantidadeEmRisco     :: Int
    } deriving (Eq, Show)

data MetricaCurso = MetricaCurso
    { curso          :: Curso
    , qtdEstudantes  :: Int
    , mediaNotas     :: Double
    } deriving (Eq, Show)

data AlunoResumoDashboard = AlunoResumoDashboard
    { aluno     :: Aluno
    , media     :: Double
    , presenca  :: Double
    , situacao  :: Situacao
    } deriving (Eq, Show)


-- ============================================================================
-- 2. FUNÇÕES PURAS DE AGREGAÇÃO E CÁLCULO
-- ============================================================================

-- Calcula médias de notas por aluno
calcularMediasAlunos :: [Nota] -> Map.Map (Id Aluno) Double
calcularMediasAlunos notas =
    let agrupado = foldr (\n acc -> Map.insertWith (++) (get #alunoId n) [get #valor n] acc) Map.empty notas
    in Map.map (\vals -> if null vals then 0.0 else sum vals / fromIntegral (length vals)) agrupado

-- Calcula percentual de presenças por aluno
calcularPresencasAlunos :: [Frequencia] -> Map.Map (Id Aluno) Double
calcularPresencasAlunos freqs =
    let agrupado = foldr (\f acc -> Map.insertWith (++) (get #alunoId f) [get #presente f] acc) Map.empty freqs
    in Map.map (\fs -> if null fs then 0.0 else (fromIntegral (length (filter (== True) fs)) / fromIntegral (length fs)) * 100.0) agrupado

-- Gera o resumo consolidado de cada aluno (média, presença e situação)
gerarResumoAlunos :: [Aluno] -> [Nota] -> [Frequencia] -> [AlunoResumoDashboard]
gerarResumoAlunos alunos notas freqs =
    let mapaMedias    = calcularMediasAlunos notas
        mapaPresencas = calcularPresencasAlunos freqs
    in map (\a ->
        let m = Map.findWithDefault 0.0 (get #id a) mapaMedias
            p = Map.findWithDefault 100.0 (get #id a) mapaPresencas
            sit = situacaoAluno m p
        in AlunoResumoDashboard
            { aluno = a
            , media = arredondar m
            , presenca = arredondar p
            , situacao = sit
            }
       ) alunos

-- Agregação global de KPIs institucionais para os cards do Dashboard
calcularMetricasGerais :: [Aluno] -> [Curso] -> [Turma] -> [AlunoResumoDashboard] -> MetricasGerais
calcularMetricasGerais alunos cursos turmas resumos =
    let totEstudantes = length alunos
        totCursos = length cursos
        totTurmas = length turmas
        mediasValidas = filter (> 0.0) (map (\r -> media r) resumos)
        mediaInst = if null mediasValidas then 0.0 else sum mediasValidas / fromIntegral (length mediasValidas)
        aprovados = length (filter (\r -> situacao r == Aprovado) resumos)
        percAp = if totEstudantes == 0 then 0.0 else (fromIntegral aprovados / fromIntegral totEstudantes) * 100.0
        emRisco = length (filter (\r -> situacao r /= Aprovado) resumos)
    in MetricasGerais
        { totalEstudantes       = totEstudantes
        , totalCursosCadastrados = totCursos
        , totalTurmasAtivas     = totTurmas
        , mediaInstitucional    = arredondar mediaInst
        , percentualAprovacao   = arredondar percAp
        , quantidadeEmRisco     = emRisco
        }

-- Agregação de métricas por curso (quantidade de alunos e média do curso)
calcularMetricasPorCurso :: [Curso] -> [Aluno] -> [AlunoResumoDashboard] -> [MetricaCurso]
calcularMetricasPorCurso cursos alunos resumos =
    let resumoMap = Map.fromList (map (\r -> (get #id (aluno r), media r)) resumos)
    in map (\c ->
        let alunosDoCurso = filter (\a -> get #cursoId a == Just (get #id c)) alunos
            medias = mapMaybe (\a -> Map.lookup (get #id a) resumoMap) alunosDoCurso
            mediaCurso = if null medias then 0.0 else sum medias / fromIntegral (length medias)
        in MetricaCurso
            { curso = c
            , qtdEstudantes = length alunosDoCurso
            , mediaNotas = arredondar mediaCurso
            }
       ) cursos

-- Ranking dos top N alunos ordenados por média
obterRankingTopN :: Int -> [AlunoResumoDashboard] -> [AlunoResumoDashboard]
obterRankingTopN n resumos =
    take n $ sortBy (comparing (Down . media)) resumos

-- Lista de estudantes em situação crítica (Prova Final ou Reprovados)
obterEstudantesCriticos :: [AlunoResumoDashboard] -> [AlunoResumoDashboard]
obterEstudantesCriticos resumos =
    filter (\r -> situacao r /= Aprovado) resumos
