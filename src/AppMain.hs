{-# LANGUAGE TemplateHaskell #-}
module AppMain where

import Network.Wai.Handler.Warp (run)
import Yesod (toWaiApp)
import System.Environment (lookupEnv)

import App (App(..))
import qualified Cors (enable)
import HerokuPg (herokuPg2libPq)

main :: IO ()
main = do
  Just port <- lookupEnv "PORT"
  Just conn <- lookupEnv "DATABASE_URL"
  run (read port) . Cors.enable =<< toWaiApp App { connection = herokuPg2libPq conn }
