# IdrisUnit

```shell
git clone https://github.com/dannypsnl/idris-unit.git
cd idris-unit && idris2 --install package.ipkg
```

### Usage

```idris
test : Console es => App es ()
test = let s : HasErr TestError es2 => App es2 ()
           s = 1+1 `shouldBe` 2
       in it "1+1 = 2" s
```
