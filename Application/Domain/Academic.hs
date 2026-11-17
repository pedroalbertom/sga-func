module Application.Domain.Academic where

import IHP.Prelude
import Generated.Types
import qualified Data.Map.Strict as Map
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

data Situacao
    = Aprovado
    | ProvaFinal
    | ReprovadoPorNota
    | ReprovadoPorFalta
    deriving (Eq, Show)

data Conceito = A | B | C | D | F deriving (Eq, Show, Ord)

mediaPonderada :: [Double] -> [Double] -> Double
mediaPonderada pesos notas
    | null pesos || null notas || length pesos /= length notas = 0.0
    | sum pesos == 0 = 0.0
    | otherwise = sum (zipWith (*) pesos notas) / sum pesos

mediaSemestre :: [Double] -> Double
mediaSemestre = mediaPonderada [2.0, 3.0, 5.0]

mediaSimples :: [Double] -> Double
mediaSimples [] = 0.0
mediaSimples xs = sum xs / fromIntegral (length xs)

situacaoAluno :: Double -> Double -> Situacao
situacaoAluno media presenca
    | presenca < 75.0 = ReprovadoPorFalta
    | media >= 7.0    = Aprovado
    | media >= 4.0    = ProvaFinal
    | otherwise       = ReprovadoPorNota

conceitoAluno :: Double -> Conceito
conceitoAluno m
    | m >= 9.0  = A
    | m >= 8.0  = B
    | m >= 7.0  = C
    | m >= 5.0  = D
    | otherwise = F

formataSituacao :: Situacao -> Text
formataSituacao Aprovado          = "Aprovado"
formataSituacao ProvaFinal        = "Prova Final"
formataSituacao ReprovadoPorNota  = "Reprovado por Nota"
formataSituacao ReprovadoPorFalta = "Reprovado por Falta"

nomesAprovados :: [(Text, Double, Double)] -> [Text]
nomesAprovados alunos =
    [ nome
    | (nome, media, presenca) <- alunos
    , media >= 7.0
    , presenca >= 75.0
    ]

alunosEmRisco :: [(Text, Double, Double)] -> [(Text, Situacao)]
alunosEmRisco alunos =
    [ (nome, sit)
    | (nome, media, presenca) <- alunos
    , let sit = situacaoAluno media presenca
    , sit /= Aprovado
    ]

calcularDesempenho :: [Nota] -> [(Id Aluno, Double)]
calcularDesempenho notas =
    map (\(alunoId, ns) -> (alunoId, media ns))
    $ Map.toList
    $ foldr (\n acc -> Map.insertWith (++) (get #alunoId n) [get #valor n] acc) Map.empty notas
  where
    media xs = if null xs then 0.0 else sum xs / fromIntegral (length xs)

calcularFrequencia :: [Frequencia] -> [(Id Aluno, Double)]
calcularFrequencia freqs =
    map (\(alunoId, fs) -> (alunoId, percentual fs))
    $ Map.toList
    $ foldr (\f acc -> Map.insertWith (++) (get #alunoId f) [get #presente f] acc) Map.empty freqs
  where
    percentual fs = if null fs then 0.0 else (fromIntegral (length (filter id fs)) / fromIntegral (length fs)) * 100.0

calcularRanking :: [Nota] -> [(Id Aluno, Double)]
calcularRanking = sortBy (comparing (Down . snd)) . calcularDesempenho

arredondar :: Double -> Double
arredondar val = fromIntegral (round (val * 100) :: Integer) / 100.0
