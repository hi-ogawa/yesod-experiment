{-# LANGUAGE TemplateHaskell #-}
module AppMain where

import Network.Wai.Handler.Warp (run)
import Yesod (toWaiApp)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import System.Environment (lookupEnv)
import Data.Maybe (fromJust)

import App (App(..))
import EnvVarLookup (envVarLookup)


main :: IO ()
main = do
  waiApp <- toWaiApp App { connection = TE.encodeUtf8 . T.pack $ $(envVarLookup "APP_DATABASE") }
  -- NOTE: need to recognize port number runtime for Heroku deployment :(
  flip run waiApp =<< read . fromJust <$> lookupEnv "PORT"
