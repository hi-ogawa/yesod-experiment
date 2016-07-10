{-# LANGUAGE TemplateHaskell #-}
import Network.Wai.Handler.Warp (run)
import App (app)
import EnvVarLookup (envVarLookupInt)

main :: IO ()
main = run $(envVarLookupInt "APP_PORT") =<< app
