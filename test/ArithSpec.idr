module ArithSpec

import Control.App
import Control.App.Spec

public export
spec : Spec Init => App Init ()
spec = do
  describe "arith" $ do
    it "1+1 = 2" $ 1+1 `shouldBe` 2
    it "1*1 = 1" $ 1*1 `shouldBe` 1
