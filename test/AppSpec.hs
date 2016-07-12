{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
module AppSpec where

import Control.Monad.Logger (NoLoggingT, runNoLoggingT)
import Control.Monad.Trans.Reader (ReaderT)
import Data.Aeson
import qualified Data.ByteString.Lazy as B
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import Database.Persist.Sql (runSqlConn, SqlBackend)
import Database.Persist.Postgresql (withPostgresqlConn)
import Network.Wai.Test (SResponse(..))
import Test.Hspec
import Yesod hiding (get, runDB)
import qualified Yesod as Y (get)
import Yesod.Test

import App (App(..), Route(PeopleR, PersonR, StatusR))
import Models (Person(..))
import EnvVarLookup (envVarLookup)

spec :: Spec
spec = withApp yspec

app :: App
app = App { connection = TE.encodeUtf8 . T.pack $ $(envVarLookup "APP_DATABASE") }

type SqlT = ReaderT SqlBackend (NoLoggingT IO)

runDBIO :: SqlT a -> IO a
runDBIO = runNoLoggingT . withPostgresqlConn (connection app) . runSqlConn

withApp :: YesodSpec App -> Spec
withApp = before_ wipeDB . yesodSpec app
  where
    wipeDB :: IO ()
    wipeDB = runDBIO $ do
      deleteWhere [FilterAnd [] :: Filter Person] :: SqlT ()

yspec :: YesodSpec App
yspec = do
  ydescribe "GET /" $ do
    yit "." $ do
      get StatusR
      statusIs 200
      jsonResp >>= (`shouldBe'` object [("status", "ok")])
  let p0 = Person "hiogawa" (Just 25)
      p1 = Person "johnsnow" Nothing
  ydescribe "GET /people" $ do
    yit "." $ do
      runDB $ insertMany [p0, p1]
      get PeopleR
      statusIs 200
      jsonResp >>= (`shouldBe'` [p0, p1])

  ydescribe "POST /people" $ do
    yit "." $ do
      postBody PeopleR $ encode p0
      statusIs 200
      jsonResp >>= (`shouldBe'` p0)
      (entityKey <$> jsonResp) >>= runDB . Y.get >>= (`shouldBe'` Just p0)

  ydescribe "GET /people/#PersonId" $ do
    yit "." $ do
      [pid0, _] <- runDB $ insertMany [p0, p1]
      get $ PersonR pid0
      statusIs 200
      jsonResp >>= (`shouldBe'` p0)

  ydescribe "PUT /people/#PersonId" $ do
    yit "." $ do
      pid0 <- runDB $ insert p0
      putBody (PersonR pid0) $ encode p1
      statusIs 200
      jsonResp >>= (`shouldBe'` p1)

  ydescribe "DELETE /people/#PersonId" $ do
    yit "." $ do
      pid0 <- runDB $ insert p0
      deleteReq $ PersonR pid0
      statusIs 200
      jsonResp >>= (`shouldBe'` object [("status", "ok")])

  where
    runDB :: SqlT a -> YesodExample App a
    runDB = liftIO . runDBIO

    putBody :: (Yesod site, RedirectUrl site url) => url -> B.ByteString -> YesodExample site ()
    putBody url bdy = request $ do
      setMethod "PUT"
      setUrl url
      setRequestBody bdy

    deleteReq :: (Yesod site, RedirectUrl site url) => url -> YesodExample site ()
    deleteReq url = request $ setMethod "DELETE" >> setUrl url

    jsonResp :: FromJSON a => YesodExample App a
    jsonResp = do
      mybSResp <- getResponse
      case mybSResp of
        Nothing -> fail "no response body"
        Just (SResponse _ _ bdy) -> do
          case eitherDecode bdy of
            Left msg -> fail msg
            Right dat -> return dat

    -- for better failing msg
    shouldBe' :: (Eq a, Show a) => a -> a -> YesodExample App ()
    shouldBe' x y = lift $ x `shouldBe` y
