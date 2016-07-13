{-# LANGUAGE TemplateHaskell #-}
module AppMain where

import Network.Wai.Handler.Warp (run)
import Yesod (toWaiApp)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import System.Environment (lookupEnv)

import App (App(..))
import qualified Cors (enable)

main :: IO ()
main = do
  Just port <- lookupEnv "PORT"
  Just conn <- lookupEnv "APP_DATABASE"
  run (read port) . Cors.enable =<< toWaiApp App { connection = TE.encodeUtf8 . T.pack $ conn }
