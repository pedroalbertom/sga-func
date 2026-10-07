module Application.Domain.Academic where

import IHP.Prelude
import qualified Data.Map.Strict as Map
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

{- |
================================================================================
MÓDULO DE DOMÍNIO PURO: REGRAS ACADÊMICAS (SGA-Func)
================================================================================
Este módulo reúne as funções de domínio da disciplina de Programação Funcional.
Ele não possui efeitos colaterais (funções puras), operando exclusivamente sobre
dados imutáveis através de:
  1. Tipos Algébricos de Dados (ADTs) & Records
  2. Currying & Closures (calculadoras parametrizadas por pesos)
  3. Pattern Matching & Guards (classificação de situação e conceito)
  4. List Comprehensions (filtros e projeções declarativas)
  5. Agregação funcional com Map, Foldr e Composição (.)
================================================================================
-}

--------------------------------------------------------------------------------
-- 1. TIPOS ALGÉBRICOS DE DADOS (ADTs) & RECORDS
--------------------------------------------------------------------------------

-- | ADT que modela a situação acadêmica final do aluno.
data SituacaoAcademica
    = Aprovado
    | ProvaFinal Double      -- ^ Nota mínima necessária na prova final
    | ReprovadoPorNota
    | ReprovadoPorFalta
    deriving (Eq, Show)

-- | ADT que representa a menção / conceito acadêmico.
data Conceito
    = ConceitoA   -- ^ [9.0, 10.0]
    | ConceitoB   -- ^ [8.0, 9.0)
    | ConceitoC   -- ^ [7.0, 8.0)
    | ConceitoD   -- ^ [5.0, 7.0)
    | ConceitoF   -- ^ [0.0, 5.0)
    deriving (Eq, Show, Ord)

-- | Record que descreve o peso de uma avaliação específica.
data PesoAvaliacao = PesoAvaliacao
    { nomeAvaliacao :: Text
    , peso          :: Double
    } deriving (Eq, Show)

-- | Record puro que agrega os dados de desempenho de um aluno.
data AlunoDesempenho = AlunoDesempenho
    { alunoId            :: UUID
    , alunoNome          :: Text
    , mediaNotas         :: Double
    , percentualPresenca :: Double
    , conceito           :: Conceito
    , situacao           :: SituacaoAcademica
    } deriving (Eq, Show)


--------------------------------------------------------------------------------
-- 2. CLOSURES E CURRYING
--------------------------------------------------------------------------------

-- | Função curried de alta ordem que calcula média ponderada.
--   Recebe uma lista de pesos, uma lista de notas e retorna 'Just media' ou 'Nothing'.
--   Exemplo de currying:
--     calculadora = calcularMediaPonderada [2.0, 3.0, 5.0]
--     media = calculadora [8.0, 7.0, 9.0]
calcularMediaPonderada :: [Double] -> [Double] -> Maybe Double
calcularMediaPonderada pesos notas
    | null pesos || null notas     = Nothing
    | length pesos /= length notas = Nothing
    | somaPesos == 0               = Nothing
    | otherwise                    = Just (somaPonderada / somaPesos)
  where
    somaPonderada = sum (zipWith (*) pesos notas)
    somaPesos     = sum pesos

-- | Closure pré-configurada com os pesos padrão da universidade (AV1: 2, AV2: 3, Trab: 5).
--   Aplica Currying fixando o primeiro argumento de 'calcularMediaPonderada'.
calculadoraMediaSemestral :: [Double] -> Maybe Double
calculadoraMediaSemestral = calcularMediaPonderada [2.0, 3.0, 5.0]

-- | Função curried que cria uma calculadora especializada para qualquer conjunto de pesos.
criarCalculadoraPesos :: [Double] -> ([Double] -> Maybe Double)
criarCalculadoraPesos = calcularMediaPonderada

-- | Média aritmética simples de uma lista de notas.
calcularMediaSimples :: [Double] -> Maybe Double
calcularMediaSimples [] = Nothing
calcularMediaSimples xs = Just (sum xs / fromIntegral (length xs))


--------------------------------------------------------------------------------
-- 3. PATTERN MATCHING & GUARDS
--------------------------------------------------------------------------------

-- | Avalia a situação acadêmica a partir da média final e do percentual de presença.
--   Utiliza Guards com avaliação estrita de regras institucionais.
avaliarSituacao :: Double -> Double -> SituacaoAcademica
avaliarSituacao media percentualPresenca
    | percentualPresenca < 75.0 = ReprovadoPorFalta
    | media >= 7.0              = Aprovado
    | media >= 4.0              = ProvaFinal notaNecessariaFinal
    | otherwise                 = ReprovadoPorNota
  where
    -- Fórmula padrão: (Média * 6 + Final * 4) / 10 >= 5.0  ==>  Final >= (50 - Média * 6) / 4
    notaNecessariaFinal = max 0.0 ((50.0 - media * 6.0) / 4.0)

-- | Converte a média numérica em um Conceito acadêmico (A, B, C, D, F).
classificarConceito :: Double -> Conceito
classificarConceito m
    | m >= 9.0  = ConceitoA
    | m >= 8.0  = ConceitoB
    | m >= 7.0  = ConceitoC
    | m >= 5.0  = ConceitoD
    | otherwise = ConceitoF

-- | Converte o ADT de 'SituacaoAcademica' em texto amigável via Pattern Matching exaustivo.
formatarSituacao :: SituacaoAcademica -> Text
formatarSituacao Aprovado           = "Aprovado por Média"
formatarSituacao (ProvaFinal final) = "Prova Final (Precisa de " <> tshow (roundDuasCasas final) <> ")"
formatarSituacao ReprovadoPorNota   = "Reprovado por Nota"
formatarSituacao ReprovadoPorFalta  = "Reprovado por Frequência"

-- | Formata o ADT de Conceito em texto legível.
formatarConceito :: Conceito -> Text
formatarConceito ConceitoA = "A (Excelente)"
formatarConceito ConceitoB = "B (Bom)"
formatarConceito ConceitoC = "C (Regular)"
formatarConceito ConceitoD = "D (Suficiente)"
formatarConceito ConceitoF = "F (Insuficiente)"


--------------------------------------------------------------------------------
-- 4. LIST COMPREHENSIONS
--------------------------------------------------------------------------------

-- | Filtra alunos aprovados utilizando List Comprehension.
--   Demonstra sintaxe declarativa com múltiplos geradores e predicados.
obterNomesAprovados :: [(Text, Double, Double)] -> [Text]
obterNomesAprovados alunos =
    [ nome
    | (nome, media, presenca) <- alunos
    , media >= 7.0
    , presenca >= 75.0
    ]

-- | Identifica alunos em situação de risco (reprovação iminente ou prova final)
--   utilizando List Comprehensions com casamento de padrão no resultado.
obterAlunosEmRisco :: [(Text, Double, Double)] -> [(Text, SituacaoAcademica)]
obterAlunosEmRisco alunos =
    [ (nome, situacao)
    | (nome, media, presenca) <- alunos
    , let situacao = avaliarSituacao media presenca
    , situacao /= Aprovado
    ]


--------------------------------------------------------------------------------
-- 5. FUNÇÕES PURAS DE AGREGAÇÃO (MAP, FOLDR, COMPOSIÇÃO)
--    Implementação fiel às especificações do guia (pág. 5 do PDF)
--------------------------------------------------------------------------------

-- | Agrupa notas por chave (alunoId) e calcula a média aritmética para cada um.
--   Utiliza 'foldr' com 'Map.insertWith (++)' e 'map' sobre a lista associativa.
agruparECalcularMedias :: Ord k => [(k, Double)] -> [(k, Double)]
agruparECalcularMedias entradas =
    map (\(k, vals) -> (k, media vals))
    $ Map.toList
    $ foldr (\(k, val) acc -> Map.insertWith (++) k [val] acc) Map.empty entradas
  where
    media xs = if null xs then 0.0 else sum xs / fromIntegral (length xs)

-- | Agrupa presenças por chave (alunoId) e calcula o percentual de frequência.
--   Conforme guia da disciplina:
--     percentual = (length (filter id fs) / length fs) * 100
agruparECalcularFrequencias :: Ord k => [(k, Bool)] -> [(k, Double)]
agruparECalcularFrequencias registros =
    map (\(k, presencas) -> (k, percentual presencas))
    $ Map.toList
    $ foldr (\(k, p) acc -> Map.insertWith (++) k [p] acc) Map.empty registros
  where
    percentual fs
        | null fs   = 0.0
        | otherwise = (fromIntegral (length (filter id fs)) / fromIntegral (length fs)) * 100.0

-- | Ordena a lista de médias em ordem decrescente (Ranking).
--   Utiliza composição de funções '.' com 'sortBy' e 'comparing (Down . snd)'.
ordenarRanking :: Ord v => [(k, v)] -> [(k, v)]
ordenarRanking = sortBy (comparing (Down . snd))


--------------------------------------------------------------------------------
-- 6. UTILITÁRIOS PUROS
--------------------------------------------------------------------------------

-- | Arredonda um Double para duas casas decimais puramente.
roundDuasCasas :: Double -> Double
roundDuasCasas val = fromIntegral (round (val * 100) :: Integer) / 100.0
