# DHMC-003 — Residual Concentration Across State Space

## Question
Is the residual information

\[
K_m(g_t,r_t,g_{t+1})=\log\frac{P_R(g_{t+1}\mid g_t,r_t)}{P_W(g_{t+1}\mid g_t,r_t)}
\]

diffuse across the arithmetic state space, or concentrated in a small subset of contexts/transitions?

## Data
Primes up to \(N=10^7\), four equal chronological non-overlapping windows, same 50/50 train/test split and frozen hyperparameters from DHMC-002.

## State definitions
- context: \((g_t,r_t\bmod m)\)
- transition type: \((g_t,r_t\bmod m,g_{t+1})\)
- moduli: \(m=6,30\)

## Models
- wheel baseline \(P_W\): gap-only first-order law restricted to exact wheel admissibility and renormalized.
- residue model \(P_R\): residue-conditioned empirical law on admissible support, shrunk toward \(P_W\), with DHMC-002 hyperparameters frozen.

## Concentration diagnostics
For contexts and transition types, compute:
- share of total absolute residual contribution captured by top 1%, 5%, 10%, 20%;
- share of positive signed contribution captured by top subsets;
- participation ratio / effective number of contributors;
- Gini coefficient of absolute contribution;
- fraction of contexts with positive mean \(K\);
- occupancy fraction of test transitions lying in positive-mean contexts.

## Interpretation rule
A residual is called diffuse only if contribution is not dominated by a small subset and positive mean \(K\) is broadly distributed across states. High Gini, low effective contributor count, and large top-k shares imply concentration.
