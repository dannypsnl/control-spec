module Main

import IUnit
import Control.App
import Control.App.Console
import HelloSpec

main : IO ()
main = do
  run HelloSpec.spec
