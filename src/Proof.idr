module Proof

plus_reduces : (n : Nat) -> Z + n = n
plus_reduces n = Refl

plus_right_id : (n : Nat) -> n + 0 = n
plus_right_id Z = Refl
plus_right_id (S n) = cong S (plus_right_id n)

plus_reduces_S : (n : Nat) -> (m : Nat) -> n + (S m) = S (n + m)
plus_reduces_S Z m = cong S Refl
-- cong: congruence, take `f` to show `a = b` iff `(f a) = (f b)`
plus_reduces_S (S k) m = cong S (plus_reduces_S k m)

plus_commutes_Z : (m : Nat) -> m = plus m Z
plus_commutes_Z 0 = Refl
plus_commutes_Z (S k) = cong S (plus_commutes_Z k)

plus_commutes_S : (k : Nat) -> (m : Nat) -> S (plus m k) = plus m (S k)
plus_commutes_S k 0 = Refl
plus_commutes_S k (S j) = cong S (plus_commutes_S k j)

plus_commutes : (n, m : Nat) -> n + m = m + n
plus_commutes Z m = (plus_commutes_Z m)
plus_commutes (S k) m = rewrite plus_commutes k m in (plus_commutes_S k m)

sym : forall x, y . (0 rule : x = y) -> y = x
sym Refl = Refl

trans : forall x, y, z . (0 l : x = y) -> (0 r : y = z) -> x = z
trans Refl Refl = Refl
