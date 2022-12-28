module Control.App.Spec

import Control.App
import public Control.App.Console
import Data.String
import Text.PrettyPrint.Prettyprinter.Doc
import Text.PrettyPrint.Prettyprinter.Render.Terminal

data TestError : Type where
  NotEq : Show x => x -> x -> TestError

prettyTestError : TestError -> Doc ann
prettyTestError (NotEq a b) = hsep [pretty $ show a, "!=", pretty $ show b]

record SpecState where
  constructor MkState
  testName : List String
  fails : List (List String, TestError)

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
interface Has [State SpecState SpecState] e => Spec e where
  describe : String -> App e () -> App e ()
  context : String -> App e () -> App e ()
  it : String -> App (TestError :: e) () -> App e ()

restack : Spec e => String -> App e ()
restack text = do
  s <- get SpecState
  put SpecState $ { testName := [text] } s
stack : Spec e => String -> App e ()
stack text = do
  s <- get SpecState
  put SpecState $ { testName := s.testName ++ [text] } s

export
Has [State SpecState SpecState] e => Spec e where
  describe text toRun = restack text *> toRun
  context text toRun = stack text *> toRun
  it text toRun = do
    stack "test:"
    stack text
    handle toRun
      (\_ => pure ())
      (\err : TestError => do
        s <- get SpecState
        put SpecState $ { fails := (s.testName, err) :: s.fails } s
        )

export
emptyState : SpecState
emptyState = MkState [] []

export
specFinalReport : Has [PrimIO, Spec] e => App e ()
specFinalReport = do
  state <- get SpecState
  for_ state.fails $ \(stack, err) =>
    primIO $ putDoc $ annotate (color Red) $ vsep (map pretty stack) <++> prettyTestError err

||| ```
||| a `shouldBe` b
||| ```
export
shouldBe : HasErr TestError e => Has [Show, Eq] x => x -> x -> App e ()
a `shouldBe` b = if a == b
  then pure ()
  else throw $ NotEq a b
