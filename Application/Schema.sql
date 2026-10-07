-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
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
