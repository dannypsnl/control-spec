module IdrisUnit

import Control.App
import Control.App.Console
import Language.Reflection
%language ElabReflection

public export
data TestError = Fail String

Show TestError where show (Fail message) = message

export
context : Console es => String -> App es () -> App es ()
context text toRun = do
    putStrLn text
    toRun

||| Example
||| ```idris2 example
||| test : Console es => App es ()
||| test = it "1+1 = 2" $ do
|||    1+1 `shouldBe` 2
||| ```
export
it : Console es => String -> App (TestError :: es) () -> App es ()
it text toRun = handle toRun
    (\_ => pure ())
    (\err => do
        putStrLn $ "test: " ++ text
        printError err)
    where
        printError : Console es' => TestError -> App es' ()
        printError err = putStrLn $ "failed: " ++ show err

export
shouldBe : HasErr TestError es => Has [Show, Eq] x => x -> x -> App es ()
a `shouldBe` b = do
    if a == b
        then pure ()
        else throw $ Fail $ show a ++ " != " ++ show b
