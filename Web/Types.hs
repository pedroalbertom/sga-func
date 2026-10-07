module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController = WelcomeAction deriving (Eq, Show, Data)

data RelatoriosController
    = DesempenhoAction { turmaId :: !(Id Turma) }
    | FrequenciaAction { turmaId :: !(Id Turma) }
    | RankingAction
    deriving (Eq, Show, Data)
