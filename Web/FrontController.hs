module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Sessions
import Web.Controller.Alunos
import Web.Controller.Cursos
import Web.Controller.Static
import Web.Controller.Relatorios

instance FrontController WebApplication where
    controllers = 
        [ startPage WelcomeAction
        , parseRoute @SessionsController
        , parseRoute @AlunosController
        , parseRoute @CursosController
        , parseRoute @RelatoriosController
        -- Generator Marker
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
