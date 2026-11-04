module Application.Domain.Advanced where

import IHP.Prelude
import qualified Data.Text as Text
import Application.Domain.Academic (Situacao(..))

-- ============================================================================
-- 1. MONAD READER (Configurações e Parâmetros Injetados Puros)
-- ============================================================================

-- Configuração acadêmica injetada via Reader
data AcademicConfig = AcademicConfig
    { mediaMinimaAprovacao :: Double
    , frequenciaMinima     :: Double
    , pesosPadrao          :: [Double]
    } deriving (Eq, Show)

-- Configuração padrão do sistema UNIFOR / SGA
configPadrao :: AcademicConfig
configPadrao = AcademicConfig
    { mediaMinimaAprovacao = 7.0
    , frequenciaMinima     = 75.0
    , pesosPadrao          = [2.0, 3.0, 5.0]
    }

-- Implementação canônica do Monad Reader a partir dos primeiros princípios
newtype Reader r a = Reader { runReader :: r -> a }

instance Functor (Reader r) where
    fmap f (Reader g) = Reader (\r -> f (g r))

instance Applicative (Reader r) where
    pure x = Reader (\_ -> x)
    (Reader f) <*> (Reader g) = Reader (\r -> f r (g r))

instance Monad (Reader r) where
    return = pure
    (Reader g) >>= f = Reader (\r -> runReader (f (g r)) r)

-- Utilitários do Reader
ask :: Reader r r
ask = Reader id

asks :: (r -> a) -> Reader r a
asks f = Reader f

-- Avalia a situação do estudante lendo as réguas do ambiente
avaliarAlunoReader :: Double -> Double -> Reader AcademicConfig Situacao
avaliarAlunoReader media presenca = do
    cfg <- ask
    pure $ if
        | presenca < frequenciaMinima cfg -> ReprovadoPorFalta
        | media >= mediaMinimaAprovacao cfg -> Aprovado
        | media >= 4.0 -> ProvaFinal
        | otherwise -> ReprovadoPorNota

-- Calcula média ponderada usando os pesos fornecidos na configuração
calcularMediaReader :: [Double] -> Reader AcademicConfig Double
calcularMediaReader notas = do
    pesos <- asks pesosPadrao
    pure $ if null pesos || null notas || length pesos /= length notas || sum pesos == 0
        then 0.0
        else sum (zipWith (*) pesos notas) / sum pesos


-- ============================================================================
-- 2. MONAD EITHER (Railway-Oriented Programming & Validações Encadeadas)
-- ============================================================================

data AlunoInscricao = AlunoInscricao
    { nomeAluno      :: Text
    , matriculaAluno :: Text
    , emailAluno     :: Text
    } deriving (Eq, Show)

validarNomeEither :: Text -> Either Text Text
validarNomeEither n
    | Text.length (Text.strip n) >= 2 = Right (Text.strip n)
    | otherwise = Left "O nome deve conter pelo menos 2 caracteres."

validarMatriculaEither :: Text -> Either Text Text
validarMatriculaEither m
    | Text.length m >= 4 && Text.all (`elem` ['0'..'9']) m = Right m
    | otherwise = Left "A matrícula deve conter no mínimo 4 dígitos numéricos."

validarEmailEither :: Text -> Either Text Text
validarEmailEither e
    | Text.isInfixOf "@" e && Text.isInfixOf "." e && not (Text.isInfixOf " " e) = Right (Text.toLower (Text.strip e))
    | otherwise = Left "O e-mail informado é inválido."

-- Pipeline de validação combinando ações com a notação monádica (>>=)
validarInscricaoCompleta :: Text -> Text -> Text -> Either Text AlunoInscricao
validarInscricaoCompleta n m e = do
    nomeValido <- validarNomeEither n
    matValida  <- validarMatriculaEither m
    emailVal   <- validarEmailEither e
    pure AlunoInscricao
        { nomeAluno      = nomeValido
        , matriculaAluno = matValida
        , emailAluno     = emailVal
        }


-- ============================================================================
-- 3. FUNCTORS APLICADOS A COLEÇÕES E TIPOS CUSTOMIZADOS
-- ============================================================================

-- Tipo customizado para relatórios que implementa Functor
data ItemRelatorio a = ItemRelatorio
    { rotulo :: Text
    , valor  :: a
    } deriving (Eq, Show)

instance Functor ItemRelatorio where
    fmap f (ItemRelatorio r v) = ItemRelatorio r (f v)

-- Aplicação de fmap sobre coleção de itens de relatório
normalizarNotasRelatorio :: [ItemRelatorio Double] -> [ItemRelatorio Double]
normalizarNotasRelatorio = map (fmap (\n -> fromIntegral (round (n * 10) :: Integer) / 10.0))

-- Mapeia lista de notas numéricas para uma lista de conceitos usando Functor (<$>)
converterNotasParaConceitos :: (Double -> Text) -> [Double] -> [Text]
converterNotasParaConceitos func = fmap func


-- ============================================================================
-- 4. CONTINUATION PASSING STYLE (CPS)
-- ============================================================================

-- Pipeline de matrícula em CPS:
-- Em vez de retornar um resultado diretamente, a função recebe duas continuações:
-- uma chamada em caso de sucesso (onSuccess) e outra em caso de falha (onFailure).
realizarMatriculaCPS
    :: Text                 -- Nome do aluno
    -> Int                  -- Vagas restantes na turma
    -> Bool                 -- Pré-requisitos cumpridos
    -> (Text -> r)          -- Continuação de Sucesso
    -> (Text -> r)          -- Continuação de Falha
    -> r
realizarMatriculaCPS aluno vagas prereqOk onSuccess onFailure
    | not prereqOk = onFailure ("Matrícula recusada para " <> aluno <> ": pré-requisitos pendentes.")
    | vagas <= 0   = onFailure ("Matrícula recusada para " <> aluno <> ": não há vagas disponíveis.")
    | otherwise    = onSuccess ("Matrícula deferida com sucesso para " <> aluno <> "!")

-- Exemplo clássico de cálculo em CPS encadeado
somaCPS :: Double -> Double -> (Double -> r) -> r
somaCPS x y k = k (x + y)

mediaPonderadaCPS :: Double -> Double -> Double -> Double -> (Double -> r) -> r
mediaPonderadaCPS n1 p1 n2 p2 k =
    let total = (n1 * p1) + (n2 * p2)
        pesos = p1 + p2
    in k (total / pesos)


-- ============================================================================
-- 5. LAZY EVALUATION (Avaliação Preguiçosa & Listas Infinitas)
-- ============================================================================

-- Gerador infinito de códigos de protocolo acadêmico sob demanda
geradorProtocolos :: Text -> [Text]
geradorProtocolos prefixo =
    [ prefixo <> "-" <> show (n :: Integer) | n <- [1000..] ]

-- Consumo sob demanda demonstrando lazy evaluation (take n nunca avalia o restante)
obterLoteProtocolos :: Int -> Text -> [Text]
obterLoteProtocolos n prefixo = take n (geradorProtocolos prefixo)

-- Fila de espera virtual infinita
filaDeEsperaVirtual :: [Text] -> [(Int, Text)]
filaDeEsperaVirtual alunos = zip [1..] alunos

-- Progressão preguiçosa de créditos acumulados
projecaoCreditos :: Int -> Int -> [Int]
projecaoCreditos creditosIniciais incrementoSemestre =
    iterate (+ incrementoSemestre) creditosIniciais
