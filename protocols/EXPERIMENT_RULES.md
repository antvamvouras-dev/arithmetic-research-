# Experiment Rules v1

## Before execution
Every confirmatory experiment must state:
- question and null hypothesis;
- dataset/range and chronological split;
- state representation;
- estimator and smoothing;
- preselected hyperparameters;
- primary metric and diagnostics;
- stopping rule / number of replicas when simulation is required;
- expected failure modes.

## Reproducibility
Each run writes a manifest containing:
`experiment_id`, UTC timestamp, git commit, environment, N/range, window, seed or seed policy, null model, modulus, bins, split, smoothing, metrics, runtime and output hashes/paths.

## Calibration before significance
A synthetic null is not admissible for significance claims until it reproduces the intended lower-order structure within declared tolerances. Report at least:
- marginal total variation distance;
- first-order transition TV distance;
- residue-state TV distance where applicable;
- fallback/backoff rate;
- observed-state coverage.

## Monte Carlo discipline
Before increasing replicas, ask whether the target is available by exact enumeration, matrix propagation, dynamic programming, conditional expectation, analytic variance, deterministic quadrature or a hybrid decomposition.

## Language discipline
Use `observable`, `score`, `divergence`, `state graph`, or `statistical geometry candidate` until the mathematical hypotheses required for stronger geometric terms have been established.
