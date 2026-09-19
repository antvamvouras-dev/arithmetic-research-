import Mathlib

/-
FG4 consequential quotient formalization.

SC-028: equality of complete future consequence signatures is an equivalence relation.
SC-029: one-step transition preserves future-consequence equivalence.
SC-030: therefore each input symbol induces a well-defined quotient transition.
-/

def Run
    {α σ : Type}
    (step : α → σ → α) :
    α → List σ → α
  | x, [] => x
  | x, a :: w => Run step (step x a) w

def FutureEq
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (x y : α) : Prop :=
  ∀ w, obs (Run step x w) = obs (Run step y w)

theorem futureEq_refl
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (x : α) :
    FutureEq step obs x x := by
  intro w
  rfl

theorem futureEq_symm
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    {x y : α}
    (h : FutureEq step obs x y) :
    FutureEq step obs y x := by
  intro w
  exact (h w).symm

theorem futureEq_trans
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    {x y z : α}
    (hxy : FutureEq step obs x y)
    (hyz : FutureEq step obs y z) :
    FutureEq step obs x z := by
  intro w
  exact (hxy w).trans (hyz w)

def FutureSetoid
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β) :
    Setoid α where
  r := FutureEq step obs
  iseqv := ⟨
    futureEq_refl step obs,
    futureEq_symm step obs,
    futureEq_trans step obs
  ⟩

theorem SC028_future_consequence_equivalence
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β) :
    Equivalence (FutureEq step obs) := by
  constructor
  · exact futureEq_refl step obs
  · exact futureEq_symm step obs
  · exact futureEq_trans step obs

theorem SC029_one_step_preserves_future_equivalence
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    {x y : α}
    (hxy : FutureEq step obs x y)
    (a : σ) :
    FutureEq step obs (step x a) (step y a) := by
  intro w
  exact hxy (a :: w)

def ConsequentialQuotientStep
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (a : σ) :
    Quotient (FutureSetoid step obs) →
    Quotient (FutureSetoid step obs) :=
  Quotient.map
    (fun x => step x a)
    (by
      intro x y hxy
      exact SC029_one_step_preserves_future_equivalence step obs hxy a)

theorem SC030_quotient_transition_well_defined
    {α σ β : Type}
    (step : α → σ → α)
    (obs : α → β)
    (a : σ)
    (x : α) :
    ConsequentialQuotientStep step obs a
      (Quotient.mk (FutureSetoid step obs) x)
      =
    Quotient.mk (FutureSetoid step obs) (step x a) := by
  rfl
