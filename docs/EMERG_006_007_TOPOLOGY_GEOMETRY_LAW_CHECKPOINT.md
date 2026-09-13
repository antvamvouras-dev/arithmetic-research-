# EMERG-006/007 — TOPOLOGY → GEOMETRY → LAW CHECKPOINT
Date: 2026-09-13
Status: ACTIVE / VERIFY

## EMERG-006 — Can topology support recoverable geometry?

Synthetic system:
- latent space: circle S^1 with known geodesic distance;
- observed object: noisy Potential-Neighborhood weights only;
- graph: symmetric k-NN thresholding of PN;
- recovered geometry: unweighted graph shortest-path metric;
- null: same PN weight distribution randomly reassigned to pairs.

Promotion criterion:
Recovered graph distance must correlate with the latent geodesic distance and strongly exceed the shuffled-PN null.

Main result:
For connected or nearly connected PN graphs, the recovered graph metric tracks latent geometry extremely strongly (Spearman rho about 0.89–0.98), while the shuffled-PN null is approximately zero.

Restricted conclusion:
stable relational neighborhoods can carry enough information to reconstruct a nontrivial metric geometry.

Not established:
- every topology determines a unique geometry;
- every emergent structure has Riemannian curvature;
- a universal metric exists.

## EMERG-007 — Does recovered geometry support a predictive law?

Synthetic dynamics:
- latent dynamics: local diffusion on the same circle;
- training/test split of transitions;
- null models: uniform destination and topology-only uniform-over-neighbors;
- geometry model: transition probability decays with recovered graph distance; scale selected on training data only.

Main result:
- k=4,5: recovered graph geometry is too unreliable/disconnected and is worse than the global uniform null;
- k>=6: recovered geometry begins to beat the uniform null;
- k=8,10: geometry beats uniform by about 1.18–1.20 nats/transition and strongly beats topology-only.

Therefore the chain is conditional:

stable topology -> recoverable metric geometry -> predictive dynamics/law candidate.

Topology alone is not enough. Geometry earns promotion only if it supports held-out predictive structure beyond topology-only and non-geometric nulls.

## Revised emergence hierarchy

1. Distinction
2. Stable relations
3. Compression advantage
4. Macro-order
5. Persistent topology
6. Recoverable geometry
7. Predictive dynamics
8. Law candidate
9. Invariant / theorem layer

Promotion requires calibrated nulls, held-out prediction where relevant, perturbation robustness, finite-size scaling, and independent replication.

## Prime implication

The prime project must not jump from PN topology directly to curvature.

Required ladder:
strongest arithmetic null -> arithmetic PN -> persistent topology excess over null -> recoverable metric/divergence geometry -> geometry-based held-out prediction -> invariant/scaling law -> only then curvature/law language.
