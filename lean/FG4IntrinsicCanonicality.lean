import Mathlib

/--
FG4 intrinsic canonicality: order-theoretic theorem package.
Targets promoted by FG4-CANON-003.
-/

abbrev ReachO {α : Type} (r : α → α → Prop) :=
  Relation.ReflTransGen r

def NormalO {α : Type} (r : α → α → Prop) (n : α) : Prop :=
  ∀ y, ¬ r n y

/--
A state is a least reachable normal form when it is reachable, normal,
and below every other reachable normal form in the declared order.
-/
def LeastReachableNormal
    {α : Type}
    (r le : α → α → Prop)
    (x n : α) : Prop :=
  ReachO r x n ∧
  NormalO r n ∧
  ∀ m, ReachO r x m → NormalO r m → le n m

/--
SC-015:
Under antisymmetry, a least reachable normal form is unique.
-/
theorem SC015_least_reachable_normal_unique
    {α : Type}
    {r le : α → α → Prop}
    {x a b : α}
    (hanti : ∀ {u v}, le u v → le v u → u = v)
    (ha : LeastReachableNormal r le x a)
    (hb : LeastReachableNormal r le x b) :
    a = b := by
  have hab : le a b := ha.2.2 b hb.1 hb.2.1
  have hba : le b a := hb.2.2 a ha.1 ha.2.1
  exact hanti hab hba

/--
SC-016:
If the reachable normal forms are exhausted by two incomparable states,
then no least reachable normal form exists.
-/
theorem SC016_incomparable_normals_no_least
    {α : Type}
    {r le : α → α → Prop}
    {x a b : α}
    (hxa : ReachO r x a)
    (hxb : ReachO r x b)
    (hna : NormalO r a)
    (hnb : NormalO r b)
    (hab : ¬ le a b)
    (hba : ¬ le b a)
    (hexhaust :
      ∀ n, ReachO r x n → NormalO r n → n = a ∨ n = b) :
    ¬ ∃ n, LeastReachableNormal r le x n := by
  intro h
  rcases h with ⟨n, hn⟩
  rcases hexhaust n hn.1 hn.2.1 with hna' | hnb'
  · subst n
    exact hab (hn.2.2 b hxb hnb)
  · subst n
    exact hba (hn.2.2 a hxa hna)

/--
SC-017:
Normality alone does not establish leastness.
A reachable normal state a fails to be least whenever there is another
reachable normal state b with not (a ≤ b).
-/
theorem SC017_normality_not_leastness
    {α : Type}
    {r le : α → α → Prop}
    {x a b : α}
    (hxa : ReachO r x a)
    (hxb : ReachO r x b)
    (hna : NormalO r a)
    (hnb : NormalO r b)
    (hab : ¬ le a b) :
    NormalO r a ∧ ¬ LeastReachableNormal r le x a := by
  constructor
  · exact hna
  · intro hleast
    exact hab (hleast.2.2 b hxb hnb)
