{-# LANGUAGE OverloadedStrings #-}
module CorsSpec where

import Network.Wai
import Network.HTTP.Types.Status (status200)
import Test.Hspec
import Test.Hspec.Wai

import qualified Cors

app :: Application
app = Cors.enable $ \_req k -> k $ responseLBS status200 [("X", "Y")] "Z"

spec :: Spec
spec = with (return app) $ do
  describe "OPTIONS" $ do
    it "immidiately responds with cors headers without body" $ do
      options "/" `shouldRespondWith` ""
  describe "Other methods" $ do
    it "appends cors headers with original app's reponse" $ do
      get "/" `shouldRespondWith` "Z"
