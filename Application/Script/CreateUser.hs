#!/usr/bin/env run-script
module Application.Script.CreateUser where

import Application.Script.Prelude
import qualified Data.Text as Text
import qualified System.Environment as Environment

-- Credentials come from the operator, never from an HTTP role parameter.
run :: Script
run = do
    email <- Text.toLower . Text.strip . cs <$> Environment.getEnv "SGA_USER_EMAIL"
    password <- cs <$> Environment.getEnv "SGA_USER_PASSWORD"
    role <- cs <$> Environment.getEnv "SGA_USER_ROLE"
    unless (role `elem` (["admin", "consulta"] :: [Text])) (error "SGA_USER_ROLE deve ser admin ou consulta")
    unless (Text.length password >= 12) (error "Use uma senha com pelo menos 12 caracteres")
    passwordHash <- hashPassword password
    user <- newRecord @User
        |> set #email email
        |> set #passwordHash passwordHash
        |> set #role_ role
        |> validateField #email isEmail
        |> validateIsUnique #email
    user |> ifValid \case
        Left _ -> error "E-mail inválido ou já cadastrado"
        Right user -> do
            _ <- createRecord user
            putStrLn "Usuário criado."
