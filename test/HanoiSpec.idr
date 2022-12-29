module HanoiSpec

import public Control.App
import public Control.App.Spec

hanoi : Int -> a -> a -> a -> List (a, a)
hanoi 0 a b c = []
hanoi 1 a b c = [(a, c)]
hanoi n a b c = hanoi (n-1) a c b ++ [(a, c)] ++ hanoi (n-1) b a c

public export
spec : Spec Init => App Init ()
spec = do
  describe "hanoi" $ do
    it "3 level" $ do
      hanoi 3 'A' 'B' 'C' `shouldBe` [('A', 'C'), ('A', 'B'), ('C', 'B'), ('A', 'C'), ('B', 'A'), ('B', 'C'), ('A', 'C')]
    it "4 level" $ do
      hanoi 4 'A' 'B' 'C' `shouldBe` [('A', 'B'), ('A', 'C'), ('B', 'C'), ('A', 'B'), ('C', 'A'), ('C', 'B'), ('A', 'B'), ('A', 'C'), ('B', 'C'), ('B', 'A'), ('C', 'A'), ('B', 'C'), ('A', 'B'), ('A', 'C'), ('B', 'C')]
