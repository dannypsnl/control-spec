module Main

import IdrisUnit
import Control.App
import Control.App.Console

spec : Console es => App es ()
spec = describe "example" $ do
    context "arith" $ do
        it "1+1 = 2" $ do
            1+1 `shouldBe` 2
        it "1*1 = 1" $ do
            1*1 `shouldBe` 1

main : IO ()
main = run spec
