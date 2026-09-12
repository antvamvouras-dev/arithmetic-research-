# Arithmetic Research

A reproducible research repository for arithmetic structure, prime-gap statistics, deterministic/hybrid alternatives to Monte Carlo, information-theoretic residuals, formal verification, and carefully staged geometry/operator hypotheses.

## Research discipline

The repository separates four epistemic levels:

1. **Established mathematics / implemented computation** — definitions, code, proofs, reproducible experiments.
2. **Empirical findings** — results supported by stated data, null models, diagnostics, seeds and commits.
3. **Research hypotheses** — explicit, falsifiable or provable bridges not yet established.
4. **Speculative architecture** — long-range ideas kept separate from active evidence claims.

No claim is promoted across levels without an explicit proof obligation or reproducible benchmark.

## Current flagship chain

Prime data → finite arithmetic state → calibrated null model → residual information → local divergence → candidate information geometry.

Only after this chain is technically supported do we consider metric geometry, curvature, operators, or spectral links.

## Repository map

- `protocols/` — frozen experimental and methodological rules.
- `src/` — reusable implementation code.
- `experiments/` — one directory per preregistered experiment.
- `configs/` — machine-readable experiment configurations.
- `results/` — compact reproducible outputs and manifests; not raw bulk data.
- `notebooks/` — exploratory analysis; never the canonical source of algorithms.
- `lean/` — Lean formalization and API notes.
- `docs/` — research ledger, terminology, audits and theory notes.

## First benchmark

`experiments/DHMC-001/` tests whether finite-state residue-aware Markov computations can replace or sharply reduce Monte Carlo for quantities relevant to the prime-gap null benchmark.
