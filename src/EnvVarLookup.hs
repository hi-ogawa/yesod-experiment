{-# LANGUAGE TemplateHaskell #-}
module EnvVarLookup (envVarLookup, envVarLookupInt) where

import System.Environment (lookupEnv)
import qualified Data.Text as T
import qualified Data.Text.Read as TR

import qualified Language.Haskell.TH as TH
import qualified Language.Haskell.TH.Syntax as THS

envVarLookup :: String -> TH.ExpQ
envVarLookup var = do
  myb <- TH.runIO $ lookupEnv var
  case myb of
    Nothing -> fail $ "envVarLookup: no value set for " ++ var
    Just val -> THS.lift val

envVarLookupInt :: String -> TH.ExpQ
envVarLookupInt var = do
  myb <- TH.runIO $ lookupEnv var
  case myb of
    Nothing -> fail $ "envVarLookup: no value set for " ++ var
    Just val -> do
      case TR.decimal (T.pack val) of
        Left msg -> fail $ "envVarLookup: " ++ msg ++ " is not a number"
        Right (i, _) -> THS.lift (i :: Int)
