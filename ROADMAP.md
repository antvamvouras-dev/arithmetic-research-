# Research Roadmap

## Phase 0 — Governance and reproducibility
- Freeze terminology and epistemic labels.
- Every numerical result gets a config, seed policy, code commit and result manifest.
- Separate exploratory notebooks from canonical implementation.
- No geometry/curvature terminology for a statistic unless a metric/geometric construction is explicitly defined.

## Phase 1 — Prime-gap arithmetic benchmark
- Reproduce chronological train/test prime-gap results at N=10^6 and N=10^7.
- Freeze binning and the null hierarchy: permutation, gap-only first order, residue-augmented first order.
- Focus calibrated residue moduli m=6 and m=30 before sparse larger moduli.
- Record marginal, transition and residue TV diagnostics plus fallback rates.

## Phase 2 — Deterministic / hybrid null computation
- Run DHMC-001.
- Determine which null expectations, occupancies, transition counts and additive scores admit exact matrix/DP computation.
- Decompose uncertainty into trajectory randomness and parameter-estimation/refitting randomness.
- Use Monte Carlo only for the residual component that cannot yet be computed deterministically.

## Phase 3 — Residual information
Define and estimate, with held-out probabilities,

K_m = log(P_real(next | state) / P_m(next | compressed state)),
S_m = E[K_m],
E_m = E[K_m^2],
and local conditional divergence D_m(u).

Test stability across N, windows, bins, smoothing choices and predeclared moduli.

## Phase 4 — Information geometry candidate
Only if residual structure survives calibrated arithmetic nulls:
- compare KL, Jensen-Shannon, Hellinger and Fisher-type constructions;
- test whether a useful distance/topology arises naturally;
- distinguish a finite statistical manifold/graph from a differentiable manifold.

## Phase 5 — Formalization
Formalize stable finite-state definitions and lemmas in Lean before speculative geometric bridges.

## Deferred bridges
Arithmetic geometry → self-adjoint operator → spectral correspondence → zeta zeros are independent proof obligations. RH is a long-term target, not a current empirical conclusion.
