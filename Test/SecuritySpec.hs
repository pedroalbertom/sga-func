module Test.SecuritySpec where

import Test.Hspec
import IHP.Prelude
import Application.Domain.Security

spec :: Spec
spec = describe "Sprint 3: Segurança e Criptografia" do

    describe "Criptografia Simétrica de Campos Sensíveis" do
        it "cifra e decifra texto recuperando exatamente o conteúdo original" do
            let textoOriginal = "123.456.789-00"
            let cifrado = criptografarTexto chaveMestraPadrao textoOriginal
            cifrado `shouldNotBe` textoOriginal

            let decifrado = descriptografarTexto chaveMestraPadrao cifrado
            decifrado `shouldBe` Right textoOriginal

        it "produz ciphertexts diferentes para chaves diferentes" do
            let texto = "CONFIDENCIAL-2026"
            let cifrado1 = criptografarTexto "CHAVE-A" texto
            let cifrado2 = criptografarTexto "CHAVE-B" texto
            cifrado1 `shouldNotBe` cifrado2

        it "falha ao tentar decifrar com chave incorreta" do
            let texto = "DOCUMENTO-SECRETO"
            let cifrado = criptografarTexto "CHAVE-CORRETA" texto
            let decifradoComErro = descriptografarTexto "CHAVE-ERRADA" cifrado
            decifradoComErro `shouldNotBe` Right texto

        it "retorna erro explicativo para formato hexadecimal corrompido" do
            descriptografarTexto chaveMestraPadrao "XYZ123" `shouldBe` Left "Formato hexadecimal inválido para descriptografia."
            descriptografarTexto chaveMestraPadrao "123" `shouldBe` Left "Comprimento ímpar de hexadecimal inválido."

    describe "Mascaramento de Documentos" do
        it "preserva os últimos 4 caracteres e oculta os demais com asteriscos" do
            mascararDocumento "123.456.789-00" `shouldBe` "**********9-00"
            mascararDocumento "202612345" `shouldBe` "*****2345"

        it "mascara totalmente valores muito curtos" do
            mascararDocumento "12" `shouldBe` "***"

    describe "Auditoria de Hash de Senhas" do
        it "reconhece hashes válidos gerados pelo padrão IHP PBKDF2/SHA256" do
            let hashValido = "sha256|17|VCENkp2Hnqc/JH0/etD+mg==|I2xvPEgMIFQjLOL6zyw0Hvtn0MHhF0RSNjh6vJkS5rU="
            formatoHashValido hashValido `shouldBe` True

        it "rejeita senhas em texto puro ou hashes malformados" do
            formatoHashValido "senha123" `shouldBe` False
            formatoHashValido "md5|invalido" `shouldBe` False
