module IdrisUnit

import Control.App

data TestResult = Fail String

HasErr TestResult es where

shouldBe : Has [Show, Eq] x => x -> x -> App es ()
a `shouldBe` b = do
    if a == b
        then pure ()
        else throw $ Fail $ show a ++ "!=" ++ show b
