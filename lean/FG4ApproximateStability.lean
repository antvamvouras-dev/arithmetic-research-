import Mathlib

/-
FG4 approximate consequential stability.

SC-035: epsilon-closeness need not be transitive.
SC-037: an L-Lipschitz map sends epsilon-close points to L*epsilon-close points.
SC-038: if L <= 1, epsilon-closeness is one-step stable.
-/

/- SC-035 finite witness on R. -/

def EClose (eps x y : ℝ) : Prop :=
  |x - y| ≤ eps

theorem SC035_epsilon_closeness_not_transitive :
    EClose 1 (0 : ℝ) 0.75 ∧
    EClose 1 (0.75 : ℝ) 1.5 ∧
    ¬ EClose 1 (0 : ℝ) 1.5 := by
  constructor
  · norm_num [EClose, abs_of_nonneg]
  constructor
  · norm_num [EClose, abs_of_nonneg]
  · norm_num [EClose, abs_of_nonneg]

/- Generic Lipschitz-style predicate. -/

def LipschitzBound
    {α : Type}
    (d : α → α → ℝ)
    (L : ℝ)
    (f : α → α) : Prop :=
  ∀ x y, d (f x) (f y) ≤ L * d x y

def ECloseD
    {α : Type}
    (d : α → α → ℝ)
    (eps : ℝ)
    (x y : α) : Prop :=
  d x y ≤ eps

theorem SC037_lipschitz_propagates_tolerance
    {α : Type}
    (d : α → α → ℝ)
    (L eps : ℝ)
    (f : α → α)
    (hL : LipschitzBound d L f)
    {x y : α}
    (hxy : ECloseD d eps x y)
    (hLnonneg : 0 ≤ L) :
    ECloseD d (L * eps) (f x) (f y) := by
  unfold ECloseD at *
  calc
    d (f x) (f y) ≤ L * d x y := hL x y
    _ ≤ L * eps := by
      exact mul_le_mul_of_nonneg_left hxy hLnonneg

theorem SC038_contraction_preserves_epsilon
    {α : Type}
    (d : α → α → ℝ)
    (L eps : ℝ)
    (f : α → α)
    (hL : LipschitzBound d L f)
    (hLnonneg : 0 ≤ L)
    (hLle1 : L ≤ 1)
    (heps : 0 ≤ eps)
    {x y : α}
    (hxy : ECloseD d eps x y) :
    ECloseD d eps (f x) (f y) := by
  have hprop :
      ECloseD d (L * eps) (f x) (f y) :=
    SC037_lipschitz_propagates_tolerance
      d L eps f hL hxy hLnonneg
  unfold ECloseD at *
  calc
    d (f x) (f y) ≤ L * eps := hprop
    _ ≤ 1 * eps := by
      exact mul_le_mul_of_nonneg_right hLle1 heps
    _ = eps := by ring
