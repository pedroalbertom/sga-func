-- Migration: Adicionar coluna documento_criptografado na tabela alunos (Sprint 3 - Segurança)
ALTER TABLE alunos ADD COLUMN documento_criptografado TEXT DEFAULT NULL;
