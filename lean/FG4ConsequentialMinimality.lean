import Mathlib

/-
FG4 consequential minimality formalization.

SC-031: any relation sufficient for the full declared consequence family
        refines complete future-consequence equivalence.
SC-032: FutureEq is therefore the coarsest full-consequence-sufficient setoid.
SC-033: finite-horizon equivalence need not survive horizon extension.
SC-034: increasing the horizon monotonically refines consequence equivalence.
-/

def RunC
    {α σ : Type}
    (step : α → σ → α) :
    α → List σ → α
  | x, [] => x
  | x, a :: w => RunC step (step x a) w

def FutureEqC
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (x y : α) : Prop :=
  ∀ w, obs (RunC step x w) = obs (RunC step y w)

def SufficientRel
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (R : α → α → Prop) : Prop :=
  ∀ ⦃x y⦄, R x y → FutureEqC step obs x y

theorem SC031_sufficient_relation_refines_futureEq
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (R : α → α → Prop)
    (hR : SufficientRel step obs R)
    {x y : α}
    (hxy : R x y) :
    FutureEqC step obs x y := by
  exact hR hxy

theorem futureEqC_refl
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (x : α) :
    FutureEqC step obs x x := by
  intro w
  rfl

theorem futureEqC_symm
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    {x y : α}
    (h : FutureEqC step obs x y) :
    FutureEqC step obs y x := by
  intro w
  exact (h w).symm

theorem futureEqC_trans
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    {x y z : α}
    (hxy : FutureEqC step obs x y)
    (hyz : FutureEqC step obs y z) :
    FutureEqC step obs x z := by
  intro w
  exact (hxy w).trans (hyz w)

def FutureSetoidC
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β) :
    Setoid α where
  r := FutureEqC step obs
  iseqv := ⟨
    futureEqC_refl step obs,
    futureEqC_symm step obs,
    futureEqC_trans step obs
  ⟩

def SetoidSufficient
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (s : Setoid α) : Prop :=
  ∀ ⦃x y⦄, s.r x y → FutureEqC step obs x y

def RefinesSetoidC
    {α : Type}
    (fine coarse : Setoid α) : Prop :=
  ∀ ⦃x y⦄, fine.r x y → coarse.r x y

theorem SC032_futureEq_coarsest_sufficient_setoid
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (s : Setoid α)
    (hs : SetoidSufficient step obs s) :
    RefinesSetoidC s (FutureSetoidC step obs) := by
  intro x y hxy
  exact hs hxy

def FutureEqUpTo
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (n : Nat)
    (x y : α) : Prop :=
  ∀ w, w.length ≤ n →
    obs (RunC step x w) = obs (RunC step y w)

theorem SC034_horizon_extension_refines_equivalence
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    {n m : Nat}
    (hnm : n ≤ m)
    {x y : α}
    (hxy : FutureEqUpTo step obs m x y) :
    FutureEqUpTo step obs n x y := by
  intro w hw
  exact hxy w (Nat.le_trans hw hnm)

/- SC-033 finite witness. -/

inductive HState where
  | a | b | one | zero
  deriving DecidableEq, Repr

def hStep : HState → Unit → HState
  | .a, _ => .one
  | .b, _ => .zero
  | .one, _ => .one
  | .zero, _ => .zero

def hObs : HState → Nat
  | .one => 1
  | _ => 0

theorem h_eq_at_horizon_zero :
    FutureEqUpTo hStep hObs 0 HState.a HState.b := by
  intro w hw
  cases w with
  | nil =>
      rfl
  | cons a t =>
      simp at hw

theorem h_not_eq_at_horizon_one :
    ¬ FutureEqUpTo hStep hObs 1 HState.a HState.b := by
  intro h
  have hbad := h [()] (by decide)
  norm_num [RunC, hStep, hObs] at hbad

theorem SC033_finite_horizon_can_split_later :
    FutureEqUpTo hStep hObs 0 HState.a HState.b ∧
    ¬ FutureEqUpTo hStep hObs 1 HState.a HState.b := by
  exact ⟨h_eq_at_horizon_zero, h_not_eq_at_horizon_one⟩
