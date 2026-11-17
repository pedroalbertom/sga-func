module Application.Domain.Advanced where

import IHP.Prelude
import qualified Data.Text as Text
import Application.Domain.Academic (Situacao(..))

data AcademicConfig = AcademicConfig
    { mediaMinimaAprovacao :: Double
    , frequenciaMinima     :: Double
    , pesosPadrao          :: [Double]
    } deriving (Eq, Show)

configPadrao :: AcademicConfig
configPadrao = AcademicConfig
    { mediaMinimaAprovacao = 7.0
    , frequenciaMinima     = 75.0
    , pesosPadrao          = [2.0, 3.0, 5.0]
    }

newtype Reader r a = Reader { runReader :: r -> a }

instance Functor (Reader r) where
    fmap f (Reader g) = Reader (\r -> f (g r))

instance Applicative (Reader r) where
    pure x = Reader (\_ -> x)
    (Reader f) <*> (Reader g) = Reader (\r -> f r (g r))

instance Monad (Reader r) where
    return = pure
    (Reader g) >>= f = Reader (\r -> runReader (f (g r)) r)

ask :: Reader r r
ask = Reader id

asks :: (r -> a) -> Reader r a
asks = Reader

avaliarAlunoReader :: Double -> Double -> Reader AcademicConfig Situacao
avaliarAlunoReader media presenca = do
    cfg <- ask
    pure $ if
        | presenca < frequenciaMinima cfg -> ReprovadoPorFalta
        | media >= mediaMinimaAprovacao cfg -> Aprovado
        | media >= 4.0 -> ProvaFinal
        | otherwise -> ReprovadoPorNota

calcularMediaReader :: [Double] -> Reader AcademicConfig Double
calcularMediaReader notas = do
    pesos <- asks pesosPadrao
    pure $ if null pesos || null notas || length pesos /= length notas || sum pesos == 0
        then 0.0
        else sum (zipWith (*) pesos notas) / sum pesos

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

data ItemRelatorio a = ItemRelatorio
    { rotulo :: Text
    , valor  :: a
    } deriving (Eq, Show)

instance Functor ItemRelatorio where
    fmap f (ItemRelatorio r v) = ItemRelatorio r (f v)

normalizarNotasRelatorio :: [ItemRelatorio Double] -> [ItemRelatorio Double]
normalizarNotasRelatorio = map (fmap (\n -> fromIntegral (round (n * 10) :: Integer) / 10.0))

converterNotasParaConceitos :: (Double -> Text) -> [Double] -> [Text]
converterNotasParaConceitos = fmap

realizarMatriculaCPS
    :: Text
    -> Int
    -> Bool
    -> (Text -> r)
    -> (Text -> r)
    -> r
realizarMatriculaCPS aluno vagas prereqOk onSuccess onFailure
    | not prereqOk = onFailure ("Matrícula recusada para " <> aluno <> ": pré-requisitos pendentes.")
    | vagas <= 0   = onFailure ("Matrícula recusada para " <> aluno <> ": não há vagas disponíveis.")
    | otherwise    = onSuccess ("Matrícula deferida com sucesso para " <> aluno <> "!")

somaCPS :: Double -> Double -> (Double -> r) -> r
somaCPS x y k = k (x + y)

mediaPonderadaCPS :: Double -> Double -> Double -> Double -> (Double -> r) -> r
mediaPonderadaCPS n1 p1 n2 p2 k =
    k (((n1 * p1) + (n2 * p2)) / (p1 + p2))

geradorProtocolos :: Text -> [Text]
geradorProtocolos prefixo =
    [ prefixo <> "-" <> show (n :: Integer) | n <- [1000..] ]

obterLoteProtocolos :: Int -> Text -> [Text]
obterLoteProtocolos n prefixo = take n (geradorProtocolos prefixo)

filaDeEsperaVirtual :: [Text] -> [(Int, Text)]
filaDeEsperaVirtual = zip [1..]

projecaoCreditos :: Int -> Int -> [Int]
projecaoCreditos creditosIniciais incrementoSemestre =
    iterate (+ incrementoSemestre) creditosIniciais
