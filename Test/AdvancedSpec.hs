module Test.AdvancedSpec where

import Test.Hspec
import IHP.Prelude
import Application.Domain.Advanced
import Application.Domain.Academic (Situacao(..))

spec :: Spec
spec = describe "Sprint 3: Tópicos Avançados (Monads, Functors, CPS, Lazy Evaluation)" do

    describe "1. Monad Reader (Configuração Injetada)" do
        it "avalia situação do estudante consultando as réguas da configuração" do
            let resultadoPadrao = runReader (avaliarAlunoReader 8.0 80.0) configPadrao
            resultadoPadrao `shouldBe` Aprovado

            let configRigida = configPadrao { mediaMinimaAprovacao = 9.0 }
            let resultadoRigido = runReader (avaliarAlunoReader 8.0 80.0) configRigida
            resultadoRigido `shouldBe` ProvaFinal

        it "reprova por falta quando frequência é inferior à régua do Reader" do
            let resultado = runReader (avaliarAlunoReader 10.0 70.0) configPadrao
            resultado `shouldBe` ReprovadoPorFalta

        it "calcula média ponderada a partir dos pesos obtidos via asks" do
            let media = runReader (calcularMediaReader [8.0, 7.0, 9.0]) configPadrao
            media `shouldBe` 8.2

    describe "2. Monad Either (Validações Encadeadas em Pipeline)" do
        it "aprova dados válidos retornando Right com record populado" do
            let resultado = validarInscricaoCompleta "Maria Silva" "20261234" "maria@unifor.br"
            resultado `shouldBe` Right (AlunoInscricao "Maria Silva" "20261234" "maria@unifor.br")

        it "interrompe o pipeline no primeiro erro com Left" do
            let nomeInvalido = validarInscricaoCompleta "M" "20261234" "maria@unifor.br"
            nomeInvalido `shouldBe` Left "O nome deve conter pelo menos 2 caracteres."

            let matInvalida = validarInscricaoCompleta "Maria Silva" "abc" "maria@unifor.br"
            matInvalida `shouldBe` Left "A matrícula deve conter no mínimo 4 dígitos numéricos."

            let emailInvalido = validarInscricaoCompleta "Maria Silva" "20261234" "email_invalido"
            emailInvalido `shouldBe` Left "O e-mail informado é inválido."

    describe "3. Functors Aplicados a Estruturas" do
        it "aplica fmap sobre o tipo ItemRelatorio preservando o rótulo" do
            let item = ItemRelatorio "Nota P1" (8.543 :: Double)
            let itemArredondado = fmap (\x -> fromIntegral (round (x * 10) :: Integer) / 10.0) item
            itemArredondado `shouldBe` ItemRelatorio "Nota P1" 8.5

        it "aplica fmap (<$>) para transformar lista de valores" do
            let notas = [10.0, 5.0, 3.0]
            let conceitos = converterNotasParaConceitos (\n -> if n >= 7.0 then "AP" else "RP") notas
            conceitos `shouldBe` ["AP", "RP", "RP"]

    describe "4. Continuation Passing Style (CPS)" do
        it "chama a continuação de sucesso quando os critérios são cumpridos" do
            let msg = realizarMatriculaCPS "Carlos" 5 True (\sucesso -> "OK: " <> sucesso) (\erro -> "ERRO: " <> erro)
            msg `shouldBe` "OK: Matrícula deferida com sucesso para Carlos!"

        it "chama a continuação de erro quando não há vagas" do
            let msg = realizarMatriculaCPS "Carlos" 0 True (\sucesso -> "OK: " <> sucesso) (\erro -> "ERRO: " <> erro)
            msg `shouldBe` "ERRO: Matrícula recusada para Carlos: não há vagas disponíveis."

        it "chama a continuação de erro quando faltam pré-requisitos" do
            let msg = realizarMatriculaCPS "Carlos" 5 False (\sucesso -> "OK: " <> sucesso) (\erro -> "ERRO: " <> erro)
            msg `shouldBe` "ERRO: Matrícula recusada para Carlos: pré-requisitos pendentes."

        it "executa cálculo aritmético em CPS encadeado" do
            let res = somaCPS 10.0 20.0 (\soma -> mediaPonderadaCPS soma 1.0 30.0 1.0 id)
            res `shouldBe` 30.0

    describe "5. Lazy Evaluation (Avaliação Preguiçosa & Streams Infinitos)" do
        it "gera lote finito a partir de lista infinita sob demanda com take" do
            let protocolos = obterLoteProtocolos 3 "MATR"
            protocolos `shouldBe` ["MATR-1000", "MATR-1001", "MATR-1002"]

        it "cria fila virtual indexando infinitamente sob demanda" do
            let fila = filaDeEsperaVirtual ["Alice", "Bob"]
            fila `shouldBe` [(1, "Alice"), (2, "Bob")]

        it "gera projeção infinita de créditos consumindo apenas o necessário" do
            let tresSemestres = take 3 (projecaoCreditos 20 16)
            tresSemestres `shouldBe` [20, 36, 52]
