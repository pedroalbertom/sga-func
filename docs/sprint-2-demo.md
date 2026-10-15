# Preparação e demo — Sprint 2

## Preparação

1. No ambiente Nix do projeto, execute `./start`. Aplique a nova migration pelo painel IHP em `http://localhost:8001` antes de abrir o CRUD em uma base existente. Em uma base nova, use o fluxo de criação/rebuild do banco do IHP a partir de `Application/Schema.sql`.
2. Provisione duas contas em outro terminal dentro do ambiente do projeto, conectado à mesma base. Não há senhas padrão nem usuários adicionados às fixtures:

   ```bash
   export SGA_USER_EMAIL='admin@example.com'
   export SGA_USER_ROLE='admin'
   read -rsp 'Senha (mínimo 12 caracteres): ' SGA_USER_PASSWORD
   echo
   export SGA_USER_PASSWORD
   run-script Application/Script/CreateUser.hs
   unset SGA_USER_PASSWORD

   export SGA_USER_EMAIL='consulta@example.com'
   export SGA_USER_ROLE='consulta'
   read -rsp 'Senha (mínimo 12 caracteres): ' SGA_USER_PASSWORD
   echo
   export SGA_USER_PASSWORD
   run-script Application/Script/CreateUser.hs
   unset SGA_USER_PASSWORD SGA_USER_EMAIL SGA_USER_ROLE
   ```

3. Execute `nix flake check --impure`. Guarde o resultado real para a apresentação.
4. Abra `http://localhost:8000/NewSession` e entre como administrador.

## Demonstração

| Passo | Ação | Resultado esperado |
| --- | --- | --- |
| 1 | Cursos → Novo curso: `Curso Demo`, `DEMO-2`, `60` | Detalhes do curso persistido |
| 2 | Tentar criar outro curso com código `DEMO-2` | Erro no formulário, sem duplicação |
| 3 | Tentar carga horária zero ou nome vazio | Erro no formulário |
| 4 | Estudantes → Novo estudante: `Ana Demo`, `20269998`, `ana.demo@example.com`, curso `Curso Demo` | Detalhes com vínculo ao curso |
| 5 | Buscar `ANA DEMO` na listagem de estudantes | Estudante localizado por `filter` |
| 6 | Abrir Cursos | Total de estudantes (`map` + `foldr`) e lista por curso (`concatMap`) |
| 7 | Editar o curso: nome `Curso Demo Atualizado`, carga `120` | Detalhes atualizados |
| 8 | Editar a estudante: nome `Ana Demo Atualizada` e e-mail novo | Dados atualizados ao recarregar |
| 9 | Tentar excluir o curso | Mensagem de vínculo; curso e estudante permanecem |
| 10 | Anotar a URL de edição da estudante. Sair e entrar como consulta | Listagem e detalhes acessíveis; botões de escrita ausentes |
| 11 | Abrir a URL de edição anotada ou `/NewCurso` | HTTP 403; sem acesso ao formulário |
| 12 | Sair e entrar como admin. Excluir a estudante da demo, depois o curso | Ambos removidos; busca deixa de encontrá-los |
| 13 | Tentar excluir um estudante das fixtures com notas/frequências | Histórico preservado e exclusão recusada |
| 14 | Sair e acessar `/Alunos` | Redirecionamento ao login |

Para repetir a apresentação, use matrícula e código ainda disponíveis ou exclua apenas os dados criados na demo. As fixtures acadêmicas existentes não precisam ser apagadas.

## Evidência para mostrar

Abra `Application/Domain/Catalog.hs` nas quatro transformações, `Application/Helper/Controller.hs` nas regras de acesso, `Application/Schema.sql` nas constraints e `Test/Integration.hs` no fluxo completo de CRUD com autorização. Registre separadamente testes automatizados e a execução manual desta demo.
