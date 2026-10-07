module Web.Routes where
import IHP.RouterPrelude
import Generated.Types
import Web.Types

instance AutoRoute RelatoriosController

[routes|StaticController
GET /    WelcomeAction
|]
