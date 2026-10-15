-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE alunos (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    nome TEXT NOT NULL,
    matricula TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL,
    curso_id UUID DEFAULT NULL
);
CREATE TABLE professores (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    nome TEXT NOT NULL,
    email TEXT NOT NULL
);
CREATE TABLE disciplinas (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    nome TEXT NOT NULL,
    codigo TEXT NOT NULL UNIQUE,
    carga_horaria INT NOT NULL
);
CREATE TABLE turmas (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    disciplina_id UUID NOT NULL,
    professor_id UUID NOT NULL,
    semestre TEXT NOT NULL
);
CREATE TABLE notas (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    aluno_id UUID NOT NULL,
    turma_id UUID NOT NULL,
    valor DOUBLE PRECISION NOT NULL,
    descricao TEXT NOT NULL
);
CREATE TABLE frequencias (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    aluno_id UUID NOT NULL,
    turma_id UUID NOT NULL,
    data DATE DEFAULT CURRENT_DATE NOT NULL,
    presente BOOLEAN NOT NULL
);
CREATE INDEX turmas_disciplina_id_index ON turmas (disciplina_id);
CREATE INDEX turmas_professor_id_index ON turmas (professor_id);
CREATE INDEX notas_aluno_id_index ON notas (aluno_id);
CREATE INDEX notas_turma_id_index ON notas (turma_id);
CREATE INDEX frequencias_aluno_id_index ON frequencias (aluno_id);
CREATE INDEX frequencias_turma_id_index ON frequencias (turma_id);
ALTER TABLE turmas ADD CONSTRAINT turmas_disciplina_id_fk FOREIGN KEY (disciplina_id) REFERENCES disciplinas (id) ON DELETE CASCADE;
ALTER TABLE turmas ADD CONSTRAINT turmas_professor_id_fk FOREIGN KEY (professor_id) REFERENCES professores (id) ON DELETE CASCADE;
ALTER TABLE notas ADD CONSTRAINT notas_aluno_id_fk FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE RESTRICT;
ALTER TABLE notas ADD CONSTRAINT notas_turma_id_fk FOREIGN KEY (turma_id) REFERENCES turmas (id) ON DELETE CASCADE;
ALTER TABLE frequencias ADD CONSTRAINT frequencias_aluno_id_fk FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE RESTRICT;
ALTER TABLE frequencias ADD CONSTRAINT frequencias_turma_id_fk FOREIGN KEY (turma_id) REFERENCES turmas (id) ON DELETE CASCADE;

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
CREATE INDEX alunos_curso_id_index ON alunos (curso_id);
ALTER TABLE alunos ADD CONSTRAINT alunos_curso_id_fk FOREIGN KEY (curso_id) REFERENCES cursos (id) ON DELETE RESTRICT;
ALTER TABLE alunos ADD CONSTRAINT alunos_nome_valido CHECK ((char_length(btrim(nome)) >= 2) AND (char_length(btrim(nome)) <= 150));
ALTER TABLE alunos ADD CONSTRAINT alunos_matricula_valida CHECK (regexp_like(matricula, '^[0-9]{4,20}$'));
ALTER TABLE alunos ADD CONSTRAINT alunos_email_valido CHECK ((char_length(email) <= 254) AND regexp_like(email, '^[^[:space:]@]+@[^[:space:]@.]+([.][^[:space:]@.]+)+$'));
