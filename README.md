# Control Spec

The project is a unit test framework for [idris2](https://idris2.readthedocs.io/en/latest/index.html), it follows the [app structure](https://idris2.readthedocs.io/en/latest/app/interfaces.html).

### Installation

```shell
git clone git@github.com:dannypsnl/control-spec.git
cd control-spec && make install
```

### Usage

```idris
import Control.App
import Control.App.Console
import Control.App.Spec

spec : Spec Init => App Init ()
spec = describe "example" $ do
  context "arith" $ do
    it "1+1 = 2" $ 1+1 `shouldBe` 2
    it "1*1 = 1" $ 1*1 `shouldBe` 1
```
