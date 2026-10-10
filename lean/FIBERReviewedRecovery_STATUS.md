# Observable recovery draft — verification status

`FIBERReviewedRecovery.lean` is a mathematically reviewed proposal. It has NOT been independently compiled in the research environment. No numerical positivity certificate or Riemann Hypothesis theorem is formalized by this file.

The statements cover local recovery on a fixed fiber, the standard global factorization criterion, and preservation of paired observables. Global factorization is already part of Mathlib; no novelty is claimed for these identities. Classical choice supplies existence, not an executable compression algorithm.

Before merging: pin Lean and Mathlib versions, compile the complete file with `lake env lean lean/FIBERReviewedRecovery.lean`, inspect all three `#print axioms` outputs, and reject any dependence on `sorryAx`. A successful compilation still requires confirming that the definitions express the intended research target.

The interval-arithmetic certificates for finite Weil matrix regions have a separate trust base. Connecting them to Lean requires formal source bounds, norm and domain definitions, and an explicit arithmetic-certificate checking bridge.
