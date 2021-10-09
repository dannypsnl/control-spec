module IdrisUnit

import Control.App
import Control.App.Console
import Language.Reflection
%language ElabReflection

data TestError : Type where
    NotEq : Show x => x -> x -> TestError

Show TestError where
    show (NotEq a b) = show a ++ " != " ++ show b

||| ```
||| spec : Spec es => App es ()
||| spec = describe "example" $ do
|||     context "arith" $ do
|||         it "1+1 = 2" $ do
|||             1+1 `shouldBe` 2
|||         it "1*1 = 1" $ do
|||             1*1 `shouldBe` 1
||| ```
public export
interface Spec es where
  describe : String -> App es () -> App es ()
  context : String -> App es () -> App es ()
  it : String -> App (TestError :: es) () -> App es ()

export
Console es => Spec es where
  describe text toRun = do
    putStrLn text
    toRun
  context text toRun = do
    putStrLn text
    toRun
  it text toRun = handle toRun
    (\_ => pure ())
    (\err => do
        putStrLn $ "test: " ++ text
        printError err)
    where
        printError : Console es' => TestError -> App es' ()
        printError err = putStrLn $ "failed: " ++ show err

||| ```
||| a `shouldBe` b
||| ```
export
shouldBe : HasErr TestError es => Has [Show, Eq] x => x -> x -> App es ()
a `shouldBe` b = do
    if a == b
        then pure ()
        else throw $ NotEq a b
