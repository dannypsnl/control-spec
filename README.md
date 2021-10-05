# IdrisUnit

```shell
git clone https://github.com/dannypsnl/idris-unit.git
cd idris-unit && idris2 --install package.ipkg
```

### Usage

```idris
spec : Console es => App es ()
spec = describe "example" $ do
    context "arith" $ do
        it "1+1 = 2" $ do
            1+1 `shouldBe` 2
        it "1*1 = 1" $ do
            1*1 `shouldBe` 1
```
