module Application.Helper.Controller where

import IHP.ControllerPrelude
import IHP.Hasql.FromRow (FromRowHasql)
import Generated.Types
import Web.Types
import qualified Application.Domain.Catalog as Catalog

requireRead :: (?request :: Request, ?respond :: Respond) => IO ()
requireRead = do
    ensureIsUser
    accessDeniedUnless (Catalog.canRead (get #role_ currentUser))

requireStaff :: (?request :: Request, ?respond :: Respond) => IO ()
requireStaff = do
    ensureIsUser
    accessDeniedUnless (Catalog.canReadStaff (get #role_ currentUser))

requireWrite :: (?request :: Request, ?respond :: Respond) => IO ()
requireWrite = do
    requireStaff
    accessDeniedUnless (Catalog.canWrite (get #role_ currentUser))

findOr404 :: (Table model, FromRowHasql model, Fetchable (Id' table) model, ?request :: Request, ?respond :: Respond, ?modelContext :: ModelContext) => Id' table -> IO model
findOr404 recordId = do
    record <- fetchOneOrNothing recordId
    case record of
        Nothing     -> earlyReturn renderNotFound
        Just record -> pure record
