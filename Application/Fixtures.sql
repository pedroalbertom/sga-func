-- Dados de teste completos para SGA-Func

-- Professores
INSERT INTO professores (id, nome, email) VALUES
    ('0ab3f40c-2fd4-4481-b9d1-33c9669e1436', 'Prof. Carlos Eduardo', 'carlos.eduardo@unifor.br'),
    ('c89eb8ad-a64a-4716-8c49-c5fa16220e02', 'Profa. Maria Fernanda', 'maria.fernanda@unifor.br'),
    ('1f374690-00da-4b8f-8cdc-70f3e1db999b', 'Prof. João Pedro', 'joao.pedro@unifor.br'),
    ('820939b7-9c89-4bd5-91e3-ec9b3370221e', 'Profa. Beatriz Nogueira', 'beatriz.nogueira@unifor.br'),
    ('0179b82f-f563-4a9c-bb42-9dec37afff94', 'Prof. Rafael Tavares', 'rafael.tavares@unifor.br'),
    ('d8e3d23c-e6a2-4f63-931a-59fbcb8641b1', 'Profa. Larissa Vasconcelos', 'larissa.vasconcelos@unifor.br')
ON CONFLICT DO NOTHING;

-- Cursos
INSERT INTO cursos (id, nome, codigo, carga_horaria) VALUES
    ('369716ec-47cc-4728-83d2-037b604f6809', 'Ciência da Computação', 'CC', 3200),
    ('be18531a-7bad-4591-9bc6-24c471868934', 'Engenharia de Software', 'ES', 3000),
    ('6f2f956c-02df-4935-8c4f-39a92ca65d47', 'Análise e Desenvolvimento de Sistemas', 'ADS', 2400),
    ('b064209b-76db-48b2-a497-dc1fe00503f2', 'Sistemas de Informação', 'SI', 3000)
ON CONFLICT DO NOTHING;

-- Disciplinas
INSERT INTO disciplinas (id, nome, codigo, carga_horaria) VALUES
    ('de19831a-db0c-404c-b92a-5e192d31a71d', 'Programação Funcional', 'CC-PF01', 60),
    ('622f2adf-7c68-45f5-abd4-9d1b4ca704db', 'Estrutura de Dados', 'CC-ED02', 60),
    ('732a4262-2981-4561-84a6-f1361ac65e21', 'Banco de Dados', 'CC-BD03', 60),
    ('7438baee-ea64-4fe2-8c93-a662c0af9a05', 'Engenharia de Requisitos', 'ES-ER04', 60),
    ('4f3f25d2-db24-4d40-bff0-7f65598aeabf', 'Redes de Computadores', 'ADS-RC05', 60),
    ('4485dbe5-7d41-4ef3-8f62-b5b11d778028', 'Segurança da Informação', 'SI-SI06', 60)
ON CONFLICT DO NOTHING;

-- Turmas
INSERT INTO turmas (id, disciplina_id, professor_id, semestre) VALUES
    ('d34c278d-b075-4022-8337-d959e1ba8fa5', 'de19831a-db0c-404c-b92a-5e192d31a71d', '0ab3f40c-2fd4-4481-b9d1-33c9669e1436', '2026.1'),
    ('32f9c9b9-b599-400b-99c7-4b1374ad3e1a', 'de19831a-db0c-404c-b92a-5e192d31a71d', '0ab3f40c-2fd4-4481-b9d1-33c9669e1436', '2025.2'),
    ('4d7100bd-fd37-4807-809c-c9273368f35a', '622f2adf-7c68-45f5-abd4-9d1b4ca704db', 'c89eb8ad-a64a-4716-8c49-c5fa16220e02', '2026.1'),
    ('99f2e479-da85-480e-a35f-011dd61965dd', '732a4262-2981-4561-84a6-f1361ac65e21', '1f374690-00da-4b8f-8cdc-70f3e1db999b', '2026.1'),
    ('ef164c8b-851b-40ca-8d14-ac2019f88a82', '7438baee-ea64-4fe2-8c93-a662c0af9a05', '820939b7-9c89-4bd5-91e3-ec9b3370221e', '2026.1'),
    ('1633f318-60a8-437e-bc21-3ee20035b40d', '4f3f25d2-db24-4d40-bff0-7f65598aeabf', '0179b82f-f563-4a9c-bb42-9dec37afff94', '2026.1'),
    ('6689dff6-2459-419f-b492-246f279a7688', '4485dbe5-7d41-4ef3-8f62-b5b11d778028', 'd8e3d23c-e6a2-4f63-931a-59fbcb8641b1', '2026.1')
ON CONFLICT DO NOTHING;

-- Alunos
INSERT INTO alunos (id, nome, matricula, email, curso_id) VALUES
    ('902f389a-a9f2-40fe-bc96-88348e4a0c13', 'Alice Silva', '241001', 'alice.silva@aluno.unifor.br', '369716ec-47cc-4728-83d2-037b604f6809'),
    ('88ac0320-11f4-42bd-bd35-0755f4dde75c', 'Bruno Santos', '241002', 'bruno.santos@aluno.unifor.br', '369716ec-47cc-4728-83d2-037b604f6809'),
    ('d29bf1da-a87e-4c75-bc33-94440d93d675', 'Carla Lima', '241003', 'carla.lima@aluno.unifor.br', 'be18531a-7bad-4591-9bc6-24c471868934'),
    ('cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'Daniel Souza', '241004', 'daniel.souza@aluno.unifor.br', '6f2f956c-02df-4935-8c4f-39a92ca65d47'),
    ('d568498d-7c79-45dd-a50c-4478389e7521', 'Eduardo Rocha', '241005', 'eduardo.rocha@aluno.unifor.br', 'be18531a-7bad-4591-9bc6-24c471868934'),
    ('ae82bda3-0488-496a-83f5-ad89f7dd7282', 'Fernanda Costa', '241006', 'fernanda.costa@aluno.unifor.br', '369716ec-47cc-4728-83d2-037b604f6809'),
    ('33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'Gabriel Alves', '241007', 'gabriel.alves@aluno.unifor.br', 'b064209b-76db-48b2-a497-dc1fe00503f2'),
    ('b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'Helena Martins', '241008', 'helena.martins@aluno.unifor.br', 'b064209b-76db-48b2-a497-dc1fe00503f2'),
    ('a101685c-75c9-449b-bce4-5c57d4180107', 'Igor Ribeiro', '241009', 'igor.ribeiro@aluno.unifor.br', '6f2f956c-02df-4935-8c4f-39a92ca65d47'),
    ('11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'Júlia Mendes', '241010', 'julia.mendes@aluno.unifor.br', '6f2f956c-02df-4935-8c4f-39a92ca65d47'),
    ('9bc27fc6-d378-4321-8d7b-8bcac2887f71', 'Lucas Ferreira', '241011', 'lucas.ferreira@aluno.unifor.br', 'be18531a-7bad-4591-9bc6-24c471868934'),
    ('719f1bbb-f3f1-4232-ad91-006afc448ab2', 'Mariana Castro', '241012', 'mariana.castro@aluno.unifor.br', '369716ec-47cc-4728-83d2-037b604f6809'),
    ('d969ada8-43c6-4628-b385-00f756753a2a', 'Mateus Barbosa', '241013', 'mateus.barbosa@aluno.unifor.br', '6f2f956c-02df-4935-8c4f-39a92ca65d47'),
    ('a38b7fb8-d213-4b06-8974-81a4d4012558', 'Natália Gomes', '241014', 'natalia.gomes@aluno.unifor.br', 'b064209b-76db-48b2-a497-dc1fe00503f2'),
    ('a9bf4d77-11a6-4ff1-91e0-89a8b690c94e', 'Otávio Cunha', '241015', 'otavio.cunha@aluno.unifor.br', 'be18531a-7bad-4591-9bc6-24c471868934'),
    ('f064bdff-88b2-41f9-bcf8-606f5127d960', 'Paula Teixeira', '241016', 'paula.teixeira@aluno.unifor.br', 'b064209b-76db-48b2-a497-dc1fe00503f2')
ON CONFLICT (matricula) DO UPDATE SET curso_id = COALESCE(alunos.curso_id, EXCLUDED.curso_id);

-- Notas: Turma Principal (Programação Funcional 2026.1)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    -- Alice (médias altas: 9.5)
    ('0bb08dcc-5a47-4015-8468-cc9d7eeb6db1', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 9.5, 'AV1'),
    ('1ec8439b-19d8-453d-8f72-cb959fd270d0', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 9.0, 'AV2'),
    ('45f85c51-152e-4cc9-bb81-bb5966fd4222', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 10.0, 'Trabalho'),

    -- Bruno (notas regulares/boas: 7.6)
    ('e139342d-e80c-4a1a-b1d1-41faf235f721', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 7.5, 'AV1'),
    ('a3822174-ca5c-4a26-8b59-81f125712b13', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 8.0, 'AV2'),
    ('860052c3-7a3c-445a-a447-f61feb001aaf', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 7.0, 'Trabalho'),

    -- Carla (prova final por nota: 5.3)
    ('02b36404-9fb8-417a-9293-c9a588172a37', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 5.5, 'AV1'),
    ('4267631c-f5c2-48e4-a816-5bc626468d5e', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 6.0, 'AV2'),
    ('c14e7f82-b043-4501-b559-2142c5444f81', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 5.0, 'Trabalho'),

    -- Daniel (reprovado por nota: 3.3)
    ('672aa0f1-3da6-4f3f-a958-2f20485909c4', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 3.5, 'AV1'),
    ('3c09fa99-ac4d-4182-ab0c-27e60492c654', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 4.0, 'AV2'),
    ('f0508c0b-f2e2-4a05-b78c-0f35186967d7', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 3.0, 'Trabalho'),

    -- Eduardo Rocha (Prova Final: 5.6)
    ('131685d3-354a-484c-8868-bc9c0d059eb1', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 5.5, 'AV1'),
    ('8773aca1-886e-411a-8c4a-dbbbc9b5da09', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 6.0, 'AV2'),
    ('6478c8c6-8385-44ea-9d5f-6b8c016a13b6', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 5.5, 'Trabalho'),

    -- Fernanda Costa (Top 1 / Destaque: 9.9)
    ('34eafd52-25ba-4287-936b-a584ce4f73e2', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 10.0, 'AV1'),
    ('5b1ea25a-debf-4083-bcc0-fd8e3bf4ef9a', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 9.8, 'AV2'),
    ('a87d7027-e949-4b16-af4f-737bbdce55e5', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 10.0, 'Trabalho'),

    -- Gabriel Alves (Aprovado sólido: 7.2)
    ('dbba023f-e825-42e6-b77f-7275af68794a', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 7.0, 'AV1'),
    ('33d60c02-7762-4da8-8693-03045e144574', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 7.0, 'AV2'),
    ('7c308775-f53d-45fb-af85-ee5561be2d7d', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 7.5, 'Trabalho'),

    -- Helena Martins (Aprovada destaque: 8.6)
    ('9c73be10-1a4a-4d0b-8024-ce07135719c4', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 8.5, 'AV1'),
    ('665d3596-7f66-4b08-a898-462146df8bdc', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 8.0, 'AV2'),
    ('1b7e0791-3fa3-4c63-b039-d72ac0489b52', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 9.0, 'Trabalho'),

    -- Igor Ribeiro (Nota alta: 8.1, mas reprova por faltas)
    ('8f2f46c9-1361-49bc-9d61-08d1205d2e4a', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 8.0, 'AV1'),
    ('941ef45c-b78f-44fb-b7f3-cfc83a5e1758', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 8.5, 'AV2'),
    ('a5efc434-3d9b-40e5-976d-27838295c7e7', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 8.0, 'Trabalho'),

    -- Júlia Mendes (Prova Final: 4.6)
    ('61954737-4e7a-4c15-9f1a-8bb434dc33b1', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 4.5, 'AV1'),
    ('99de9f80-6cfa-411d-bb6a-952cb93ddb97', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 5.0, 'AV2'),
    ('ecbdb27a-8b26-44f6-8267-0ea406312aa9', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', 4.5, 'Trabalho');

-- Notas: Turma de Estrutura de Dados (2026.1)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    ('121d624e-26a2-497f-ad57-61f7f48e55b7', '88ac0320-11f4-42bd-bd35-0755f4dde75c', '4d7100bd-fd37-4807-809c-c9273368f35a', 8.0, 'AV1'),
    ('83dfdb6a-0df8-4130-8a05-ae4128801ce9', '88ac0320-11f4-42bd-bd35-0755f4dde75c', '4d7100bd-fd37-4807-809c-c9273368f35a', 8.5, 'AV2'),
    ('626514a8-de9a-47af-8c5c-77c86c068246', '88ac0320-11f4-42bd-bd35-0755f4dde75c', '4d7100bd-fd37-4807-809c-c9273368f35a', 8.0, 'Trabalho'),
    ('649779c9-a0d5-4c7f-9bd0-b20eb0cebe49', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', '4d7100bd-fd37-4807-809c-c9273368f35a', 9.5, 'AV1'),
    ('3e2a20ac-cb0b-49fc-b715-7a8ac98d1bde', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', '4d7100bd-fd37-4807-809c-c9273368f35a', 9.5, 'AV2'),
    ('9bb0beb1-4dfe-4911-8287-d69d6ce612ef', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', '4d7100bd-fd37-4807-809c-c9273368f35a', 10.0, 'Trabalho'),
    ('2da71da7-4f9f-4cce-8bed-a2dbb0129c92', 'd568498d-7c79-45dd-a50c-4478389e7521', '4d7100bd-fd37-4807-809c-c9273368f35a', 6.5, 'AV1'),
    ('b2b70d95-660f-48f9-b37c-0ef1a8cc9fad', 'd568498d-7c79-45dd-a50c-4478389e7521', '4d7100bd-fd37-4807-809c-c9273368f35a', 7.0, 'AV2'),
    ('8a11bc36-0538-4d0b-9865-1279340eabfb', 'd568498d-7c79-45dd-a50c-4478389e7521', '4d7100bd-fd37-4807-809c-c9273368f35a', 6.0, 'Trabalho');

-- Notas: Turma de Banco de Dados (2026.1)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    ('73fbce9d-dd3a-4581-bfa6-96719f865141', '902f389a-a9f2-40fe-bc96-88348e4a0c13', '99f2e479-da85-480e-a35f-011dd61965dd', 9.0, 'AV1'),
    ('7892bf93-e70e-48b3-b065-cf852bd71a1d', '902f389a-a9f2-40fe-bc96-88348e4a0c13', '99f2e479-da85-480e-a35f-011dd61965dd', 9.5, 'AV2'),
    ('347d49a9-20d9-4146-a145-a54790657f5e', '902f389a-a9f2-40fe-bc96-88348e4a0c13', '99f2e479-da85-480e-a35f-011dd61965dd', 9.0, 'Trabalho'),
    ('81080928-0760-4880-9ef9-2912cde69986', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', '99f2e479-da85-480e-a35f-011dd61965dd', 8.0, 'AV1'),
    ('57620a23-82bd-4a89-9d57-4e405ea23311', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', '99f2e479-da85-480e-a35f-011dd61965dd', 9.0, 'AV2'),
    ('73a84af1-605b-4784-b375-79c06da6990a', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', '99f2e479-da85-480e-a35f-011dd61965dd', 8.5, 'Trabalho'),
    ('2822b26b-c77a-4361-abbe-e219af1d580d', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', '99f2e479-da85-480e-a35f-011dd61965dd', 7.5, 'AV1'),
    ('02bc1fa0-b2c2-4ea6-90b1-da5ca29da77c', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', '99f2e479-da85-480e-a35f-011dd61965dd', 7.0, 'AV2'),
    ('d3aaeb63-6ec1-48c6-860b-93359b8b6204', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', '99f2e479-da85-480e-a35f-011dd61965dd', 7.0, 'Trabalho');

-- Frequências: Turma Principal (Programação Funcional 2026.1)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    -- Alice: 100% (5/5)
    ('185c3b86-117e-4915-940e-d2da927bc6a1', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('681bb361-abdd-43d4-978b-cbb4e627e3d9', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', true),
    ('5cb4f097-34bc-4795-9909-353680a59c79', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('1e41d1e1-5296-41eb-9ef7-76e3e3a40078', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('5a0aed15-dbcf-4f61-b11b-a1eb4d9db29e', '902f389a-a9f2-40fe-bc96-88348e4a0c13', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', true),

    -- Bruno: 80% (4/5)
    ('654f5c53-f7fd-4785-81de-b1793c29c757', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('e719ab7d-2df1-46ae-b5de-318490510de6', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', true),
    ('3a1706f9-6d4b-49e6-8dec-a6f3f1f477be', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('c91d9af2-13f8-4d4b-bc7e-6a03b63bd768', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('ca377bf9-062d-4106-bc3c-3df623b1a8e2', '88ac0320-11f4-42bd-bd35-0755f4dde75c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', false),

    -- Carla: 60% (3/5 - reprovada por falta)
    ('77000790-3a2f-413a-878c-8e593a70147a', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('b564cd0c-6257-4483-b4d2-f10b0b698da4', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', false),
    ('289ec0ea-6bc7-47d3-8733-05523e15f006', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('450e9b63-18db-4b0f-be60-2956759f1a95', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('489f6b43-66b6-43ed-ab77-1a6164653f0f', 'd29bf1da-a87e-4c75-bc33-94440d93d675', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', false),

    -- Daniel: 40% (2/5 - reprovado por falta)
    ('b206c101-5f05-4ec8-8545-9e5906fa6820', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('99957286-18f1-4115-957d-5cf43474255e', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', false),
    ('1c1bdc41-24aa-4aa6-846b-d88f3208f4eb', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', false),
    ('d6683676-804a-4d8d-90b6-e2c294c6c164', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('fc5504f4-f85b-40f9-aff9-25a7170a2dd6', 'cf5b8a68-a1e0-451d-bf0a-50230980a15c', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', false),

    -- Eduardo: 80% (4/5)
    ('08a729ab-12c4-4c2c-9fdf-2c2358f5795c', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('52342c27-e8be-469f-af31-4dfd4e82df60', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', true),
    ('37f5a3b8-35b6-4faf-8906-79e112c65196', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('427174ef-c138-4bb3-a40a-cecf4bce8183', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('31136f11-48e4-4c7a-b171-c53b56522db9', 'd568498d-7c79-45dd-a50c-4478389e7521', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', false),

    -- Fernanda: 100% (5/5)
    ('e64d8023-b54e-41fa-988b-20a430d9ea17', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('3f450da0-67ee-4bae-925c-de1aef2b48b4', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', true),
    ('619f8a25-ff3a-49c7-9051-bcf5c95cf7e5', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('dc314311-9c4d-48e4-bdcf-63f2ab547a51', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('22fda247-e52c-4630-9364-cbcf19d46a0e', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', true),

    -- Gabriel: 80% (4/5)
    ('24d7357f-f23d-4109-ac0b-f6d7e16116cf', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('c9d5f80b-3772-4d35-ae2f-6852093996aa', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', true),
    ('2c78f307-5e61-4855-99ab-a72c2b34a8e4', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('c16ef2ff-0fcf-4aef-b93d-d74f0a3b914f', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', false),
    ('9e9c27da-c4e1-4573-8846-b779b3362e0b', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', true),

    -- Helena: 100% (5/5)
    ('b4390d9d-17c8-4dc9-beea-2b350cec8add', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('ca1b5365-ef6a-438d-a58a-9fcc38401c81', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', true),
    ('5e4fc997-7128-4cc7-a94a-660ed3d658ba', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('91c0a299-fb32-45f6-bd33-1c7472f861ee', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('8af2ed3d-51e3-4b22-87ef-1269c23092fb', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', true),

    -- Igor: 40% (2/5 - reprovado por falta)
    ('775fcf4f-9a8a-409e-897e-7d82dda95427', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('87164ab5-bd9f-41a2-9c8d-08395b6a27c8', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', false),
    ('563a3402-0da7-481d-8398-5d365001cfb0', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', false),
    ('71cca0cc-5475-43fc-bf47-2adc69100164', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('51f3a5dc-67cb-4c73-a4e2-eff711fb85d0', 'a101685c-75c9-449b-bce4-5c57d4180107', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', false),

    -- Júlia: 80% (4/5)
    ('5d71aca1-c048-4159-8db9-c9d6cf238a86', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-01', true),
    ('434a77e9-27a3-4b84-b292-10e7b465a828', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-08', true),
    ('e888b9fc-6243-460c-9840-a6a7a445bbed', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-15', true),
    ('03214869-d6b6-4aea-9017-aa8cb1e0a6b3', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-22', true),
    ('ec36165d-cafd-45b6-a278-795b50390b80', '11e7c553-4d3f-4bdc-9341-e670a3bb3a03', 'd34c278d-b075-4022-8337-d959e1ba8fa5', '2026-03-29', false);

-- Frequências: Estrutura de Dados (2026.1)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    ('e86dfe04-540b-417e-a076-847d09b687fa', '88ac0320-11f4-42bd-bd35-0755f4dde75c', '4d7100bd-fd37-4807-809c-c9273368f35a', '2026-03-01', true),
    ('b123eec1-b20a-45de-b7b8-21fa72ade8e8', 'ae82bda3-0488-496a-83f5-ad89f7dd7282', '4d7100bd-fd37-4807-809c-c9273368f35a', '2026-03-01', true),
    ('0eb0af5b-eb7f-4fe8-93dd-bc736de9f888', 'd568498d-7c79-45dd-a50c-4478389e7521', '4d7100bd-fd37-4807-809c-c9273368f35a', '2026-03-01', true);

-- Frequências: Banco de Dados (2026.1)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    ('5f2b5b75-fc15-42d8-bd46-2ae41b4928ab', '902f389a-a9f2-40fe-bc96-88348e4a0c13', '99f2e479-da85-480e-a35f-011dd61965dd', '2026-03-01', true),
    ('dab024d0-1169-4528-8516-badf8a3a3737', 'b0cca701-7cdc-45d5-83bb-4ed8dccf96a2', '99f2e479-da85-480e-a35f-011dd61965dd', '2026-03-01', true),
    ('97f0ba54-296b-4293-b732-d7bd860611a0', '33bb9cf1-b1dd-48bd-9251-632e1bc43412', '99f2e479-da85-480e-a35f-011dd61965dd', '2026-03-01', true);

-- Usuários (Sprint 2 - Autenticação)
-- Senha de teste para ambos: senha-de-teste-123
INSERT INTO users (id, email, password_hash, role) VALUES
    ('0ac8b9cc-e709-4421-b0fd-5c6d60aff2da', 'admin@example.com', 'sha256|17|VCENkp2Hnqc/JH0/etD+mg==|I2xvPEgMIFQjLOL6zyw0Hvtn0MHhF0RSNjh6vJkS5rU=', 'admin'),
    ('ea1ab0b3-f487-4321-a89b-f8860ab0df9d', 'consulta@example.com', 'sha256|17|OmF9defmU3ql7e6U8n+v7Q==|eajmj4+xgbE3ogUAS9JXpXIGZEsADa/5EyPKi8NriFE=', 'consulta'),
    ('7a41d8a3-3c9e-4b2a-9c6e-12a34b56c789', 'alice.silva@aluno.unifor.br', 'sha256|17|VCENkp2Hnqc/JH0/etD+mg==|I2xvPEgMIFQjLOL6zyw0Hvtn0MHhF0RSNjh6vJkS5rU=', 'aluno')
ON CONFLICT DO NOTHING;

-- Documento confidencial de exemplo para Alice Silva (123.456.789-00 cifrado)
UPDATE alunos SET documento_criptografado = '62757203726078751a6b7c666275' WHERE matricula = '241001';

-- Notas extras (turmas 0024, 0025, 0026 e alunos 0111..0116)
INSERT INTO notas (id, aluno_id, turma_id, valor, descricao) VALUES
    ('8afc25dd-9d5d-4462-b278-f062a26e9a74', '9bc27fc6-d378-4321-8d7b-8bcac2887f71', 'ef164c8b-851b-40ca-8d14-ac2019f88a82', 8.5, 'AV1'),
    ('0fff8da8-fde7-40ff-8ed7-d090a444c0bd', '9bc27fc6-d378-4321-8d7b-8bcac2887f71', 'ef164c8b-851b-40ca-8d14-ac2019f88a82', 9.0, 'AV2'),
    ('c9710ec0-990a-4856-91fa-972ce6cfae31', '719f1bbb-f3f1-4232-ad91-006afc448ab2', 'ef164c8b-851b-40ca-8d14-ac2019f88a82', 9.5, 'AV1'),
    ('87043dbe-674f-4ebf-b708-61bf5ebdb769', '719f1bbb-f3f1-4232-ad91-006afc448ab2', 'ef164c8b-851b-40ca-8d14-ac2019f88a82', 9.0, 'AV2'),
    ('874d1f3c-243a-4999-b11a-fd850acc89b4', 'd969ada8-43c6-4628-b385-00f756753a2a', '1633f318-60a8-437e-bc21-3ee20035b40d', 6.0, 'AV1'),
    ('e8708c16-0898-4d4d-84c1-795bf38eaa96', 'd969ada8-43c6-4628-b385-00f756753a2a', '1633f318-60a8-437e-bc21-3ee20035b40d', 5.5, 'AV2'),
    ('f8d30fe1-b056-4bc8-9edf-753514226f6b', 'a38b7fb8-d213-4b06-8974-81a4d4012558', '6689dff6-2459-419f-b492-246f279a7688', 8.0, 'AV1'),
    ('85c99418-c79c-4ac2-81f4-da3e536354cc', 'a38b7fb8-d213-4b06-8974-81a4d4012558', '6689dff6-2459-419f-b492-246f279a7688', 8.5, 'AV2'),
    ('05a50079-60d4-43b1-8f0e-3b989d840817', 'a9bf4d77-11a6-4ff1-91e0-89a8b690c94e', '1633f318-60a8-437e-bc21-3ee20035b40d', 3.0, 'AV1'),
    ('dc98248d-1fbd-4f72-a16f-7fa27f6c9259', 'a9bf4d77-11a6-4ff1-91e0-89a8b690c94e', '1633f318-60a8-437e-bc21-3ee20035b40d', 3.5, 'AV2'),
    ('c6e600a4-7a6a-4f21-a0ae-9a3e25de1ff3', 'f064bdff-88b2-41f9-bcf8-606f5127d960', '6689dff6-2459-419f-b492-246f279a7688', 7.5, 'AV1'),
    ('9cbee577-a06f-4179-afb8-40513c392c35', 'f064bdff-88b2-41f9-bcf8-606f5127d960', '6689dff6-2459-419f-b492-246f279a7688', 8.0, 'AV2')
ON CONFLICT DO NOTHING;

-- Frequências extras (alunos 0111..0116)
INSERT INTO frequencias (id, aluno_id, turma_id, data, presente) VALUES
    ('2ef1a165-35e0-40ff-80b3-45d336cd351b', '9bc27fc6-d378-4321-8d7b-8bcac2887f71', 'ef164c8b-851b-40ca-8d14-ac2019f88a82', '2026-03-01', true),
    ('a2f48a04-3a67-4b7d-9b6b-ab8b63036735', '9bc27fc6-d378-4321-8d7b-8bcac2887f71', 'ef164c8b-851b-40ca-8d14-ac2019f88a82', '2026-03-08', true),
    ('4d327676-d947-439b-aa8b-dbfb521585ab', '719f1bbb-f3f1-4232-ad91-006afc448ab2', 'ef164c8b-851b-40ca-8d14-ac2019f88a82', '2026-03-01', true),
    ('9d0de686-132a-4a0c-b653-08194ba63620', 'd969ada8-43c6-4628-b385-00f756753a2a', '1633f318-60a8-437e-bc21-3ee20035b40d', '2026-03-01', true),
    ('a640e014-a0db-45fa-b98d-d58eef10996c', 'd969ada8-43c6-4628-b385-00f756753a2a', '1633f318-60a8-437e-bc21-3ee20035b40d', '2026-03-08', false),
    ('107e96a8-b419-4a40-937e-b71ba3709791', 'a38b7fb8-d213-4b06-8974-81a4d4012558', '6689dff6-2459-419f-b492-246f279a7688', '2026-03-01', true),
    ('0469d88c-f416-4bcd-877c-d946c91a353c', 'a9bf4d77-11a6-4ff1-91e0-89a8b690c94e', '1633f318-60a8-437e-bc21-3ee20035b40d', '2026-03-01', true),
    ('c64cd62e-95a4-40f5-9092-4d7702e27e17', 'f064bdff-88b2-41f9-bcf8-606f5127d960', '6689dff6-2459-419f-b492-246f279a7688', '2026-03-01', false),
    ('7eb157d6-fe31-4bec-b284-b4e84b7aebe6', 'f064bdff-88b2-41f9-bcf8-606f5127d960', '6689dff6-2459-419f-b492-246f279a7688', '2026-03-08', true)
ON CONFLICT DO NOTHING;
