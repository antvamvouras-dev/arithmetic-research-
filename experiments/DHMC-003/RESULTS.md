# DHMC-003 Results — Residual Concentration

## Main result
The residual beyond the exact wheel is **not uniformly diffuse across state space**.

For \(m=6\), the effect is strongly concentrated. Across four windows:
- mean \(K\): 0.023565 nats/transition;
- only ~43.3% of contexts have positive mean \(K\);
- only ~46.1% of observed test occupancy lies in positive-mean contexts;
- top 1% of contexts account for ~18.0% of total absolute residual contribution;
- top 5% account for ~62.4%;
- top 10% account for ~86.5%;
- effective number of contributing contexts is only ~9.1 despite 72–82 observed contexts/window;
- absolute-contribution Gini ~0.888.

For \(m=30\), the residual is broader but still substantially concentrated:
- mean \(K\): 0.030780 nats/transition;
- ~65.2% of contexts have positive mean \(K\);
- ~93.5% of observed test occupancy lies in positive-mean contexts;
- top 1% of contexts account for ~14.7% of total absolute residual contribution;
- top 5% account for ~42.9%;
- top 10% account for ~67.1%;
- effective number of contributing contexts is ~39.6 despite 207–235 observed contexts/window;
- absolute-contribution Gini ~0.820.

## Window results

| window | m | mean K | median K | contexts | positive-context fraction | occupancy in positive contexts | top 5% abs share | effective contexts | Gini |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|1|6|0.021180|0.000000|72|0.4306|0.5209|0.6090|8.39|0.8893|
|2|6|0.023441|0.000000|74|0.4730|0.4415|0.5877|9.04|0.8826|
|3|6|0.025389|0.000000|82|0.4268|0.4507|0.6532|9.54|0.8896|
|4|6|0.024252|0.000000|82|0.4024|0.4324|0.6469|9.34|0.8899|
|1|30|0.028092|0.036994|207|0.6667|0.9418|0.4016|39.63|0.8151|
|2|30|0.030807|0.048380|217|0.6728|0.9586|0.4300|38.72|0.8158|
|3|30|0.033214|0.037737|229|0.6419|0.9066|0.4407|39.90|0.8257|
|4|30|0.031005|0.048535|235|0.6255|0.9344|0.4448|40.22|0.8218|

## Dominant pooled contexts
For \(m=6\), the largest absolute contributors are the highly occupied contexts with gaps 6, 12, 18, 24, 30 split across residues 1 and 5 mod 6. The pair \((g=6,r=1)\) alone contributes ~17.7% of pooled absolute residual contribution, and \((6,5)\) another ~17.1%.

For \(m=30\), no single context dominates as strongly. Leading contributors include \((6,29)\), \((6,7)\), \((6,17)\), \((4,23)\), \((2,13)\), \((6,13)\), and several gap-12 contexts. The largest single pooled context contributes ~4.7% of absolute residual contribution.

## Interpretation
The residual is therefore **structured and heterogeneous**, not a uniform background effect.

- \(m=6\): highly concentrated in a small number of common arithmetic contexts. This weakens any interpretation of the residual as a global state-space-wide phenomenon.
- \(m=30\): broader and much more occupancy-wide, but still concentrated relative to a genuinely diffuse signal.

This does not establish a new prime law. The next test should ask whether the dominant contexts are explained by richer finite-sieve information (e.g. mod 210 or explicit local admissibility motifs), and whether the same ranked contexts persist under chronological resampling and block uncertainty estimates.
