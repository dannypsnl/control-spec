module HelloSpec

import public Control.App
import public Control.App.Spec

public export
spec : Spec Init => App Init ()
spec = do
  describe "example" $ do
    context "arith" $ do
      it "1+1 = 2" $ 1+1 `shouldBe` 2
      it "1*1 = 1" $ 1*1 `shouldBe` 3
