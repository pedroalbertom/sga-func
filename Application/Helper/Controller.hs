module Application.Helper.Controller where

import IHP.ControllerPrelude
import Generated.Types
import Web.Types
import qualified Application.Domain.Catalog as Catalog

requireRead :: (?request :: Request, ?respond :: Respond) => IO ()
requireRead = do
    ensureIsUser
    accessDeniedUnless (Catalog.canRead (get #role_ currentUser))

requireWrite :: (?request :: Request, ?respond :: Respond) => IO ()
requireWrite = do
    requireRead
    accessDeniedUnless (Catalog.canWrite (get #role_ currentUser))
