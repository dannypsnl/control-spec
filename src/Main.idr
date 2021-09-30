module Main

import IdrisUnit
import Control.App
import Control.App.Console

s : HasErr TestError es => App es ()
s = 1 `shouldBe` 2

test : Console es => App es ()
test = it "test" s

main : IO ()
main = run test
