import Mathlib

/-
FG4 horizon-wise compositional error budget.

SC-044:
For any finite sequence of Lipschitz steps, the total Lipschitz bound is
the product of the per-step bounds.

SC-045:
An initial epsilon tolerance propagates through the whole finite horizon
to at most (product of L_i) * epsilon.
-/

def LipschitzBoundH
    {α : Type}
    (d : α → α → ℝ)
    (L : ℝ)
    (f : α → α) : Prop :=
  ∀ x y, d (f x) (f y) ≤ L * d x y

structure LipStep
    (α : Type)
    (d : α → α → ℝ) where
  f : α → α
  L : ℝ
  nonneg : 0 ≤ L
  bound : LipschitzBoundH d L f

def ApplySteps
    {α : Type}
    {d : α → α → ℝ} :
    List (LipStep α d) → α → α
  | [], x => x
  | s :: ss, x => ApplySteps ss (s.f x)

def StepProduct
    {α : Type}
    {d : α → α → ℝ} :
    List (LipStep α d) → ℝ
  | [] => 1
  | s :: ss => StepProduct ss * s.L

theorem stepProduct_nonneg
    {α : Type}
    {d : α → α → ℝ}
    (steps : List (LipStep α d)) :
    0 ≤ StepProduct steps := by
  induction steps with
  | nil =>
      norm_num [StepProduct]
  | cons s ss ih =>
      simp [StepProduct]
      exact mul_nonneg ih s.nonneg

theorem SC044_finite_composition_lipschitz
    {α : Type}
    (d : α → α → ℝ)
    (steps : List (LipStep α d))
    (x y : α) :
    d (ApplySteps steps x) (ApplySteps steps y) ≤
      StepProduct steps * d x y := by
  induction steps generalizing x y with
  | nil =>
      simp [ApplySteps, StepProduct]
  | cons s ss ih =>
      have hprod : 0 ≤ StepProduct ss :=
        stepProduct_nonneg ss
      calc
        d (ApplySteps (s :: ss) x) (ApplySteps (s :: ss) y)
            = d (ApplySteps ss (s.f x)) (ApplySteps ss (s.f y)) := by
                rfl
        _ ≤ StepProduct ss * d (s.f x) (s.f y) := by
              exact ih (s.f x) (s.f y)
        _ ≤ StepProduct ss * (s.L * d x y) := by
              exact mul_le_mul_of_nonneg_left (s.bound x y) hprod
        _ = StepProduct (s :: ss) * d x y := by
              simp [StepProduct]
              ring

def ECloseH
    {α : Type}
    (d : α → α → ℝ)
    (eps : ℝ)
    (x y : α) : Prop :=
  d x y ≤ eps

theorem SC045_horizon_tolerance_budget
    {α : Type}
    (d : α → α → ℝ)
    (steps : List (LipStep α d))
    (eps : ℝ)
    {x y : α}
    (hxy : ECloseH d eps x y) :
    ECloseH d (StepProduct steps * eps)
      (ApplySteps steps x)
      (ApplySteps steps y) := by
  unfold ECloseH at *
  have hprod : 0 ≤ StepProduct steps :=
    stepProduct_nonneg steps
  calc
    d (ApplySteps steps x) (ApplySteps steps y)
        ≤ StepProduct steps * d x y := by
            exact SC044_finite_composition_lipschitz d steps x y
    _ ≤ StepProduct steps * eps := by
          exact mul_le_mul_of_nonneg_left hxy hprod
