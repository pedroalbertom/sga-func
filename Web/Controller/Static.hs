module Web.Controller.Static where
import Web.Controller.Prelude
import Web.View.Static.Welcome
import qualified Data.Map.Strict as Map

instance Controller StaticController where
    action WelcomeAction = do
        turmas <- query @Turma |> fetch
        disciplinas <- query @Disciplina |> fetch
        let disciplinaMap = Map.fromList (map (\d -> (get #id d, d)) disciplinas)
        render WelcomeView { turmas, disciplinaMap }
