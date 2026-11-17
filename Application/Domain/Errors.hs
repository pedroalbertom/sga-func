module Application.Domain.Errors where

import IHP.Prelude
import qualified Application.Domain.Security as Security

data AppError
    = ValidationError Text
    | NotFoundError Text
    | AuthorizationError Text
    | CryptoError Text
    | EmptyDataError Text
    deriving (Eq, Show)

formatAppError :: AppError -> Text
formatAppError (ValidationError msg)    = "Erro de validação: " <> msg
formatAppError (NotFoundError msg)      = "Recurso não encontrado: " <> msg
formatAppError (AuthorizationError msg) = "Acesso negado: " <> msg
formatAppError (CryptoError msg)        = "Falha criptográfica: " <> msg
formatAppError (EmptyDataError msg)     = "Dados insuficientes: " <> msg

note :: e -> Maybe a -> Either e a
note err Nothing  = Left err
note _   (Just x) = Right x

mapError :: (e1 -> e2) -> Either e1 a -> Either e2 a
mapError f (Left e)  = Left (f e)
mapError _ (Right x) = Right x

recoverWith :: a -> Either AppError a -> a
recoverWith fallback (Left _)  = fallback
recoverWith _        (Right x) = x

withFallback :: Either AppError a -> Either AppError a -> Either AppError a
withFallback (Right x) _ = Right x
withFallback (Left _)  y = y

buscarRegistroSeguro :: Text -> Maybe a -> Either AppError a
buscarRegistroSeguro nomeRecurso = note (NotFoundError (nomeRecurso <> " não existe."))

calcularMediaSegura :: [Double] -> Either AppError Double
calcularMediaSegura [] = Left (EmptyDataError "Nenhuma nota informada para cálculo de média.")
calcularMediaSegura notas = do
    _ <- traverse validarNota notas
    pure (sum notas / fromIntegral (length notas))
  where
    validarNota n
        | n < 0.0 || n > 10.0 = Left (ValidationError ("Nota fora do intervalo [0, 10]: " <> tshow n))
        | otherwise           = Right n

mediaComFallback :: Double -> [Double] -> Double
mediaComFallback padrao = recoverWith padrao . calcularMediaSegura

decifrarComRecuperacao :: Text -> Text -> Either AppError Text
decifrarComRecuperacao chave hexTexto =
    mapError CryptoError (Security.descriptografarTexto chave hexTexto)

decifrarOuFallback :: Text -> Text -> Text -> Text
decifrarOuFallback fallback chave hexTexto =
    recoverWith fallback (decifrarComRecuperacao chave hexTexto)
