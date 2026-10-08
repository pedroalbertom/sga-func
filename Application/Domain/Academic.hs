module Application.Domain.Academic where

import IHP.Prelude
import Generated.Types
import qualified Data.Map.Strict as Map
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

-- ============================================================================
-- 1. TIPOS ALGÉBRICOS (ADTs)
-- ============================================================================

-- Tipo algébrico para representar a situação acadêmica
data Situacao
    = Aprovado
    | ProvaFinal
    | ReprovadoPorNota
    | ReprovadoPorFalta
    deriving (Eq, Show)

-- Conceito acadêmico (de A até F)
data Conceito = A | B | C | D | F deriving (Eq, Show, Ord)


-- ============================================================================
-- 2. CURRYING E CLOSURES
-- ============================================================================

-- Função com currying: primeiro recebe a lista de pesos, depois a de notas
mediaPonderada :: [Double] -> [Double] -> Double
mediaPonderada pesos notas
    | null pesos || null notas || length pesos /= length notas = 0.0
    | sum pesos == 0 = 0.0
    | otherwise = sum (zipWith (*) pesos notas) / sum pesos

-- Closure: criamos uma função fixando os pesos padrão da cadeira (2, 3 e 5)
mediaSemestre :: [Double] -> Double
mediaSemestre = mediaPonderada [2.0, 3.0, 5.0]

-- Média aritmética simples
mediaSimples :: [Double] -> Double
mediaSimples [] = 0.0
mediaSimples xs = sum xs / fromIntegral (length xs)


-- ============================================================================
-- 3. PATTERN MATCHING & GUARDS
-- ============================================================================

-- Avalia a situação do aluno com base na média e frequência (guards)
situacaoAluno :: Double -> Double -> Situacao
situacaoAluno media presenca
    | presenca < 75.0 = ReprovadoPorFalta
    | media >= 7.0    = Aprovado
    | media >= 4.0    = ProvaFinal
    | otherwise       = ReprovadoPorNota

-- Converte média numérica em conceito
conceitoAluno :: Double -> Conceito
conceitoAluno m
    | m >= 9.0  = A
    | m >= 8.0  = B
    | m >= 7.0  = C
    | m >= 5.0  = D
    | otherwise = F

-- Converte o tipo algébrico Situacao em texto legível
formataSituacao :: Situacao -> Text
formataSituacao Aprovado          = "Aprovado"
formataSituacao ProvaFinal        = "Prova Final"
formataSituacao ReprovadoPorNota  = "Reprovado por Nota"
formataSituacao ReprovadoPorFalta = "Reprovado por Falta"


-- ============================================================================
-- 4. LIST COMPREHENSIONS
-- ============================================================================

-- Filtra os nomes dos alunos que foram aprovados diretamente
nomesAprovados :: [(Text, Double, Double)] -> [Text]
nomesAprovados alunos =
    [ nome
    | (nome, media, presenca) <- alunos
    , media >= 7.0
    , presenca >= 75.0
    ]

-- Filtra os alunos que estão em situação de risco (final ou reprovados)
alunosEmRisco :: [(Text, Double, Double)] -> [(Text, Situacao)]
alunosEmRisco alunos =
    [ (nome, sit)
    | (nome, media, presenca) <- alunos
    , let sit = situacaoAluno media presenca
    , sit /= Aprovado
    ]


-- ============================================================================
-- 5. FUNÇÕES DE RELATÓRIO DO GUIA (Map, Foldr e Composição)
--    Conforme especificado na pág. 5 do PDF da disciplina
-- ============================================================================

-- Calcula a média de notas por aluno agrupando com foldr e transformando com map
calcularDesempenho :: [Nota] -> [(Id Aluno, Double)]
calcularDesempenho notas =
    map (\(alunoId, ns) -> (alunoId, media ns))
    $ Map.toList
    $ foldr (\n acc -> Map.insertWith (++) (get #alunoId n) [get #valor n] acc) Map.empty notas
  where
    media xs = if null xs then 0.0 else sum xs / fromIntegral (length xs)

-- Calcula a porcentagem de presença por aluno na turma
calcularFrequencia :: [Frequencia] -> [(Id Aluno, Double)]
calcularFrequencia freqs =
    map (\(alunoId, fs) -> (alunoId, percentual fs))
    $ Map.toList
    $ foldr (\f acc -> Map.insertWith (++) (get #alunoId f) [get #presente f] acc) Map.empty freqs
  where
    percentual fs = if null fs then 0.0 else (fromIntegral (length (filter (== True) fs)) / fromIntegral (length fs)) * 100.0

-- Gera o ranking geral ordenado por média decrescente usando composição (.)
calcularRanking :: [Nota] -> [(Id Aluno, Double)]
calcularRanking = sortBy (comparing (Down . snd)) . calcularDesempenho

-- Utilitário simples para arredondar valores a 2 casas decimais
arredondar :: Double -> Double
arredondar val = fromIntegral (round (val * 100) :: Integer) / 100.0
