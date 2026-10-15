CREATE TABLE cursos (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    nome TEXT NOT NULL,
    codigo TEXT NOT NULL UNIQUE,
    carga_horaria INT NOT NULL,
    CONSTRAINT cursos_nome_valido CHECK ((char_length(btrim(nome)) >= 2) AND (char_length(btrim(nome)) <= 150)),
    CONSTRAINT cursos_codigo_valido CHECK (regexp_like(codigo, '^[A-Z0-9][A-Z0-9-]{1,19}$')),
    CONSTRAINT cursos_carga_valida CHECK ((carga_horaria >= 1) AND (carga_horaria <= 10000))
);
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT DEFAULT 'consulta' NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL,
    CONSTRAINT users_role_valida CHECK (role IN ('admin', 'consulta')),
    CONSTRAINT users_email_normalizado CHECK (email = lower(btrim(email)) AND regexp_like(email, '^[^[:space:]@]+@[^[:space:]@.]+([.][^[:space:]@.]+)+$'))
);
ALTER TABLE alunos ADD COLUMN curso_id UUID DEFAULT NULL;
CREATE INDEX alunos_curso_id_index ON alunos (curso_id);
ALTER TABLE alunos ADD CONSTRAINT alunos_curso_id_fk FOREIGN KEY (curso_id) REFERENCES cursos (id) ON DELETE RESTRICT;
ALTER TABLE alunos ADD CONSTRAINT alunos_nome_valido CHECK ((char_length(btrim(nome)) >= 2) AND (char_length(btrim(nome)) <= 150));
ALTER TABLE alunos ADD CONSTRAINT alunos_matricula_valida CHECK (regexp_like(matricula, '^[0-9]{4,20}$'));
ALTER TABLE alunos ADD CONSTRAINT alunos_email_valido CHECK ((char_length(email) <= 254) AND regexp_like(email, '^[^[:space:]@]+@[^[:space:]@.]+([.][^[:space:]@.]+)+$'));

ALTER TABLE notas DROP CONSTRAINT notas_aluno_id_fk;
ALTER TABLE notas ADD CONSTRAINT notas_aluno_id_fk FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE RESTRICT;
ALTER TABLE frequencias DROP CONSTRAINT frequencias_aluno_id_fk;
ALTER TABLE frequencias ADD CONSTRAINT frequencias_aluno_id_fk FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE RESTRICT;
