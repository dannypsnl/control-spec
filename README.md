# Control Spec

The project is a unit test framework for [idris2](https://idris2.readthedocs.io/en/latest/index.html), it follows the [app structure](https://idris2.readthedocs.io/en/latest/app/interfaces.html).

### Installation

```shell
git clone git@github.com:dannypsnl/control-spec.git
cd control-spec && pack install control-spec
# discover
pack install-app control-spec
export PATH=${HOME}/.pack/bin
```

### Usage

You can write a `Spec` as below in a file named `test/src/XxxSpec.idr`

```idris
import Control.App
import Control.App.Spec

export
spec : Spec e => App e ()
spec = describe "example" $ do
  context "arith" $ do
    it "1+1 = 2" $ 1+1 `shouldBe` 2
    it "1*1 = 1" $ 1*1 `shouldBe` 1
```

Then use `spec-discover` to generate all tests runner!

```shell
spec-discover test/
idris2 --build test/test.ipkg
./test/build/exec/runAllTests
```

You might want to ignore `test/src/Main.idr` and `test/test.ipkg`. If you are using [pack](https://github.com/stefan-hoeck/idris2-pack#quick-installation), then you can just use below command to make it work!

```shell
pack test <your-package>
```
