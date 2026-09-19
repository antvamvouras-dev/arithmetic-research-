import Mathlib

/-
FG5 proof-obligation kernel.

The key design rule is that auxiliary obligations and certificates do not
replace a formal derivation of the target proposition.

SC-050: full certification implies formal proof.
SC-051: adding an auxiliary obligation does not change whether the target is
        formally provable from the assumptions.
SC-052: certification with more obligations implies certification with fewer.
SC-053: a certified claim remains certified after adding an obligation if that
        new obligation is itself discharged.
SC-054: a claim cannot be both fully certified and refuted.
-/

structure NamedObligation where
  name : String
  statement : Prop

def ObligationsHold : List NamedObligation → Prop
  | [] => True
  | o :: os => o.statement ∧ ObligationsHold os

structure ProofClaim where
  assumptions : Prop
  target : Prop
  obligations : List NamedObligation

def FormallyProved (c : ProofClaim) : Prop :=
  c.assumptions → c.target

structure ProofCertificate (c : ProofClaim) : Prop where
  formal : FormallyProved c
  obligations : ObligationsHold c.obligations

def FullyCertified (c : ProofClaim) : Prop :=
  Nonempty (ProofCertificate c)

structure RefutationCertificate (c : ProofClaim) : Prop where
  assumptionsHold : c.assumptions
  counterexample : ¬ c.target

def Refuted (c : ProofClaim) : Prop :=
  Nonempty (RefutationCertificate c)

inductive EvidenceStatus where
  | certified
  | refuted
  | unresolved
  deriving DecidableEq, Repr

def StatusMeaning (c : ProofClaim) : EvidenceStatus → Prop
  | .certified => FullyCertified c
  | .refuted => Refuted c
  | .unresolved => ¬ FullyCertified c ∧ ¬ Refuted c

def AddObligation
    (c : ProofClaim)
    (o : NamedObligation) : ProofClaim :=
  { c with obligations := o :: c.obligations }

theorem SC050_full_certification_implies_formal_proof
    (c : ProofClaim)
    (h : FullyCertified c) :
    FormallyProved c := by
  rcases h with ⟨cert⟩
  exact cert.formal

theorem SC051_adding_obligation_preserves_formal_provability
    (c : ProofClaim)
    (o : NamedObligation) :
    FormallyProved (AddObligation c o) ↔ FormallyProved c := by
  rfl

theorem SC052_more_obligations_cannot_weaken_certification
    (c : ProofClaim)
    (o : NamedObligation)
    (h : FullyCertified (AddObligation c o)) :
    FullyCertified c := by
  rcases h with ⟨cert⟩
  refine ⟨?_⟩
  exact
    { formal := cert.formal
      obligations := cert.obligations.2 }

theorem SC053_extend_certificate_with_discharged_obligation
    (c : ProofClaim)
    (o : NamedObligation)
    (hcert : FullyCertified c)
    (ho : o.statement) :
    FullyCertified (AddObligation c o) := by
  rcases hcert with ⟨cert⟩
  refine ⟨?_⟩
  exact
    { formal := cert.formal
      obligations := ⟨ho, cert.obligations⟩ }

theorem SC054_certified_and_refuted_are_incompatible
    (c : ProofClaim)
    (hcert : FullyCertified c)
    (href : Refuted c) :
    False := by
  rcases hcert with ⟨cert⟩
  rcases href with ⟨ref⟩
  exact ref.counterexample (cert.formal ref.assumptionsHold)
