import Mathlib

/-
FG4 compositional error-budget formalization.

SC-039:
If f is Lf-Lipschitz and g is Lg-Lipschitz, then g ∘ f is
(Lg * Lf)-Lipschitz. Therefore an initial epsilon tolerance propagates
to at most (Lg * Lf) * epsilon after two steps.
-/

def LipschitzBoundC
    {α : Type}
    (d : α → α → ℝ)
    (L : ℝ)
    (f : α → α) : Prop :=
  ∀ x y, d (f x) (f y) ≤ L * d x y

def ECloseC
    {α : Type}
    (d : α → α → ℝ)
    (eps : ℝ)
    (x y : α) : Prop :=
  d x y ≤ eps

theorem SC039_composition_lipschitz_bound
    {α : Type}
    (d : α → α → ℝ)
    (Lf Lg : ℝ)
    (f g : α → α)
    (hf : LipschitzBoundC d Lf f)
    (hg : LipschitzBoundC d Lg g)
    (hLg_nonneg : 0 ≤ Lg) :
    LipschitzBoundC d (Lg * Lf) (fun x => g (f x)) := by
  intro x y
  calc
    d (g (f x)) (g (f y))
        ≤ Lg * d (f x) (f y) := hg (f x) (f y)
    _ ≤ Lg * (Lf * d x y) := by
      exact mul_le_mul_of_nonneg_left (hf x y) hLg_nonneg
    _ = (Lg * Lf) * d x y := by
      ring

theorem SC039_two_step_tolerance_budget
    {α : Type}
    (d : α → α → ℝ)
    (Lf Lg eps : ℝ)
    (f g : α → α)
    (hf : LipschitzBoundC d Lf f)
    (hg : LipschitzBoundC d Lg g)
    (hLg_nonneg : 0 ≤ Lg)
    (hprod_nonneg : 0 ≤ Lg * Lf)
    {x y : α}
    (hxy : ECloseC d eps x y) :
    ECloseC d ((Lg * Lf) * eps) (g (f x)) (g (f y)) := by
  unfold ECloseC at *
  have hcomp :
      LipschitzBoundC d (Lg * Lf) (fun z => g (f z)) :=
    SC039_composition_lipschitz_bound
      d Lf Lg f g hf hg hLg_nonneg
  calc
    d (g (f x)) (g (f y))
        ≤ (Lg * Lf) * d x y := hcomp x y
    _ ≤ (Lg * Lf) * eps := by
      exact mul_le_mul_of_nonneg_left hxy hprod_nonneg
