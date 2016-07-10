{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE FlexibleInstances          #-}
module Models where

import Data.Aeson
import Database.Persist
import Database.Persist.TH (share, mkPersist, sqlSettings, mkMigrate, persistLowerCase)
import Database.Persist.Postgresql

share [mkPersist sqlSettings, mkMigrate "schema"] [persistLowerCase|
Person
    name String
    age Int Maybe
    deriving Show
|]

instance ToJSON Person where
  toJSON (Person name age) = object ["name" .= name, "age" .= age]

instance FromJSON Person where
  parseJSON (Object v) = Person <$> v .: "name" <*> v .: "age"

-- Entity seriailzes id, name, age
instance ToJSON (Entity Person) where
  toJSON = entityIdToJSON

-- debug print database schema
printSchema :: IO ()
printSchema = mockMigration schema
