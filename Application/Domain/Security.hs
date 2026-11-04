module Application.Domain.Security where

import IHP.Prelude
import qualified Data.Text as Text
import qualified Data.Char as Char
import Numeric (showHex, readHex)
import Data.Bits (xor)

-- ============================================================================
-- 1. CRIPTOGRAFIA SIMÉTRICA PURA (Keystream Cipher com Hexadecimal)
-- ============================================================================

-- Chave mestra padrão da aplicação para cifrar campos confidenciais
chaveMestraPadrao :: Text
chaveMestraPadrao = "SGA-FUNC-SECRET-KEY-2026-UNIFOR-FP"

-- Gera um keystream infinito baseado na chave
fluxoChave :: Text -> [Int]
fluxoChave chave
    | Text.null chave = cycle [42, 137, 73, 255]
    | otherwise       = cycle (map Char.ord (Text.unpack chave))

-- Criptografa um texto claro puro para representação Hexadecimal
criptografarTexto :: Text -> Text -> Text
criptografarTexto chave textoClaro =
    let stream = fluxoChave chave
        bytesOriginais = map Char.ord (Text.unpack textoClaro)
        bytesCifrados = zipWith xor bytesOriginais stream
        hexChars = concatMap (\b -> pad2 (showHex b "")) bytesCifrados
    in Text.pack hexChars
  where
    pad2 [c] = ['0', c]
    pad2 cs  = cs

-- Descriptografa um texto em formato Hexadecimal de volta para o texto original
descriptografarTexto :: Text -> Text -> Either Text Text
descriptografarTexto chave textoHex = do
    bytesCifrados <- converterHexParaBytes (Text.unpack (Text.strip textoHex))
    let stream = fluxoChave chave
        bytesOriginais = zipWith xor bytesCifrados stream
    pure (Text.pack (map Char.chr bytesOriginais))
  where
    converterHexParaBytes :: String -> Either Text [Int]
    converterHexParaBytes [] = Right []
    converterHexParaBytes (c1:c2:resto) =
        case readHex [c1, c2] of
            [(val, "")] -> (val :) <$> converterHexParaBytes resto
            _           -> Left "Formato hexadecimal inválido para descriptografia."
    converterHexParaBytes _ = Left "Comprimento ímpar de hexadecimal inválido."


-- ============================================================================
-- 2. MASCARAMENTO DE DADOS SENSÍVEIS (Para perfis de consulta / não-admin)
-- ============================================================================

-- Mascara documentos (ex.: CPF, RG) para exibição segura
mascararDocumento :: Text -> Text
mascararDocumento doc
    | Text.length limpo <= 4 = "***"
    | otherwise =
        let visivel = Text.takeEnd 4 limpo
            oculto  = Text.replicate (Text.length limpo - 4) "*"
        in oculto <> visivel
  where
    limpo = Text.strip doc


-- ============================================================================
-- 3. VERIFICAÇÃO E AUDITORIA DE HASH DE SENHA
-- ============================================================================

-- Avalia se o hash armazenado segue o padrão seguro do IHP (sha256|iter|salt|hash)
formatoHashValido :: Text -> Bool
formatoHashValido hash =
    case Text.splitOn "|" hash of
        ["sha256", iter, salt, digest] ->
            not (Text.null iter) && not (Text.null salt) && not (Text.null digest)
        _ -> False
