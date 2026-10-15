module Web.Routes where
import IHP.RouterPrelude
import Generated.Types
import Web.Types

instance AutoRoute RelatoriosController

[routes|StaticController
GET /    WelcomeAction
|]

instance AutoRoute SessionsController
instance AutoRoute AlunosController
instance AutoRoute CursosController
