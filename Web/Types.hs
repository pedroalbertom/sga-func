module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController = WelcomeAction deriving (Eq, Show, Data)

data RelatoriosController
    = DesempenhoAction { turmaId :: !(Id Turma) }
    | FrequenciaAction { turmaId :: !(Id Turma) }
    | RankingAction
    deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data SessionsController = NewSessionAction | CreateSessionAction | DeleteSessionAction
    deriving (Eq, Show, Data)

data AlunosController
    = AlunosAction
    | NewAlunoAction
    | ShowAlunoAction { alunoId :: !(Id Aluno) }
    | CreateAlunoAction
    | EditAlunoAction { alunoId :: !(Id Aluno) }
    | UpdateAlunoAction { alunoId :: !(Id Aluno) }
    | DeleteAlunoAction { alunoId :: !(Id Aluno) }
    deriving (Eq, Show, Data)

data CursosController
    = CursosAction
    | NewCursoAction
    | ShowCursoAction { cursoId :: !(Id Curso) }
    | CreateCursoAction
    | EditCursoAction { cursoId :: !(Id Curso) }
    | UpdateCursoAction { cursoId :: !(Id Curso) }
    | DeleteCursoAction { cursoId :: !(Id Curso) }
    deriving (Eq, Show, Data)
