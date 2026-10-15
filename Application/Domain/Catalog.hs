module Application.Domain.Catalog where

import IHP.Prelude
import Generated.Types
import IHP.ValidationSupport
import qualified Data.Text as Text
import Data.Char (isAscii, isDigit)

-- Fail closed: unknown roles never acquire permissions.
canRead :: Text -> Bool
canRead role = role `elem` ["admin", "consulta"]

canWrite :: Text -> Bool
canWrite = (== "admin")

validName :: Text -> ValidatorResult
validName value
    | Text.length (Text.strip value) >= 2 && Text.length value <= 150 = Success
    | otherwise = Failure "Informe um nome entre 2 e 150 caracteres."

validMatricula :: Text -> ValidatorResult
validMatricula value
    | Text.length value >= 4 && Text.length value <= 20 && Text.all (\c -> isAscii c && isDigit c) value = Success
    | otherwise = Failure "A matrícula deve conter de 4 a 20 dígitos."

validCode :: Text -> ValidatorResult
validCode value
    | Text.length value >= 2 && Text.length value <= 20
        && Text.all (\c -> (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '-') value
        && maybe False (/= '-') (fst <$> Text.uncons value) = Success
    | otherwise = Failure "Use de 2 a 20 letras maiúsculas, números ou hífen; comece por letra ou número."

validEmail :: Text -> ValidatorResult
validEmail value
    | Text.length value <= 254 && not (Text.any (`elem` [' ', '\t', '\n', '\r']) value) && validParts = Success
    | otherwise = Failure "Informe um e-mail válido com domínio completo."
  where
    validParts = case Text.splitOn "@" value of
        [local, domain] -> not (Text.null local) && length (Text.splitOn "." domain) >= 2
            && all (not . Text.null) (Text.splitOn "." domain)
        _ -> False

buscarAlunos :: Text -> [Aluno] -> [Aluno]
buscarAlunos termo = filter (Text.isInfixOf (Text.toCaseFold (Text.strip termo)) . Text.toCaseFold . campos)
  where
    campos aluno = Text.intercalate " " [get #nome aluno, get #matricula aluno, get #email aluno]

buscarCursos :: Text -> [Curso] -> [Curso]
buscarCursos termo = filter (Text.isInfixOf (Text.toCaseFold (Text.strip termo)) . Text.toCaseFold . campos)
  where
    campos curso = get #nome curso <> " " <> get #codigo curso

-- map projects each course and foldr reduces its students to a total.
resumoCursos :: [Curso] -> [Aluno] -> [(Curso, Int)]
resumoCursos cursos alunos = map (\curso -> (curso, foldr (\_ total -> total + 1) 0 (doCurso curso))) cursos
  where
    doCurso curso = filter (\aluno -> get #cursoId aluno == Just (get #id curso)) alunos

-- concatMap (flatMap) flattens the one-to-many course/student relationship.
estudantesPorCurso :: [Curso] -> [Aluno] -> [(Text, Text)]
estudantesPorCurso cursos alunos = concatMap pares cursos
  where
    pares curso = map (\aluno -> (get #nome curso, get #nome aluno))
        (filter (\aluno -> get #cursoId aluno == Just (get #id curso)) alunos)
