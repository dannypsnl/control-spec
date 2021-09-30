module Main

import IdrisUnit
import Control.App
import Control.App.Console

test : Console es => App es ()
test = let s : HasErr TestError es2 => App es2 ()
           s = 1+1 `shouldBe` 2
       in it "1+1 = 2" s

main : IO ()
main = run test
