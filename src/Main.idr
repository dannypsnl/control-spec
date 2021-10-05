module Main

import IdrisUnit
import Control.App
import Control.App.Console

test : Console es => App es ()
test = it "1+1 = 2" $ do
  1+1 `shouldBe` 2

main : IO ()
main = do
    run test
