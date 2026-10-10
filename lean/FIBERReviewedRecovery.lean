-- PROPOSED source: mathematically reviewed, NOT compiled in this environment.
-- Pin Lean/mathlib and run `lake env lean ReviewedCore.lean` before claiming verification.
import Mathlib.Logic.Function.Basic
import Mathlib.Tactic

namespace ReviewedRecovery

variable {X I Y : Type*}

def ConstantOnFiber (Phi : X → I) (O : X → Y) (i : I) : Prop :=
  ∀ x y, Phi x = i → Phi y = i → O x = O y

theorem local_recovery_iff [Nonempty Y] (Phi : X → I) (O : X → Y) (i : I) :
    (∃ g : I → Y, ∀ x, Phi x = i → O x = g (Phi x)) ↔
      ConstantOnFiber Phi O i := by
  classical
  constructor
  · rintro ⟨g, hg⟩ x y hx hy
    calc
      O x = g (Phi x) := hg x hx
      _ = g (Phi y) := congrArg g (hx.trans hy.symm)
      _ = O y := (hg y hy).symm
  · intro h
    by_cases he : ∃ x, Phi x = i
    · obtain ⟨x0, hx0⟩ := he
      exact ⟨fun _ => O x0, fun x hx => h x x0 hx hx0⟩
    · exact ⟨fun _ => Classical.choice (inferInstance : Nonempty Y),
        fun x hx => False.elim (he ⟨x, hx⟩)⟩

-- The global criterion is already part of Mathlib's standard factorization API.
theorem global_recovery_iff [Nonempty Y] (Phi : X → I) (O : X → Y) :
    (∃ g : I → Y, ∀ x, O x = g (Phi x)) ↔
      Function.FactorsThrough O Phi := by
  constructor
  · rintro ⟨g, hg⟩ x y hxy
    calc
      O x = g (Phi x) := hg x
      _ = g (Phi y) := congrArg g hxy
      _ = O y := (hg y).symm
  · intro h
    obtain ⟨g, hg⟩ := (Function.factorsThrough_iff (f := Phi) O).mp h
    exact ⟨g, fun x => congrFun hg x⟩

-- Multiple targets must be transported together: preserve the product observable.
theorem pair_factorsThrough {Z : Type*} (Phi : X → I)
    (O : X → Y) (P : X → Z)
    (hO : Function.FactorsThrough O Phi) (hP : Function.FactorsThrough P Phi) :
    Function.FactorsThrough (fun x => (O x, P x)) Phi := by
  intro x y hxy
  exact Prod.ext (hO hxy) (hP hxy)

end ReviewedRecovery

#print axioms ReviewedRecovery.local_recovery_iff
#print axioms ReviewedRecovery.global_recovery_iff
#print axioms ReviewedRecovery.pair_factorsThrough
