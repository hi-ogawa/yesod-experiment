module HerokuPg where

import Network.URI hiding (path)
import Data.ByteString (ByteString)
import Database.PostgreSQL.Simple

herokuPg2libPq :: String -> ByteString
herokuPg2libPq url =
  let Just (URI _ (Just (URIAuth userWithPassword host port)) path _ _) = parseURI url
      (user, password) = break (':' ==) userWithPassword -- "user:password@"
      password' = tail . init $ password
      port' = read $ drop 1 port                         -- ":5432" -> 5432
      database = drop 1 path                             -- "/database"
  in
  postgreSQLConnectionString $
    ConnectInfo
    { connectHost = host
    , connectPort = port'
    , connectUser = user
    , connectPassword = password'
    , connectDatabase = database
    }
