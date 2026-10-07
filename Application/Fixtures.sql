-- Fixtures acadêmicos para SGA-Func (UNIFOR)

-- Professor
INSERT INTO professores (id, nome, email) VALUES
    ('b1111111-1111-1111-1111-111111111111', 'Dr. Alan Turing', 'alan.turing@unifor.br');

-- Disciplina
INSERT INTO disciplinas (id, nome, codigo, carga_horaria) VALUES
    ('c1111111-1111-1111-1111-111111111111', 'Programação Funcional', 'CC-PF01', 60);

-- Turma
INSERT INTO turmas (id, disciplina_id, professor_id, semestre) VALUES
    ('d1111111-1111-1111-1111-111111111111', 'c1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', '2026.1');

-- Alunos
INSERT INTO alunos (id, nome, matricula, email) VALUES
    ('a1111111-1111-1111-1111-111111111111', 'Alice Silva', '241001', 'alice.silva@aluno.unifor.br'),
    ('a2222222-2222-2222-2222-222222222222', 'Bruno Santos', '241002', 'bruno.santos@aluno.unifor.br'),
    ('a3333333-3333-3333-3333-333333333333', 'Carla Lima', '241003', 'carla.lima@aluno.unifor.br'),
    ('a4444444-4444-4444-4444-444444444444', 'Daniel Souza', '241004', 'daniel.souza@aluno.unifor.br');

-- Notas (Turma 2026.1)
-- Alice Silva (Médias altas: 9.5, 9.0, 10.0 -> Média: 9.5)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', 9.5, 'AV1 - Prova Teórica'),
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', 9.0, 'AV2 - Projeto IHP'),
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', 10.0, 'Trabalho Prático Haskell');

-- Bruno Santos (Médias boas: 7.5, 8.0, 7.0 -> Média: 7.5)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', 7.5, 'AV1 - Prova Teórica'),
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', 8.0, 'AV2 - Projeto IHP'),
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', 7.0, 'Trabalho Prático Haskell');

-- Carla Lima (Média regular / final: 5.5, 6.0, 5.0 -> Média: 5.5)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', 5.5, 'AV1 - Prova Teórica'),
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', 6.0, 'AV2 - Projeto IHP'),
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', 5.0, 'Trabalho Prático Haskell');

-- Daniel Souza (Média baixa: 3.5, 4.0, 3.0 -> Média: 3.5)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', 3.5, 'AV1 - Prova Teórica'),
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', 4.0, 'AV2 - Projeto IHP'),
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', 3.0, 'Trabalho Prático Haskell');

-- Frequências (5 aulas para cada aluno)
-- Alice: 100% presenças (5/5)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', '2026-03-01', true),
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', '2026-03-08', true),
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', '2026-03-15', true),
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', '2026-03-22', true),
    (uuid_generate_v4(), 'a1111111-1111-1111-1111-111111111111', 'd1111111-1111-1111-1111-111111111111', '2026-03-29', true);

-- Bruno: 80% presenças (4/5)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', '2026-03-01', true),
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', '2026-03-08', true),
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', '2026-03-15', true),
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', '2026-03-22', true),
    (uuid_generate_v4(), 'a2222222-2222-2222-2222-222222222222', 'd1111111-1111-1111-1111-111111111111', '2026-03-29', false);

-- Carla: 60% presenças (3/5)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', '2026-03-01', true),
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', '2026-03-08', false),
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', '2026-03-15', true),
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', '2026-03-22', true),
    (uuid_generate_v4(), 'a3333333-3333-3333-3333-333333333333', 'd1111111-1111-1111-1111-111111111111', '2026-03-29', false);

-- Daniel: 40% presenças (2/5)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', '2026-03-01', true),
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', '2026-03-08', false),
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', '2026-03-15', false),
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', '2026-03-22', true),
    (uuid_generate_v4(), 'a4444444-4444-4444-4444-444444444444', 'd1111111-1111-1111-1111-111111111111', '2026-03-29', false);
