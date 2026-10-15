# Sprint 2 — SGA-Func

Abra `apresentacao-sprint-2.html` no navegador para apresentar os slides com setas do teclado; use a impressão do navegador para exportar como PDF. Este documento contém as notas detalhadas.

## Slide 1 — Objetivo

Gestão de estudantes e cursos com CRUD persistido em PostgreSQL, controle de acesso por perfil e consultas funcionais em Haskell/IHP.

## Slide 2 — Modelo

- Estudantes são os registros `alunos` já existentes: nome, matrícula única, e-mail e curso opcional.
- Cursos são uma nova entidade: nome, código único e carga horária. Cursos são diferentes das disciplinas já usadas pelos relatórios.
- Um curso tem vários estudantes; um estudante pode estar sem curso ou vinculado a um curso.
- Os dados e relatórios anteriores continuam disponíveis após login.

## Slide 3 — CRUD

- Criar: formulário validado antes da persistência.
- Ler: listagem com busca e página de detalhes.
- Atualizar: formulário preenchido com os dados atuais, inclusive vínculo de curso.
- Excluir: confirmação, autorização no servidor e proteção de vínculos acadêmicos.

## Slide 4 — Acesso

Autenticação por sessão IHP, senha com hash e bloqueio temporário após tentativas de login incorretas.

| Perfil | Listar / detalhes / relatórios | Criar / editar / excluir |
| --- | --- | --- |
| Visitante | Redirecionado ao login | Redirecionado ao login |
| Consulta | Permitido | HTTP 403 |
| Admin | Permitido | Permitido |

As verificações ficam nos controllers. Ocultar botões é apenas uma conveniência visual; acessar diretamente a URL não contorna as regras. Contas são provisionadas por script local, sem cadastro público nem escolha de role pela interface.

## Slide 5 — Integridade

Validações de formulário e constraints PostgreSQL implementam o contrato desta aplicação HTML (não há endpoint JSON nesta entrega):

- Nome: 2–150 caracteres após remoção de espaços externos.
- Matrícula: 4–20 dígitos, única.
- E-mail: obrigatório, até 254 caracteres, com domínio completo.
- Código: 2–20 letras maiúsculas, dígitos e hífen, iniciando com letra ou dígito; único. A entrada é normalizada para maiúsculas.
- Carga horária: inteiro de 1 a 10000.
- Role: somente `admin` e `consulta`.
- Curso inexistente é rejeitado por chave estrangeira.
- Curso com estudantes não pode ser excluído. Estudante com notas ou frequências também não pode ser excluído. Nenhuma exclusão apaga o histórico em cascata.

As constraints também protegem inserções fora da interface e conflitos entre requisições concorrentes.

## Slide 6 — Consultas funcionais

Código: `Application/Domain/Catalog.hs`. Os controllers buscam registros pelos modelos tipados do IHP; a transformação dos resultados fica em funções puras usadas nas páginas.

| Operação | Função | Resultado visível |
| --- | --- | --- |
| `filter` | `buscarAlunos`, `buscarCursos` | Busca sem diferenciar maiúsculas/minúsculas |
| `map` | `resumoCursos` | Projeção de cada curso com seu total |
| `foldr` (reduce) | `resumoCursos` | Contagem de estudantes vinculados |
| `concatMap` (flatMap) | `estudantesPorCurso` | Lista única de pares curso/estudante |

Listas vazias retornam lista vazia ou total zero. Estudantes sem curso não são contabilizados como vinculados. Para o volume acadêmico atual, a busca usa listas em memória; grandes bases exigiriam paginação e filtragem no banco.

## Slide 7 — Demo (6–8 minutos)

Siga `docs/sprint-2-demo.md`. Demonstre o CRUD, uma validação inválida, a proteção de exclusão e a tentativa de escrita com o perfil consulta. Termine mostrando as quatro operações funcionais e o resultado real da verificação.

## Slide 8 — Verificação

`nix flake check --impure` é o comando canônico. Os testes de domínio cobrem validação, permissões e transformações. Os de integração exercitam os controllers com banco temporário e constraints PostgreSQL. O comando também compila o servidor e o script de provisionamento. Registre a saída real; este roteiro não é evidência de que os testes passaram.
