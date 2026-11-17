module Application.Domain.Security where

import IHP.Prelude
import qualified Data.ByteString as BS
import qualified Data.Text as Text
import qualified Data.Text.Encoding as TE
import Data.Bits (xor)
import Data.Word (Word8)
import Numeric (readHex, showHex)

chaveMestraPadrao :: Text
chaveMestraPadrao = "SGA-FUNC-SECRET-KEY-2026-UNIFOR-FP"

fluxoChave :: Text -> [Word8]
fluxoChave chave
    | Text.null chave = cycle [42, 137, 73, 255]
    | otherwise       = cycle (BS.unpack (TE.encodeUtf8 chave))

-- Opera em bytes UTF-8 para garantir 2 dígitos hexadecimais por byte mesmo com acentuação.
criptografarTexto :: Text -> Text -> Text
criptografarTexto chave textoClaro =
    let stream = fluxoChave chave
        bytesOriginais = BS.unpack (TE.encodeUtf8 textoClaro)
        bytesCifrados = zipWith xor bytesOriginais stream
        hexChars = concatMap (\b -> pad2 (showHex b "")) bytesCifrados
    in Text.pack hexChars
  where
    pad2 [c] = ['0', c]
    pad2 cs  = cs

descriptografarTexto :: Text -> Text -> Either Text Text
descriptografarTexto chave textoHex = do
    bytesCifrados <- converterHexParaBytes (Text.unpack (Text.strip textoHex))
    let stream = fluxoChave chave
        bytesOriginais = BS.pack (zipWith xor bytesCifrados stream)
    case TE.decodeUtf8' bytesOriginais of
        Left _    -> Left "Falha ao decodificar UTF-8 após descriptografia."
        Right txt -> Right txt
  where
    converterHexParaBytes :: String -> Either Text [Word8]
    converterHexParaBytes [] = Right []
    converterHexParaBytes (c1:c2:resto) =
        case readHex [c1, c2] of
            [(val, "")] -> (val :) <$> converterHexParaBytes resto
            _           -> Left "Formato hexadecimal inválido para descriptografia."
    converterHexParaBytes _ = Left "Comprimento ímpar de hexadecimal inválido."

mascararDocumento :: Text -> Text
mascararDocumento doc
    | Text.length limpo <= 4 = "***"
    | otherwise =
        let visivel = Text.takeEnd 4 limpo
            oculto  = Text.replicate (Text.length limpo - 4) "*"
        in oculto <> visivel
  where
    limpo = Text.strip doc

formatoHashValido :: Text -> Bool
formatoHashValido hash =
    case Text.splitOn "|" hash of
        ["sha256", iter, salt, digest] ->
            not (Text.null iter) && not (Text.null salt) && not (Text.null digest)
        _ -> False
