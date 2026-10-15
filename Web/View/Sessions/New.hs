module Web.View.Sessions.New where

import Web.View.Prelude
import IHP.AuthSupport.View.Sessions.New

instance View (NewView User) where
    html NewView { .. } = [hsx|
        <div class="card mx-auto p-4" style="max-width: 440px">
            <h1 class="h3">Entrar no SGA-Func</h1>
            <p>Use sua conta de administrador ou consulta.</p>
            <form method="POST" action={CreateSessionAction}>
                <label for="login-email" class="form-label">E-mail</label>
                <input id="login-email" name="email" type="email" value={get #email user} class="form-control mb-3" required="required" autocomplete="username"/>
                <label for="login-password" class="form-label">Senha</label>
                <input id="login-password" name="password" type="password" class="form-control mb-3" required="required" autocomplete="current-password"/>
                <button class="btn btn-primary" type="submit">Entrar</button>
            </form>
        </div>
    |]
