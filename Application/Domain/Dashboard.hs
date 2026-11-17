module Application.Domain.Dashboard where

import IHP.Prelude
import Generated.Types
import qualified Data.Map.Strict as Map
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))
import Application.Domain.Academic
    ( Situacao(..)
    , arredondar
    , calcularDesempenho
    , calcularFrequencia
    , situacaoAluno
    )

data MetricasGerais = MetricasGerais
    { totalEstudantes        :: Int
    , totalCursosCadastrados :: Int
    , totalTurmasAtivas      :: Int
    , mediaInstitucional     :: Double
    , percentualAprovacao    :: Double
    , quantidadeEmRisco      :: Int
    } deriving (Eq, Show)

data MetricaCurso = MetricaCurso
    { curso         :: Curso
    , qtdEstudantes :: Int
    , mediaNotas    :: Double
    } deriving (Eq, Show)

data AlunoResumoDashboard = AlunoResumoDashboard
    { aluno    :: Aluno
    , media    :: Double
    , presenca :: Double
    , situacao :: Situacao
    } deriving (Eq, Show)

calcularMediasAlunos :: [Nota] -> Map.Map (Id Aluno) Double
calcularMediasAlunos = Map.fromList . calcularDesempenho

calcularPresencasAlunos :: [Frequencia] -> Map.Map (Id Aluno) Double
calcularPresencasAlunos = Map.fromList . calcularFrequencia

gerarResumoAlunos :: [Aluno] -> [Nota] -> [Frequencia] -> [AlunoResumoDashboard]
gerarResumoAlunos alunos notas freqs =
    let mapaMedias    = calcularMediasAlunos notas
        mapaPresencas = calcularPresencasAlunos freqs
    in map (\a ->
        let m = Map.findWithDefault 0.0 (get #id a) mapaMedias
            p = Map.findWithDefault 100.0 (get #id a) mapaPresencas
        in AlunoResumoDashboard
            { aluno = a
            , media = arredondar m
            , presenca = arredondar p
            , situacao = situacaoAluno m p
            }
       ) alunos

calcularMetricasGerais :: [Aluno] -> [Curso] -> [Turma] -> [AlunoResumoDashboard] -> MetricasGerais
calcularMetricasGerais alunos cursos turmas resumos =
    let totEstudantes = length alunos
        mediasValidas = filter (> 0.0) (map media resumos)
        mediaInst = if null mediasValidas then 0.0 else sum mediasValidas / fromIntegral (length mediasValidas)
        aprovados = length (filter (\r -> situacao r == Aprovado) resumos)
        percAp = if totEstudantes == 0 then 0.0 else (fromIntegral aprovados / fromIntegral totEstudantes) * 100.0
        emRisco = length (filter (\r -> situacao r /= Aprovado) resumos)
    in MetricasGerais
        { totalEstudantes        = totEstudantes
        , totalCursosCadastrados = length cursos
        , totalTurmasAtivas      = length turmas
        , mediaInstitucional     = arredondar mediaInst
        , percentualAprovacao    = arredondar percAp
        , quantidadeEmRisco      = emRisco
        }

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

obterRankingTopN :: Int -> [AlunoResumoDashboard] -> [AlunoResumoDashboard]
obterRankingTopN n = take n . sortBy (comparing (Down . media))

obterEstudantesCriticos :: [AlunoResumoDashboard] -> [AlunoResumoDashboard]
obterEstudantesCriticos = filter (\r -> situacao r /= Aprovado)
