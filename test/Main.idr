module Main

import Control.App
import Control.App.Console
import Control.App.Spec

import HelloSpec

main : IO ()
main = do
  run HelloSpec.spec
