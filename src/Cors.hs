{-# LANGUAGE OverloadedStrings #-}
module Cors where

import Network.Wai
import Network.HTTP.Types.Method (methodOptions)
import Network.HTTP.Types.Header (ResponseHeaders)
import Network.HTTP.Types.Status (status200)

enable :: Middleware
enable = corsHeadersAppender . optionsMethodResponder

optionsMethodResponder :: Middleware
optionsMethodResponder =
  ifRequest ((methodOptions ==) . requestMethod) $ \_application _req k ->
    k (responseLBS status200 [] "")

corsHeadersAppender :: Middleware
corsHeadersAppender =
  modifyResponse $ mapResponseHeaders (corsHeaders ++)

corsHeaders :: ResponseHeaders
corsHeaders =
  [ ("Access-Control-Allow-Origin", "*")
  , ("Access-Control-Allow-Methods", "GET, OPTIONS, POST, PUT, DELETE")
  , ("Access-Control-Allow-Headers", "Content-Type")
  ]
