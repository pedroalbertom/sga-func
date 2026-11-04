# Roteiro da Demonstração Prática — Sprint 3 (SGA-Func)

Este roteiro guia a apresentação ao vivo para o professor, destacando cada tópico avançado implementado no código e na interface web.

---

## ⏱️ Roteiro de Demonstração (5 a 7 minutos)

### 1. Testes Unitários dos Tópicos Avançados (1 a 2 min)
* Abra o terminal e execute os testes unitários do HSpec:
  ```bash
  # Executa todos os testes unitários incluindo Sprint 3
  nix flake check --impure
  ```
* Mostre a saída do teste apontando para os blocos no arquivo [`Test/AdvancedSpec.hs`](../Test/AdvancedSpec.hs):
  * **Monad Reader**: cálculo e avaliação usando réguas da configuração.
  * **Monad Either**: validação monádica em pipeline de inscrição de estudante.
  * **Functors**: aplicação de `fmap` sobre `ItemRelatorio`.
  * **CPS**: chamada das continuações `onSuccess` e `onFailure` no fluxo de matrícula.
  * **Lazy Evaluation**: consumo com `take 3` sobre stream infinito de protocolos.

---

### 2. Demonstração de Segurança & Criptografia na Interface Web (3 min)
1. **Iniciar a aplicação**:
   ```bash
   ./start
   ```
2. **Login como Administrador**:
   * Acesse `http://localhost:8000/NewSession`.
   * Credenciais: `admin@example.com` / `senha-de-teste-123`.
   * Acesse o menu **Estudantes** (`/Alunos`).
   * Abra os detalhes da aluna **Alice Silva**.
   * Mostre o campo **Documento Confidencial**: exibe `123.456.789-00` com a badge verde `[ Descriptografado (Admin) ]`.
3. **Novo Cadastro com Criptografia**:
   * Clique em **Novo estudante**.
   * Preencha os campos obrigatórios e adicione um documento confidencial no input (ex: `987.654.321-99`).
   * Salve o estudante e confirme a visualização descriptografada.
4. **Login como Usuário de Consulta**:
   * Clique em **Sair** no menu superior.
   * Faça login com `consulta@example.com` / `senha-de-teste-123`.
   * Acesse os detalhes do estudante cadastrado.
   * Mostre que o perfil de consulta visualiza apenas o valor **mascarado** (ex.: `**********1-99`) com badge cinza `[ Mascarado (Consulta) ]`, garantindo privacidade de ponta a ponta.

---

### 3. Explicação no Código (1 a 2 min)
* Abra [`Application/Domain/Advanced.hs`](../Application/Domain/Advanced.hs):
  * Aponte para a definição de `newtype Reader r a` e as funções `ask`/`asks`.
  * Mostre a função `realizarMatriculaCPS` com suas continuações explicitadas nos parâmetros.
  * Mostre o gerador infinito `[ prefixo <> "-" <> show n | n <- [1000..] ]` consumido via `take`.
* Abra [`Application/Domain/Security.hs`](../Application/Domain/Security.hs):
  * Mostre a função `criptografarTexto` e `descriptografarTexto` utilizando operações puras com `xor` e codificação hexadecimal.
