#!/usr/bin/env run-script
module Application.Script.StressTest where

import Application.Script.Prelude
import Control.Concurrent (forkIO, newEmptyMVar, putMVar, takeMVar)
import Data.List (sort)
import Data.Time.Clock (NominalDiffTime, diffUTCTime, getCurrentTime)
import qualified Data.UUID as UUID
import qualified Application.Domain.Academic as Academic
import qualified Application.Domain.Dashboard as Dashboard
import qualified Application.Domain.Errors as Errors
import qualified Application.Domain.Security as Security

-- | Executa a bateria de testes de stress do SGA-Func:
-- 1) Processamento em lote no núcleo funcional puro (50.000 notas)
-- 2) Carga concorrente com múltiplas green threads (forkIO)
-- 3) Leituras concorrentes no PostgreSQL via IHP
run :: Script
run = do
    putStrLn "=== SGA-Func :: Teste de Stress (Sprint 5) ==="
    rodarStressDominioPuro
    rodarStressConcorrenteWorkers 16 500
    rodarStressBancoConcorrente 8 25
    putStrLn "=== Fim da bateria de stress ==="

-- | Gera 50.000 notas sintéticas e força o cálculo completo de desempenho e ranking.
rodarStressDominioPuro :: IO ()
rodarStressDominioPuro = do
    putStrLn "\n[1/3] Stress do Domínio Puro (5.000 alunos x 10 notas = 50.000 registros)..."
    let alunosSim =
            [ newRecord @Aluno
                |> set #id (Id (unsafeTextToUUID i))
                |> set #nome ("Aluno " <> tshow i)
                |> set #matricula (tshow (20260000 + i))
            | i <- [1 .. 5000 :: Int]
            ]
        notasSim =
            [ newRecord @Nota
                |> set #alunoId (get #id a)
                |> set #valor (fromIntegral ((idx `mod` 10) + 1))
            | a <- alunosSim
            , idx <- [1 .. 10 :: Int]
            ]

    inicio <- getCurrentTime
    let ranking = Academic.calcularRanking notasSim
        resumos = Dashboard.gerarResumoAlunos alunosSim notasSim []
        metricas = Dashboard.calcularMetricasGerais alunosSim [] [] resumos
    -- Força avaliação estrita para medir o custo real (evitando lazy bypass)
    let !_ = length ranking + Dashboard.totalEstudantes metricas
    fim <- getCurrentTime

    let duracao = realToFrac (diffUTCTime fim inicio) :: Double
    putStrLn ("  -> Ranking calculado: " <> tshow (length ranking) <> " alunos")
    putStrLn ("  -> Média institucional: " <> tshow (Dashboard.mediaInstitucional metricas))
    putStrLn ("  -> Tempo total: " <> tshow duracao <> "s")

-- | Dispara N workers concorrentes executando criptografia, validação monádica e fallback.
rodarStressConcorrenteWorkers :: Int -> Int -> IO ()
rodarStressConcorrenteWorkers workers ciclosPorWorker = do
    putStrLn ("\n[2/3] Stress Concorrente (" <> tshow workers <> " workers x " <> tshow ciclosPorWorker <> " pipelines)...")
    inicio <- getCurrentTime
    mvars <- forM [1 .. workers] \w -> do
        mv <- newEmptyMVar
        _ <- forkIO do
            latencias <- forM [1 .. ciclosPorWorker] \c -> do
                t0 <- getCurrentTime
                let payload = "DOC-" <> tshow w <> "-" <> tshow c
                    cifrado = Security.criptografarTexto Security.chaveMestraPadrao payload
                    decifrado = Errors.decifrarOuFallback "ERR" Security.chaveMestraPadrao cifrado
                    media = Errors.mediaComFallback 0.0 [7.5, 8.5, 9.0]
                let !_ = decifrado == payload && media > 0
                t1 <- getCurrentTime
                pure (diffUTCTime t1 t0)
            putMVar mv latencias
        pure mv

    todasLatencias <- concat <$> mapM takeMVar mvars
    fim <- getCurrentTime
    exibirMetricas "Workers Puros/Cripto" (workers * ciclosPorWorker) inicio fim todasLatencias

-- | Dispara consultas concorrentes reais contra o PostgreSQL configurado no IHP.
rodarStressBancoConcorrente :: (?modelContext :: ModelContext) => Int -> Int -> IO ()
rodarStressBancoConcorrente workers consultasPorWorker = do
    putStrLn ("\n[3/3] Stress Concorrente no PostgreSQL (" <> tshow workers <> " workers x " <> tshow consultasPorWorker <> " queries)...")
    inicio <- getCurrentTime
    mvars <- forM [1 .. workers] \_ -> do
        mv <- newEmptyMVar
        _ <- forkIO do
            latencias <- forM [1 .. consultasPorWorker] \_ -> do
                t0 <- getCurrentTime
                alunos <- query @Aluno |> fetch
                notas <- query @Nota |> fetch
                let !_ = length alunos + length notas
                t1 <- getCurrentTime
                pure (diffUTCTime t1 t0)
            putMVar mv latencias
        pure mv

    todasLatencias <- concat <$> mapM takeMVar mvars
    fim <- getCurrentTime
    exibirMetricas "Consultas PostgreSQL" (workers * consultasPorWorker) inicio fim todasLatencias

exibirMetricas :: Text -> Int -> UTCTime -> UTCTime -> [NominalDiffTime] -> IO ()
exibirMetricas nome totalOps inicio fim latencias = do
    let duracao = max 0.0001 (realToFrac (diffUTCTime fim inicio) :: Double)
        rps = fromIntegral totalOps / duracao
        msList = sort (map (\d -> realToFrac d * 1000.0 :: Double) latencias)
        mediaMs = if null msList then 0.0 else sum msList / fromIntegral (length msList)
        p95Idx = max 0 (min (length msList - 1) (round (0.95 * fromIntegral (length msList))))
        p95Ms = case drop p95Idx msList of
            (x : _) -> x
            []      -> 0.0
    putStrLn ("  -> [" <> nome <> "] Total: " <> tshow totalOps <> " ops em " <> tshow duracao <> "s")
    putStrLn ("  -> Throughput: " <> tshow (round rps :: Int) <> " ops/s | Média: " <> tshow mediaMs <> " ms | p95: " <> tshow p95Ms <> " ms")

unsafeTextToUUID :: Int -> UUID
unsafeTextToUUID n =
    let sufixo = replicate (12 - length (show n)) '0' <> show n
        txt = "00000000-0000-0000-0000-" <> cs sufixo
    in fromMaybe def (UUID.fromText txt)
