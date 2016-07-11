{-# LANGUAGE TemplateHaskell #-}
module AppMain where

import Network.Wai.Handler.Warp (run)
import Yesod (toWaiApp)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE

import App (App(..))
import EnvVarLookup (envVarLookup, envVarLookupInt)

main :: IO ()
main = do
  waiApp <- toWaiApp App { connection = TE.encodeUtf8 . T.pack $ $(envVarLookup "APP_DATABASE") }
  run $(envVarLookupInt "APP_PORT") waiApp
