# DHMC-002 — Deterministic wheel vs residue correction at N=10^7

## Question
Does residue-aware next-gap structure contain held-out predictive information beyond exact finite-wheel admissibility?

## Data
All primes p <= 10^7. Consecutive gaps g_t = p_{t+1}-p_t. The sequence is partitioned into four equal non-overlapping chronological windows.

Within each window:
- first 50% = train pool
- second 50% = untouched test
- within train pool: first 80% fit, last 20% validation

No final-test information is used for tuning.

## Models
### M0 — gap-only baseline
P(g_{t+1}|g_t), estimated from fit/train counts with additive smoothing alpha.

### MW — exact wheel baseline
Take M0 and set probability to zero for candidate next gaps g' such that

gcd((r_t + g') mod m, m) != 1,

where r_t = p_{t+1} mod m. Renormalize on the admissible support.

### MR — residue-aware correction
Estimate P(g_{t+1}|g_t,r_t) from data, restrict it to the same wheel-admissible support, and shrink it toward MW:

lambda = n_context/(n_context + tau)

P_R = (1-lambda) P_W + lambda P_empirical.

This makes the scientific comparison conservative: residue-specific learning must improve on exact arithmetic admissibility, not merely relearn it.

## Hyperparameters
alpha in {0.1, 0.25, 0.5, 1, 2}

tau in {5, 10, 20, 50, 100, 200, 500, 1000}

Chosen independently for each window/modulus using validation log-likelihood only.

## Moduli
m = 6 and m = 30.

## Primary metrics
Wheel gain:

G_W = E_test[log P_W - log P_0]

Residual gain beyond wheel:

R_m = E_test[log P_R - log P_W]

## Interpretation rule
- R_m > 0 consistently across windows: evidence that learned residue-dependent frequencies contain predictive structure beyond exact wheel admissibility at this model order.
- R_m approximately 0: wheel explains the residue effect at this model order.
- R_m < 0: residue learning overfits or adds no useful held-out information.

This experiment does not establish geometry, curvature, a new prime law, or asymptotic structure.
