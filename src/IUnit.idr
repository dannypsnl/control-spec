module IUnit

import Control.App
import Control.App.Console

data TestError : Type where
  NotEq : Show x => x -> x -> TestError

Show TestError where
  show (NotEq a b) = show a ++ " != " ++ show b

||| ```
||| spec : Spec Init => App Init ()
||| spec = describe "example" $ do
|||     context "arith" $ do
|||         it "1+1 = 2" $ do
|||             1+1 `shouldBe` 2
|||         it "1*1 = 1" $ do
|||             1*1 `shouldBe` 1
||| ```
public export
interface Spec es where
  describe : String -> App {l} es () -> App {l} es ()
  context : String -> App {l} es () -> App {l} es ()
  it : String -> App {l=MayThrow} (TestError :: es) () -> App {l=MayThrow} es ()

export
Has [Console] es => Spec es where
  describe text toRun = putStrLn text *> toRun
  context text toRun = putStrLn text *> toRun
  it text toRun = do
    putStr $ "test: " ++ text
    handle toRun
      (\_ => putStrLn " passed")
      printError
    where
      printError : Has [Console] es' => TestError -> App es' ()
      printError err = putStrLn $ "failed: " ++ show err

||| ```
||| a `shouldBe` b
||| ```
export
shouldBe : HasErr TestError es => Has [Show, Eq] x => x -> x -> App es ()
a `shouldBe` b = if a == b
  then pure ()
  else throw $ NotEq a b
