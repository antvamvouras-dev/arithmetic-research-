import numpy as np, pandas as pd, json

SEED=20260913
N=500
REPS=200
P_GRID=np.linspace(0.0005,0.0060,45)

class UF:
    def __init__(self,n):
        self.p=np.arange(n); self.sz=np.ones(n,dtype=int); self.maxsz=1
    def find(self,a):
        while self.p[a]!=a:
            self.p[a]=self.p[self.p[a]]; a=self.p[a]
        return a
    def union(self,a,b):
        ra,rb=self.find(a),self.find(b)
        if ra==rb:return
        if self.sz[ra]<self.sz[rb]: ra,rb=rb,ra
        self.p[rb]=ra; self.sz[ra]+=self.sz[rb]
        self.maxsz=max(self.maxsz,self.sz[ra])

def curve(n,rng,p_grid):
    i,j=np.triu_indices(n,1)
    w=rng.random(len(i))
    order=np.argsort(w)[::-1]
    uf=UF(n); added=0; m=len(w); out=[]
    for p in sorted(p_grid):
        target=int(round(p*m))
        while added<target:
            e=order[added]; uf.union(i[e],j[e]); added+=1
        out.append((p,uf.maxsz/n))
    return out

rng=np.random.default_rng(SEED)
rows=[]; p10=[]
for r in range(REPS):
    c=curve(N,rng,P_GRID)
    rows += [(r,p,g) for p,g in c]
    p10.append(next((p for p,g in c if g>=0.10), np.nan))

df=pd.DataFrame(rows,columns=["replicate","p","giant_fraction"])
summary={
  "seed":SEED,"n":N,"replicates":REPS,
  "theoretical_pcrit":1/N,
  "p10_mean":float(np.nanmean(p10)),
  "p10_sd":float(np.nanstd(p10,ddof=1)),
  "p10_median":float(np.nanmedian(p10))
}
df.to_csv("pn_er_replicates_raw.csv",index=False)
json.dump(summary,open("pn_er_summary.json","w"),indent=2)
print(summary)
