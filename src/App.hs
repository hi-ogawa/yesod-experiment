{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE ViewPatterns          #-}
module App (app, Widget, resourcesApp) where

import Control.Monad.Trans.Reader (runReaderT)
import Database.Persist.Sql.Types.Internal (SqlBackend)
import Database.Persist.Postgresql (withPostgresqlConn)
import Yesod

import Models
import EnvVarLookup (envVarLookup)

---------------
-- Yesod app --

data App = App
instance Yesod App
instance YesodPersist App where
  type YesodPersistBackend App = SqlBackend
  runDB action = withPostgresqlConn $(envVarLookup "APP_DATABASE") (runReaderT action)


---------------
-- route DSL --

mkYesod "App" [parseRoutes|
/people PeopleR GET POST
/people/#PersonId PersonR GET PUT DELETE
|]


--------------
-- handlers --

getPeopleR :: Handler Value
getPeopleR = runDB $ do
  toJSON <$> (selectList [] [] :: YesodDB App [Entity Person])

postPeopleR :: Handler Value
postPeopleR = runDB $ do
  person <- requireJsonBody :: YesodDB App Person
  personId <- insert person
  return . toJSON $ Entity personId person

getPersonR :: PersonId -> Handler Value
getPersonR personId = runDB $ do
  mybPerson <- get personId
  case mybPerson of
    Nothing -> notFound
    Just person -> return . toJSON $ Entity personId person

putPersonR :: PersonId -> Handler Value
putPersonR personId = runDB $ do
  person <- requireJsonBody :: YesodDB App Person
  replace personId person
  return . toJSON $ Entity personId person

deletePersonR :: PersonId -> Handler Value
deletePersonR personId = runDB $ do
  delete personId
  return . toJSON $ object [("status", "ok")]


---------------------
-- WAI application --

app :: IO Application
app = toWaiApp App
