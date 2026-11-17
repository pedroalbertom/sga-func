module Test.ErrorsSpec where

import Test.Hspec
import IHP.Prelude
import Application.Domain.Errors
import qualified Application.Domain.Security as Security

spec :: Spec
spec = describe "Sprint 5: Tratamento de Erros Monádico e Recuperação" do

    describe "ADT AppError e Formatação" do
        it "formata cada construtor de erro de forma legível" do
            formatAppError (ValidationError "nota inválida") `shouldBe` "Erro de validação: nota inválida"
            formatAppError (NotFoundError "Turma") `shouldBe` "Recurso não encontrado: Turma"
            formatAppError (AuthorizationError "sem permissão") `shouldBe` "Acesso negado: sem permissão"
            formatAppError (CryptoError "hex inválido") `shouldBe` "Falha criptográfica: hex inválido"
            formatAppError (EmptyDataError "sem notas") `shouldBe` "Dados insuficientes: sem notas"

    describe "Combinadores de Recuperação (note, recoverWith, withFallback)" do
        it "converte Nothing em Left e Just em Right com note" do
            note (NotFoundError "Aluno") (Nothing :: Maybe Int) `shouldBe` Left (NotFoundError "Aluno")
            note (NotFoundError "Aluno") (Just (42 :: Int)) `shouldBe` Right 42

        it "recupera valor padrão via recoverWith diante de falhas" do
            recoverWith 0.0 (Left (EmptyDataError "vazio")) `shouldBe` (0.0 :: Double)
            recoverWith 0.0 (Right 8.5) `shouldBe` (8.5 :: Double)

        it "seleciona computação alternativa via withFallback" do
            let primaria = Left (NotFoundError "cache")
            let alternativa = Right ("dado-banco" :: Text)
            withFallback primaria alternativa `shouldBe` Right "dado-banco"
            withFallback (Right "cache-ok") alternativa `shouldBe` Right "cache-ok"

    describe "Pipelines Seguros com Recuperação" do
        it "rejeita lista vazia e notas fora de [0, 10] em calcularMediaSegura" do
            calcularMediaSegura [] `shouldBe` Left (EmptyDataError "Nenhuma nota informada para cálculo de média.")
            calcularMediaSegura [8.0, 11.0] `shouldBe` Left (ValidationError "Nota fora do intervalo [0, 10]: 11.0")
            calcularMediaSegura [-1.0, 7.0] `shouldBe` Left (ValidationError "Nota fora do intervalo [0, 10]: -1.0")
            calcularMediaSegura [7.0, 9.0] `shouldBe` Right 8.0

        it "aplica fallback automático em mediaComFallback" do
            mediaComFallback 0.0 [] `shouldBe` 0.0
            mediaComFallback 0.0 [15.0] `shouldBe` 0.0
            mediaComFallback 0.0 [6.0, 8.0] `shouldBe` 7.0

        it "mapeia falhas criptográficas para CryptoError e recupera texto seguro" do
            let cifrado = Security.criptografarTexto Security.chaveMestraPadrao "123.456.789-00"
            decifrarComRecuperacao Security.chaveMestraPadrao cifrado `shouldBe` Right "123.456.789-00"
            decifrarComRecuperacao Security.chaveMestraPadrao "ZZZ" `shouldBe` Left (CryptoError "Formato hexadecimal inválido para descriptografia.")
            decifrarOuFallback "***" Security.chaveMestraPadrao "ZZZ" `shouldBe` "***"
