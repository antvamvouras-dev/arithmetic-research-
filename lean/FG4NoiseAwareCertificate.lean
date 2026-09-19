import Mathlib

/-
FG4 noise-aware horizon certificate.

SC-046:
Scaling a confidence interval by a nonnegative amplification factor A
preserves interval inclusion.

SC-047:
If A * upper <= epsilon, every admissible delta in [lower, upper]
is future-safe for merge.

SC-048:
If A * lower > epsilon, every admissible delta in [lower, upper]
is future-safe for split.

SC-049:
For fixed future tolerance epsilon:
- contraction A <= 1 permits an initial tolerance at least as large as epsilon;
- expansion A >= 1 requires an initial tolerance no larger than epsilon.
-/

theorem SC046_scale_interval_nonnegative
    (A lower delta upper : ℝ)
    (hA : 0 ≤ A)
    (_hl : lower ≤ delta)
    (_hu : delta ≤ upper) :
    A * lower ≤ A * delta ∧
    A * delta ≤ A * upper := by
  constructor
  · exact mul_le_mul_of_nonneg_left hl hA
  · exact mul_le_mul_of_nonneg_left hu hA

theorem SC047_certified_future_merge
    (A lower delta upper eps : ℝ)
    (hA : 0 ≤ A)
    (hl : lower ≤ delta)
    (hu : delta ≤ upper)
    (hcert : A * upper ≤ eps) :
    A * delta ≤ eps := by
  have hscaled :
      A * delta ≤ A * upper :=
    mul_le_mul_of_nonneg_left hu hA
  exact le_trans hscaled hcert

theorem SC048_certified_future_split
    (A lower delta upper eps : ℝ)
    (hA : 0 ≤ A)
    (hl : lower ≤ delta)
    (hu : delta ≤ upper)
    (hcert : eps < A * lower) :
    eps < A * delta := by
  have hscaled :
      A * lower ≤ A * delta :=
    mul_le_mul_of_nonneg_left hl hA
  exact lt_of_lt_of_le hcert hscaled

noncomputable def RequiredInitialTolerance
    (A eps : ℝ) : ℝ :=
  eps / A

theorem SC049_contraction_relaxes_initial_tolerance
    (A eps : ℝ)
    (hApos : 0 < A)
    (hAle1 : A ≤ 1)
    (heps : 0 ≤ eps) :
    eps ≤ RequiredInitialTolerance A eps := by
  unfold RequiredInitialTolerance
  have hdiv :
      eps / 1 ≤ eps / A := by
    exact div_le_div_of_nonneg_left heps hApos hAle1
  simpa using hdiv

theorem SC049_expansion_tightens_initial_tolerance
    (A eps : ℝ)
    (hAge1 : 1 ≤ A)
    (heps : 0 ≤ eps) :
    RequiredInitialTolerance A eps ≤ eps := by
  by_cases hA0 : A = 0
  · subst A
    norm_num at hAge1
  · have hApos : 0 < A := lt_of_lt_of_le zero_lt_one hAge1
    unfold RequiredInitialTolerance
    have hdiv :
        eps / A ≤ eps / 1 := by
      exact div_le_div_of_nonneg_left heps zero_lt_one hAge1
    simpa using hdiv
