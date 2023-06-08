module Control.App.Spec

import System
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

push : Spec e => String -> App e ()
push text = do
  s <- get SpecState
  put SpecState $ { testName := text :: s.testName } s
pop : Spec e => App e ()
pop = do
  s <- get SpecState
  put SpecState $ { testName := drop 1 s.testName } s

export
Has [State SpecState SpecState] e => Spec e where
  describe text toRun = push text *> toRun *> pop
  context text toRun = push text *> toRun *> pop
  it text toRun = do
    push $ "test: " ++ text
    handle toRun
      (\_ => pop)
      (\err : TestError => do
        s <- get SpecState
        put SpecState $ { fails := (reverse s.testName, err) :: s.fails } s
        pop
        )

export
emptyState : SpecState
emptyState = MkState [] []

bold' : Doc AnsiStyle -> Doc AnsiStyle
bold' = annotate bold
color' : Color -> Doc AnsiStyle -> Doc AnsiStyle
color' = annotate . color

putContext : Has [PrimIO] e => Int -> List String -> App e ()
putContext n (c::ctx) = do
  primIO $ putDoc $ bold' $ indent n $ pretty c
  putContext (n+1) ctx
putContext n [] = pure ()

reportFails : Has [PrimIO, Spec] e => List (List String, TestError) -> App e ()
reportFails fails = do
  primIO $ putDoc $ bold' $ color' Red $
    pretty (length fails) <++> "tests failed"
  for_ fails $ \(contexts, err) => do
    putContext 0 contexts
    primIO $ putDoc $ bold' $ color' Red $ prettyTestError err
  primIO $ exitFailure

export
specFinalReport : Has [PrimIO, Spec] e => App e ()
specFinalReport = do
  state <- get SpecState
  case state.fails of
    [] => primIO $ putDoc $ bold' $ color' Green $ "all tests passed"
    _ => reportFails state.fails

||| ```
||| a `shouldBe` b
||| ```
export
shouldBe : HasErr TestError e => Has [Show, Eq] x => x -> x -> App e ()
a `shouldBe` b = if a == b
  then pure ()
  else throw $ NotEq a b
