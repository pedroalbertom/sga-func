CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE alunos (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    nome TEXT NOT NULL,
    matricula TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL
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
ALTER TABLE notas ADD CONSTRAINT notas_aluno_id_fk FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE CASCADE;
ALTER TABLE notas ADD CONSTRAINT notas_turma_id_fk FOREIGN KEY (turma_id) REFERENCES turmas (id) ON DELETE CASCADE;
ALTER TABLE frequencias ADD CONSTRAINT frequencias_aluno_id_fk FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE CASCADE;
ALTER TABLE frequencias ADD CONSTRAINT frequencias_turma_id_fk FOREIGN KEY (turma_id) REFERENCES turmas (id) ON DELETE CASCADE;

-- Fixtures: Professor
INSERT INTO professores (id, nome, email) VALUES
    ('00000000-0000-0000-0000-000000000001', 'Prof. Carlos Eduardo', 'carlos.eduardo@unifor.br');

-- Fixtures: Disciplina
INSERT INTO disciplinas (id, nome, codigo, carga_horaria) VALUES
    ('00000000-0000-0000-0000-000000000010', 'Programação Funcional', 'CC-PF01', 60);

-- Fixtures: Turma
INSERT INTO turmas (id, disciplina_id, professor_id, semestre) VALUES
    ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', '2026.1');

-- Fixtures: Alunos
INSERT INTO alunos (id, nome, matricula, email) VALUES
    ('00000000-0000-0000-0000-000000000101', 'Alice Silva', '241001', 'alice.silva@aluno.unifor.br'),
    ('00000000-0000-0000-0000-000000000102', 'Bruno Santos', '241002', 'bruno.santos@aluno.unifor.br'),
    ('00000000-0000-0000-0000-000000000103', 'Carla Lima', '241003', 'carla.lima@aluno.unifor.br'),
    ('00000000-0000-0000-0000-000000000104', 'Daniel Souza', '241004', 'daniel.souza@aluno.unifor.br');

-- Fixtures: Notas
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', 9.5, 'AV1'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', 9.0, 'AV2'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', 10.0, 'Trabalho'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', 7.5, 'AV1'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', 8.0, 'AV2'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', 7.0, 'Trabalho'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', 5.5, 'AV1'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', 6.0, 'AV2'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', 5.0, 'Trabalho'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', 3.5, 'AV1'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', 4.0, 'AV2'),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', 3.0, 'Trabalho');

-- Fixtures: Frequências
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', '2026-03-01', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', '2026-03-08', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', '2026-03-15', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', '2026-03-22', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000020', '2026-03-29', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', '2026-03-01', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', '2026-03-08', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', '2026-03-15', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', '2026-03-22', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000020', '2026-03-29', false),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', '2026-03-01', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', '2026-03-08', false),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', '2026-03-15', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', '2026-03-22', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000020', '2026-03-29', false),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', '2026-03-01', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', '2026-03-08', false),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', '2026-03-15', false),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', '2026-03-22', true),
    (uuid_generate_v4(), '00000000-0000-0000-0000-000000000104', '00000000-0000-0000-0000-000000000020', '2026-03-29', false);
