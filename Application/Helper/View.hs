module Application.Helper.View where

import IHP.ViewPrelude

-- Here you can add functions which are available in all your views
emptyMessage :: Bool -> Text -> Html
emptyMessage isEmpty message = when isEmpty [hsx|<p>{message}</p>|]
