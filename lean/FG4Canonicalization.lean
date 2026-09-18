import Mathlib

/--
FG4 canonicalization formalization candidate.
Finite witnesses for separating local descent, preservation, and canonicality.
-/

inductive S where
  | start | trap | bridge | canon
  deriving DecidableEq, Repr

open S

def cost : S → Nat
  | start => 3
  | trap => 1
  | bridge => 2
  | canon => 0

inductive Step : S → S → Prop
  | start_trap : Step start trap
  | start_bridge : Step start bridge
  | bridge_canon : Step bridge canon

/-- A normal state has no outgoing rewrite. -/
def Normal (x : S) : Prop := ∀ y, ¬ Step x y

theorem trap_normal : Normal trap := by
  intro y h
  cases h

theorem canon_normal : Normal canon := by
  intro y h
  cases h

theorem start_to_trap : Step start trap := Step.start_trap

theorem start_to_bridge : Step start bridge := Step.start_bridge

theorem bridge_to_canon : Step bridge canon := Step.bridge_canon

theorem trap_cheaper_than_start : cost trap < cost start := by decide

theorem bridge_cheaper_than_start : cost bridge < cost start := by decide

theorem trap_cheaper_than_bridge : cost trap < cost bridge := by decide

theorem trap_ne_canon : trap ≠ canon := by decide

/-- SC-012: a locally cheaper strictly descending successor can be a noncanonical normal form. -/
theorem SC012_local_descent_obstruction :
    Step start trap ∧ cost trap < cost start ∧ Normal trap ∧ trap ≠ canon := by
  exact ⟨start_to_trap, trap_cheaper_than_start, trap_normal, trap_ne_canon⟩

/-- A simple consequence label. Every state has the same label, so every step preserves it. -/
def consequence : S → Nat := fun _ => 0

def PreservesConsequence : Prop := ∀ {a b}, Step a b → consequence a = consequence b

theorem all_steps_preserve : PreservesConsequence := by
  intro a b h
  rfl

/-- SC-013: preservation alone does not imply canonicality. -/
theorem SC013_preservation_not_canonicality :
    PreservesConsequence ∧ Step start trap ∧ Normal trap ∧ trap ≠ canon := by
  exact ⟨all_steps_preserve, start_to_trap, trap_normal, trap_ne_canon⟩

/-- Second finite system: cheap invalid path vs safe valid path. -/
inductive G where
  | start | bad | good | canon
  deriving DecidableEq, Repr

open G

def labelG : G → Nat
  | G.start => 0
  | G.bad => 1
  | G.good => 0
  | G.canon => 0

inductive StepG : G → G → Prop
  | cheap_bad : StepG G.start G.bad
  | safe_good : StepG G.start G.good
  | good_canon : StepG G.good G.canon

def PreservesG (a b : G) : Prop := labelG a = labelG b

theorem cheap_bad_breaks_contract : ¬ PreservesG G.start G.bad := by
  simp [PreservesG, labelG]

theorem safe_good_preserves_contract : PreservesG G.start G.good := by
  simp [PreservesG, labelG]

theorem good_canon_preserves_contract : PreservesG G.good G.canon := by
  simp [PreservesG, labelG]

/-- SC-014 finite witness: a contract distinguishes the cheap invalid edge from the safe route. -/
theorem SC014_contract_guard_witness :
    (¬ PreservesG G.start G.bad) ∧ PreservesG G.start G.good ∧ PreservesG G.good G.canon := by
  exact ⟨cheap_bad_breaks_contract, safe_good_preserves_contract, good_canon_preserves_contract⟩

/-- Reachability by zero or more rewrite steps. -/
abbrev Reach {α : Type} (r : α → α → Prop) := Relation.ReflTransGen r

/-- `n` is normal for relation `r`. -/
def NormalFor {α : Type} (r : α → α → Prop) (n : α) : Prop := ∀ y, ¬ r n y

/-- Two states are joinable when they have a common reachable successor. -/
def Joinable {α : Type} (r : α → α → Prop) (a b : α) : Prop :=
  ∃ z, Reach r a z ∧ Reach r b z

/-- Confluence restricted to states reachable from a fixed start state. -/
def ConfluentFrom {α : Type} (r : α → α → Prop) (x : α) : Prop :=
  ∀ ⦃a b⦄, Reach r x a → Reach r x b → Joinable r a b

/-- A normal form can only reach itself. -/
theorem normal_reach_eq {α : Type} {r : α → α → Prop} {n z : α}
    (hn : NormalFor r n) (h : Reach r n z) : z = n := by
  induction h with
  | refl => rfl
  | tail hxy hyz ih =>
      have hstep : r n _ := by
        simpa [ih] using hyz
      exact (hn _ hstep).elim

/-- SC-009: confluence from x implies uniqueness of reachable normal forms. -/
theorem SC009_confluence_unique_normal_form
    {α : Type} {r : α → α → Prop} {x a b : α}
    (hconf : ConfluentFrom r x)
    (hxa : Reach r x a) (hxb : Reach r x b)
    (hna : NormalFor r a) (hnb : NormalFor r b) : a = b := by
  rcases hconf hxa hxb with ⟨z, haz, hbz⟩
  have hza : z = a := normal_reach_eq hna haz
  have hzb : z = b := normal_reach_eq hnb hbz
  exact hza.symm.trans hzb
