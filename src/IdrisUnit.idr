module IdrisUnit

import Control.App
import Control.App.Console

public export
data TestError = Fail String

Show TestError where show (Fail message) = message

printError : Console es => TestError -> App es ()
printError err = putStrLn $ "failed: " ++ show err

||| Example
||| ```idris2 example
||| test : Console es => App es ()
||| test = let s : HasErr TestError es2 => App es2 ()
|||            s = 1+1 `shouldBe` 2
|||        in it "1+1 = 2" s
||| ```
export
it : Console es => String -> App (TestError :: es) () -> App es ()
it text toRun = handle toRun (\_ => pure ()) (\err => do
    putStrLn $ "test: " ++ text
    printError err)

export
shouldBe : HasErr TestError es => Has [Show, Eq] x => x -> x -> App es ()
a `shouldBe` b = do
    if a == b
        then pure ()
        else throw $ Fail $ show a ++ " != " ++ show b
