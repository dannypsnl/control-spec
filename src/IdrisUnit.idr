module IdrisUnit

import Control.App

data TestError = Fail String

shouldBe : Exception TestError es => Has [Show, Eq] x => x -> x -> App es ()
a `shouldBe` b = do
    if a == b
        then pure ()
        else throw $ Fail $ show a ++ "!=" ++ show b
