module Web.View.Layout (defaultLayout, Html) where

import IHP.ViewPrelude
import IHP.Environment
import Generated.Types
import Web.Types
import Web.Routes
import Application.Helper.View

defaultLayout :: Html -> Html
defaultLayout inner = [hsx|
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        {metaTags}

        {stylesheets}
        {scripts}

        <title>{pageTitleOrDefault "SGA-Func"}</title>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
            <div class="container">
                <a class="navbar-brand fw-bold text-white" href="/">🎓 SGA-Func</a>
                <div class="navbar-nav ms-auto">
                    <a class="nav-link" href="/">Início (Turmas)</a>
                    <a class="nav-link" href={AlunosAction}>Estudantes</a>
                    <a class="nav-link" href={CursosAction}>Cursos</a>
                    <a class="nav-link" href={RankingAction}>Ranking Geral</a>
                    {sessionNavigation}
                </div>
            </div>
        </nav>
        <div class="container">
            {renderFlashMessages}
            {inner}
        </div>
    </body>
</html>
|]

-- The 'assetPath' function used below appends a `?v=SOME_VERSION` to the static assets in production
-- This is useful to avoid users having old CSS and JS files in their browser cache once a new version is deployed
-- See https://ihp.digitallyinduced.com/Guide/assets.html for more details

stylesheets :: Html
stylesheets = [hsx|
        <link rel="stylesheet" href={assetPath "/vendor/bootstrap-5.3.8/bootstrap.min.css"}/>
        <link rel="stylesheet" href={assetPath "/vendor/flatpickr.min.css"}/>
        <link rel="stylesheet" href={assetPath "/app.css"}/>
    |]

scripts :: Html
scripts = [hsx|
        {when isDevelopment devScripts}
        <script src={assetPath "/vendor/jquery-4.0.0.slim.min.js"}></script>
        <script src={assetPath "/vendor/timeago.js"}></script>
        <script src={assetPath "/vendor/popper-2.11.6.min.js"}></script>
        <script src={assetPath "/vendor/bootstrap-5.3.8/bootstrap.min.js"}></script>
        <script src={assetPath "/vendor/flatpickr.js"}></script>
        <script src={assetPath "/vendor/morphdom-umd.min.js"}></script>
        <script src={assetPath "/vendor/turbolinks.js"}></script>
        <script src={assetPath "/vendor/turbolinksInstantClick.js"}></script>
        <script src={assetPath "/vendor/turbolinksMorphdom.js"}></script>
        <script src={assetPath "/helpers.js"}></script>
        <script src={assetPath "/ihp-auto-refresh.js"}></script>
        <script src={assetPath "/app.js"}></script>
    |]

devScripts :: Html
devScripts = [hsx|
        <script id="livereload-script" src={assetPath "/livereload.js"} data-ws={liveReloadWebsocketUrl}></script>
    |]

metaTags :: Html
metaTags = [hsx|
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta property="og:title" content="App"/>
    <meta property="og:type" content="website"/>
    <meta property="og:url" content="TODO"/>
    <meta property="og:description" content="TODO"/>
    {autoRefreshMeta}
|]

sessionNavigation :: Html
sessionNavigation = case currentUserOrNothing of
    Nothing -> [hsx|<a class="nav-link" href={NewSessionAction}>Entrar</a>|]
    Just user -> [hsx|
        <span class="navbar-text mx-2">{get #email user} ({get #role_ user})</span>
        <a class="nav-link js-delete js-delete-no-confirm" href={DeleteSessionAction}>Sair</a>
    |]
