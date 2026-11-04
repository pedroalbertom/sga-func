# Sprint 3 — SGA-Func: Tópicos Avançados & Segurança

Abra `docs/apresentacao-sprint-3.html` no navegador para exibir os slides com transição via teclado ou exportar para PDF usando a impressão do navegador.

---

## 🎯 Visão Geral dos Tópicos

Nesta Sprint 3, aprofundamos a aplicação prática dos conceitos avançados do paradigma funcional em Haskell e adicionamos proteções criptográficas para informações sensíveis no SGA-Func.

### 1. Functional Core & Isolamento de Efeitos (`IO`)
* Todo o núcleo de lógica reside em módulos puramente funcionais:
  * [`Application/Domain/Advanced.hs`](../Application/Domain/Advanced.hs)
  * [`Application/Domain/Security.hs`](../Application/Domain/Security.hs)
  * [`Application/Domain/Academic.hs`](../Application/Domain/Academic.hs)
* As funções do domínio não efetuam leitura/escrita em banco, requisições de rede ou mutações de estado no SO. A casca externa imperativa (`IO`) é estritamente confinada aos controllers do IHP.

### 2. Monads: Reader e Either
* **Monad Reader (`Reader AcademicConfig a`)**:
  * Permite consultar parâmetros institucionais (médias de corte, frequências mínimas, pesos de avaliação) sem passar argumentos extras por todas as funções e sem utilizar variáveis globais mutáveis.
  * Implementação canônica a partir de primeiros princípios (`newtype Reader r a = Reader { runReader :: r -> a }`).
* **Monad Either (`Either Text a`)**:
  * Utilizado na validação encadeada de matrículas e inscrições (estilo *Railway-Oriented Programming*).
  * No primeiro erro encontrado (ex.: e-mail malformado ou matrícula curta), o pipeline monádico `>>=` interrompe o fluxo retornando `Left mensagemErro`, evitando exceções em tempo de execução.

### 3. Functors Aplicados a Coleções e Tipos Customizados
* Instância de `Functor` criada para o tipo `ItemRelatorio a`, demonstrando `fmap` que transforma o valor interno preservando o rótulo da entidade.
* Operador `<$>` aplicado sobre coleções de notas para transformação em conceitos acadêmicos.

### 4. Continuation Passing Style (CPS)
* Implementado em `realizarMatriculaCPS`:
  * Em vez de retornar um valor diretamente, a função recebe duas continuações (`onSuccess` e `onFailure`).
  * Exemplifica o controle explícito da ordem e do fluxo de execução com funções de ordem superior.

### 5. Lazy Evaluation & Streams Infinitos
* Demonstração de avaliação preguiçosa com a função `geradorProtocolos :: Text -> [Text]`.
* Uma lista potencialmente infinita é gerada, e o operador `take n` consome apenas os elementos demandados sem exaurir recursos de memória.

### 6. Segurança e Criptografia
* **Hash de Senha**: Utiliza o algoritmo padrão do IHP (PBKDF2 com HMAC-SHA256 e salt randômico) armazenado na tabela `users`.
* **Criptografia Simétrica de Campos Confidenciais**:
  * O documento do aluno (CPF/RG) é cifrado no banco em formato hexadecimal via keystream cipher puro em [`Application/Domain/Security.hs`](../Application/Domain/Security.hs).
  * A view [`Web/View/Alunos.hs`](../Web/View/Alunos.hs) decifra o documento na tela caso o usuário autenticado seja `admin`.
  * Se o usuário for `consulta`, o documento é automaticamente mascarado (ex.: `**********9-00`).
