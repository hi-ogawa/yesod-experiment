{-# LANGUAGE OverloadedStrings #-}
module HerokuPgSpec where

import HerokuPg
import Test.Hspec

spec :: Spec
spec =
  describe "herokuPg2libPq" $ it "converts postgres connection representation" $
    let input = "postgres://bvlmfzdqmfzdre:-XsjFL_1r99ehBdyHJ_A8uZeky@ec2-54-235-120-32.compute-1.amazonaws.com:5432/dd93rragh0r1ob"
        output = "host='ec2-54-235-120-32.compute-1.amazonaws.com' port=5432 user='bvlmfzdqmfzdre' password='-XsjFL_1r99ehBdyHJ_A8uZeky' dbname='dd93rragh0r1ob'"
    in
    herokuPg2libPq input `shouldBe` output
