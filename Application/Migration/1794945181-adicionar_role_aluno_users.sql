ALTER TABLE users DROP CONSTRAINT users_role_valida;
ALTER TABLE users ADD CONSTRAINT users_role_valida CHECK (role IN ('admin', 'consulta', 'aluno'));
