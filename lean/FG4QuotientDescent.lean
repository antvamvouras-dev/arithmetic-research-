import Mathlib

/--
FG4 quotient descent formalization.

Targets promoted by FG4-CANON-004:
SC-018: congruence gives a well-defined induced quotient action.
SC-019: failure of congruence forbids any quotient action satisfying the expected representative equation.
-/

/-- A function respects the equivalence relation of a setoid. -/
def CongruentWith
    {α : Type}
    (s : Setoid α)
    (f : α → α) : Prop :=
  ∀ x y, s.Rel x y → s.Rel (f x) (f y)

/-- The quotient action induced by a congruent raw-state map. -/
def QuotientAction
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (hf : CongruentWith s f) :
    Quotient s → Quotient s :=
  Quotient.map f hf

/--
SC-018:
A congruent raw-state map induces a quotient map satisfying
  fbar([x]) = [f(x)].
-/
theorem SC018_congruence_gives_quotient_action
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (hf : CongruentWith s f)
    (x : α) :
    QuotientAction s f hf (Quotient.mk s x) =
      Quotient.mk s (f x) := by
  rfl

/--
Any quotient-level map satisfying the expected representative equation
forces the raw-state map to respect equivalence.
-/
theorem quotient_action_forces_congruence
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (F : Quotient s → Quotient s)
    (hF : ∀ x, F (Quotient.mk s x) = Quotient.mk s (f x)) :
    CongruentWith s f := by
  intro x y hxy
  have hqxy : Quotient.mk s x = Quotient.mk s y :=
    Quotient.sound hxy
  have himage :
      Quotient.mk s (f x) = Quotient.mk s (f y) := by
    calc
      Quotient.mk s (f x) = F (Quotient.mk s x) := (hF x).symm
      _ = F (Quotient.mk s y) := congrArg F hqxy
      _ = Quotient.mk s (f y) := hF y
  exact Quotient.exact himage

/--
SC-019:
If f is not congruent with the setoid, then there is no quotient action
whose value on every class is represented by f(x).
-/
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
