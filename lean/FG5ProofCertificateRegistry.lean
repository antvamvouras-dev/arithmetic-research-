import Mathlib

/-
FG5 typed certificate registry.

Each obligation certificate carries:
1. provenance metadata;
2. an actual witness of the obligation proposition.

Metadata alone cannot certify a proposition.

SC-059: a complete typed registry discharges every listed obligation.
SC-060: a discharged obligation can be prepended to an existing registry.
SC-061: dropping the first obligation preserves the tail registry.
SC-062: a registered proof certificate yields both a formal proof and
        discharged auxiliary obligations.
SC-063: if P is false, no provenance label can manufacture Evidence P.
-/

inductive EvidenceKind where
  | formal
  | computation
  | empirical
  | external
  deriving DecidableEq, Repr

structure Provenance where
  kind : EvidenceKind
  reference : String
  deriving Repr

structure NamedObligationK where
  name : String
  statement : Prop

def ObligationsHoldK : List NamedObligationK → Prop
  | [] => True
  | o :: os => o.statement ∧ ObligationsHoldK os

structure Evidence (P : Prop) where
  provenance : Provenance
  witness : P

def CertificateRegistry : List NamedObligationK → Type
  | [] => PUnit
  | o :: os => Evidence o.statement × CertificateRegistry os

theorem SC059_registry_discharges_obligations
    (obs : List NamedObligationK)
    (registry : CertificateRegistry obs) :
    ObligationsHoldK obs := by
  induction obs with
  | nil =>
      trivial
  | cons o os ih =>
      exact ⟨registry.1.witness, ih registry.2⟩

def SC060_extend_registry
    (o : NamedObligationK)
    (os : List NamedObligationK)
    (e : Evidence o.statement)
    (registry : CertificateRegistry os) :
    CertificateRegistry (o :: os) := by
  exact ⟨e, registry⟩

def SC061_tail_registry
    (o : NamedObligationK)
    (os : List NamedObligationK)
    (registry : CertificateRegistry (o :: os)) :
    CertificateRegistry os := by
  exact registry.2

structure ProofClaimK where
  assumptions : Prop
  target : Prop
  obligations : List NamedObligationK

def FormallyProvedK (c : ProofClaimK) : Prop :=
  c.assumptions → c.target

structure RegisteredProofCertificate (c : ProofClaimK) where
  formal : FormallyProvedK c
  registry : CertificateRegistry c.obligations

def RegistryCertified (c : ProofClaimK) : Prop :=
  Nonempty (RegisteredProofCertificate c)

theorem SC062_registered_certificate_is_logically_complete
    (c : ProofClaimK)
    (hcert : RegistryCertified c) :
    FormallyProvedK c ∧ ObligationsHoldK c.obligations := by
  rcases hcert with ⟨cert⟩
  constructor
  · exact cert.formal
  · exact SC059_registry_discharges_obligations
      c.obligations cert.registry

theorem SC063_false_proposition_has_no_typed_evidence
    (P : Prop)
    (hP : ¬ P) :
    ¬ Nonempty (Evidence P) := by
  intro h
  rcases h with ⟨e⟩
  exact hP e.witness
