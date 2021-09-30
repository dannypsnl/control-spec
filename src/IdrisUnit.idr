module IdrisUnit

import Control.App
import Control.App.Console

public export
data TestError = Fail String

Show TestError where show (Fail message) = message

printError : Console es => TestError -> App es ()
printError err = putStrLn $ "failed: " ++ show err

export
it : Console es => String -> App (TestError :: es) () -> App es ()
it text toRun = do
    putStrLn text
    handle toRun (\_ => pure ()) printError

export
shouldBe : HasErr TestError es => Has [Show, Eq] x => x -> x -> App es ()
a `shouldBe` b = do
    if a == b
        then pure ()
        else throw $ Fail $ show a ++ " != " ++ show b
