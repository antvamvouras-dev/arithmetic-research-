import Mathlib

/-
FG4 quotient descent formalization.
SC-018: congruence gives a well-defined induced quotient action.
SC-019: failure of congruence forbids such an induced action.
-/

def CongruentWith
    {α : Type}
    (s : Setoid α)
    (f : α → α) : Prop :=
  ∀ ⦃x y⦄, s.r x y → s.r (f x) (f y)

def QuotientAction
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (hf : CongruentWith s f) :
    Quotient s → Quotient s :=
  Quotient.map f hf

theorem SC018_congruence_gives_quotient_action
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (hf : CongruentWith s f)
    (x : α) :
    QuotientAction s f hf (Quotient.mk s x) =
      Quotient.mk s (f x) := by
  rfl

theorem quotient_action_forces_congruence
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (F : Quotient s → Quotient s)
    (hF : ∀ x, F (Quotient.mk s x) = Quotient.mk s (f x)) :
    CongruentWith s f := by
  intro x y hxy
  have hqxy :
      Quotient.mk s x = Quotient.mk s y := by
    exact Quotient.sound hxy
  have himage :
      Quotient.mk s (f x) = Quotient.mk s (f y) := by
    calc
      Quotient.mk s (f x)
          = F (Quotient.mk s x) := (hF x).symm
      _ = F (Quotient.mk s y) := congrArg F hqxy
      _ = Quotient.mk s (f y) := hF y
  exact Quotient.exact himage

theorem SC019_noncongruence_blocks_quotient_action
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (hbad : ¬ CongruentWith s f) :
    ¬ ∃ F : Quotient s → Quotient s,
        ∀ x, F (Quotient.mk s x) = Quotient.mk s (f x) := by
  intro h
  rcases h with ⟨F, hF⟩
  exact hbad (quotient_action_forces_congruence s f F hF)
