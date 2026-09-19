import Mathlib

/-
FG4 refinement/coarsening formalization.

SC-023: refinement induces a canonical projection between quotient spaces.
SC-024: if f is congruent for both equivalences, quotient dynamics commute
        with the projection.
SC-025: fine congruence does not imply coarse congruence.
SC-026: coarse congruence does not imply fine congruence.
SC-027: a unique minimal quotient class can appear after coarsening.
-/

def RefinesSetoid
    {α : Type}
    (fine coarse : Setoid α) : Prop :=
  ∀ ⦃x y⦄, fine.r x y → coarse.r x y

def CongruentR
    {α : Type}
    (s : Setoid α)
    (f : α → α) : Prop :=
  ∀ ⦃x y⦄, s.r x y → s.r (f x) (f y)

def QActionR
    {α : Type}
    (s : Setoid α)
    (f : α → α)
    (hf : CongruentR s f) :
    Quotient s → Quotient s :=
  Quotient.map f hf

def QuotientProjection
    {α : Type}
    (fine coarse : Setoid α)
    (hfc : RefinesSetoid fine coarse) :
    Quotient fine → Quotient coarse :=
  Quotient.map id hfc

theorem SC023_refinement_induces_projection
    {α : Type}
    (fine coarse : Setoid α)
    (hfc : RefinesSetoid fine coarse)
    (x : α) :
    QuotientProjection fine coarse hfc (Quotient.mk fine x) =
      Quotient.mk coarse x := by
  rfl

theorem SC024_quotient_dynamics_commute
    {α : Type}
    (fine coarse : Setoid α)
    (hfc : RefinesSetoid fine coarse)
    (f : α → α)
    (hf : CongruentR fine f)
    (hc : CongruentR coarse f)
    (q : Quotient fine) :
    QuotientProjection fine coarse hfc (QActionR fine f hf q) =
      QActionR coarse f hc (QuotientProjection fine coarse hfc q) := by
  exact Quotient.inductionOn q (fun x => rfl)

def CongruentKey
    {α κ : Type}
    (key : α → κ)
    (f : α → α) : Prop :=
  ∀ x y, key x = key y → key (f x) = key (f y)

/- SC-025 witness. -/

inductive Four25 where
  | a | b | c | d
  deriving DecidableEq, Repr

def fineKey25 : Four25 → Nat
  | .a => 0
  | .b => 1
  | .c => 2
  | .d => 3

def coarseKey25 : Four25 → Nat
  | .a => 0
  | .b => 0
  | .c => 1
  | .d => 2

def f25 : Four25 → Four25
  | .a => .c
  | .b => .d
  | .c => .c
  | .d => .d

theorem f25_fine_congruent :
    CongruentKey fineKey25 f25 := by
  intro x y h
  cases x <;> cases y <;> simp [fineKey25] at h ⊢

theorem f25_not_coarse_congruent :
    ¬ CongruentKey coarseKey25 f25 := by
  intro h
  have hbad := h Four25.a Four25.b (by simp [coarseKey25])
  simpa [coarseKey25, f25] using hbad

theorem SC025_fine_congruence_not_imply_coarse :
    CongruentKey fineKey25 f25 ∧
    ¬ CongruentKey coarseKey25 f25 := by
  exact ⟨f25_fine_congruent, f25_not_coarse_congruent⟩

/- SC-026 witness. -/

inductive Four26 where
  | a | b | c | d
  deriving DecidableEq, Repr

def fineKey26 : Four26 → Nat
  | .a => 0
  | .b => 0
  | .c => 1
  | .d => 2

def coarseKey26 : Four26 → Nat :=
  fun _ => 0

def f26 : Four26 → Four26
  | .a => .c
  | .b => .d
  | .c => .c
  | .d => .d

theorem f26_coarse_congruent :
    CongruentKey coarseKey26 f26 := by
  intro x y h
  simp [coarseKey26]

theorem f26_not_fine_congruent :
    ¬ CongruentKey fineKey26 f26 := by
  intro h
  have hbad := h Four26.a Four26.b (by simp [fineKey26])
  simpa [fineKey26, f26] using hbad

theorem SC026_coarse_congruence_not_imply_fine :
    CongruentKey coarseKey26 f26 ∧
    ¬ CongruentKey fineKey26 f26 := by
  exact ⟨f26_coarse_congruent, f26_not_fine_congruent⟩

/- SC-027 witness. -/

def UniqueMinClass
    {α κ : Type}
    (key : α → κ)
    (rank : α → Nat) : Prop :=
  ∃ x,
    (∀ y, rank x ≤ rank y) ∧
    (∀ z, rank z = rank x → key z = key x)

inductive Two27 where
  | left | right
  deriving DecidableEq, Repr

def fineKey27 : Two27 → Bool
  | .left => false
  | .right => true

def coarseKey27 : Two27 → Unit :=
  fun _ => ()

def rank27 : Two27 → Nat :=
  fun _ => 0

theorem coarse27_has_unique_min_class :
    UniqueMinClass coarseKey27 rank27 := by
  refine ⟨Two27.left, ?_, ?_⟩
  · intro y
    simp [rank27]
  · intro z hz
    cases z <;> rfl

theorem fine27_has_no_unique_min_class :
    ¬ UniqueMinClass fineKey27 rank27 := by
  intro h
  rcases h with ⟨x, hmin, huniq⟩
  cases x with
  | left =>
      have hbad := huniq Two27.right (by simp [rank27])
      simp [fineKey27] at hbad
  | right =>
      have hbad := huniq Two27.left (by simp [rank27])
      simp [fineKey27] at hbad

theorem SC027_canonicality_can_change_under_coarsening :
    (¬ UniqueMinClass fineKey27 rank27) ∧
    UniqueMinClass coarseKey27 rank27 := by
  exact ⟨fine27_has_no_unique_min_class, coarse27_has_unique_min_class⟩
