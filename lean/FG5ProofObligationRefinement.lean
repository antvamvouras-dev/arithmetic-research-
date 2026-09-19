import Mathlib

/-
FG5 proof-obligation refinement.

We order obligation families semantically:
a stronger family refines a weaker one when discharging all stronger
obligations is sufficient to discharge all weaker obligations.

SC-055: obligation refinement is reflexive and transitive.
SC-056: certification transports from stronger obligations to weaker ones.
SC-057: adding one obligation produces a stronger obligation family.
SC-058: the converse transport fails in general; a weakly certified claim
        may become uncertified after adding a genuinely new obligation.
-/

structure NamedObligationR where
  name : String
  statement : Prop

def ObligationsHoldR : List NamedObligationR → Prop
  | [] => True
  | o :: os => o.statement ∧ ObligationsHoldR os

structure ProofClaimR where
  assumptions : Prop
  target : Prop
  obligations : List NamedObligationR

def FormallyProvedR (c : ProofClaimR) : Prop :=
  c.assumptions → c.target

structure ProofCertificateR (c : ProofClaimR) : Prop where
  formal : FormallyProvedR c
  obligations : ObligationsHoldR c.obligations

def FullyCertifiedR (c : ProofClaimR) : Prop :=
  Nonempty (ProofCertificateR c)

def WithObligations
    (c : ProofClaimR)
    (obs : List NamedObligationR) : ProofClaimR :=
  { c with obligations := obs }

def ObligationRefines
    (strong weak : List NamedObligationR) : Prop :=
  ObligationsHoldR strong → ObligationsHoldR weak

theorem SC055_obligation_refinement_preorder :
    (∀ obs, ObligationRefines obs obs) ∧
    (∀ a b c,
      ObligationRefines a b →
      ObligationRefines b c →
      ObligationRefines a c) := by
  constructor
  · intro obs
    intro h
    exact h
  · intro a b c hab hbc ha
    exact hbc (hab ha)

theorem SC056_stronger_certification_implies_weaker
    (c : ProofClaimR)
    (strong weak : List NamedObligationR)
    (href : ObligationRefines strong weak)
    (hcert : FullyCertifiedR (WithObligations c strong)) :
    FullyCertifiedR (WithObligations c weak) := by
  rcases hcert with ⟨cert⟩
  refine ⟨?_⟩
  exact
    { formal := cert.formal
      obligations := href cert.obligations }

def AddObligationR
    (o : NamedObligationR)
    (obs : List NamedObligationR) :
    List NamedObligationR :=
  o :: obs

theorem SC057_adding_obligation_refines_original
    (o : NamedObligationR)
    (obs : List NamedObligationR) :
    ObligationRefines (AddObligationR o obs) obs := by
  intro h
  exact h.2

def impossibleObligation : NamedObligationR :=
  { name := "impossible"
    statement := False }

def trivialClaim : ProofClaimR :=
  { assumptions := True
    target := True
    obligations := [] }

theorem trivialClaim_weakly_certified :
    FullyCertifiedR (WithObligations trivialClaim []) := by
  refine ⟨?_⟩
  exact
    { formal := by
        intro _
        trivial
      obligations := by
        trivial }

theorem trivialClaim_not_certified_with_impossible :
    ¬ FullyCertifiedR
      (WithObligations trivialClaim [impossibleObligation]) := by
  intro h
  rcases h with ⟨cert⟩
  exact cert.obligations.1

theorem weak_does_not_refine_impossible :
    ¬ ObligationRefines [] [impossibleObligation] := by
  intro h
  have himpossible : ObligationsHoldR [impossibleObligation] := by
    exact h (by trivial)
  exact himpossible.1

theorem SC058_weaker_certification_not_imply_stronger :
    ObligationRefines [impossibleObligation] [] ∧
    FullyCertifiedR (WithObligations trivialClaim []) ∧
    ¬ FullyCertifiedR
      (WithObligations trivialClaim [impossibleObligation]) := by
  constructor
  · exact SC057_adding_obligation_refines_original
      impossibleObligation []
  constructor
  · exact trivialClaim_weakly_certified
  · exact trivialClaim_not_certified_with_impossible
