"""
Input format: three XLSX files with prime in column A and gap in column B.
No spreadsheet package is required: the reader uses only zipfile+xml.
"""
import zipfile, xml.etree.ElementTree as ET, re, json, numpy as np, pandas as pd

SEED=20260913
K=6
REPS=1000

def xlsx_rows(path):
    ns={'a':'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
        'r':'http://schemas.openxmlformats.org/officeDocument/2006/relationships'}
    with zipfile.ZipFile(path) as z:
        shared=[]
        if 'xl/sharedStrings.xml' in z.namelist():
            root=ET.fromstring(z.read('xl/sharedStrings.xml'))
            for si in root.findall('a:si',ns):
                shared.append(''.join(t.text or '' for t in si.iter('{%s}t'%ns['a'])))
        wb=ET.fromstring(z.read('xl/workbook.xml'))
        sheet=wb.find('a:sheets/a:sheet',ns)
        rid=sheet.attrib['{%s}id'%ns['r']]
        rels=ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))
        target=next(rel.attrib['Target'] for rel in rels if rel.attrib.get('Id')==rid)
        sp=target.lstrip('/') if target.startswith('/') else (target if target.startswith('xl/') else 'xl/'+target)
        root=ET.fromstring(z.read(sp)); out=[]
        for row in root.findall('.//a:sheetData/a:row',ns):
            vals={}
            for c in row.findall('a:c',ns):
                col=re.match(r'([A-Z]+)',c.attrib.get('r','A1')).group(1)
                v=c.find('a:v',ns)
                if v is None: vals[col]=None; continue
                raw=v.text
                vals[col]=shared[int(raw)] if c.attrib.get('t')=='s' else float(raw)
            out.append(vals)
        return out

def load_gaps(path):
    rows=xlsx_rows(path)
    return np.array([int(r['B']) for r in rows[1:] if isinstance(r.get('B'),(int,float))])

def test(gaps,seed):
    cut=len(gaps)//2
    edges=np.quantile(gaps[:cut],np.arange(1,K)/K,method='nearest')
    B=np.searchsorted(edges,gaps,side='left').astype(int)
    c1=np.full((K,K),.5); c2=np.full((K,K,K),.5)
    for t in range(1,cut-1):
        c1[B[t],B[t+1]]+=1; c2[B[t-1],B[t],B[t+1]]+=1
    p1=c1/c1.sum(1,keepdims=True); p2=c2/c2.sum(2,keepdims=True)
    idx=np.arange(cut,len(B)-1)
    prev,cur,nxt=B[idx-1],B[idx],B[idx+1]
    kval=np.log(p2[prev,cur,nxt])-np.log(p1[cur,nxt])
    E=float(np.mean(kval*kval))
    rng=np.random.default_rng(seed); null=[]
    strata=[np.flatnonzero(cur==c) for c in range(K)]
    for _ in range(REPS):
        pp=prev.copy()
        for pos in strata:
            if len(pos)>1: pp[pos]=rng.permutation(pp[pos])
        kn=np.log(p2[pp,cur,nxt])-np.log(p1[cur,nxt])
        null.append(float(np.mean(kn*kn)))
    null=np.array(null)
    return {
      "G":float(kval.mean()),"E_real":E,"E_null_mean":float(null.mean()),
      "E_excess":float(E-null.mean()),"E_ratio":float(E/null.mean()),
      "E_p_upper":float((1+(null>=E).sum())/(REPS+1))
    }

FILES={
 "1m-2m":"data/1m-2m primes_data.xlsx",
 "10m-11m":"data/10m-11m_data.xlsx",
 "1b-1.001b":"data/1b-1,001b_data.xlsx"
}
out=[]
for i,(name,path) in enumerate(FILES.items()):
    r=test(load_gaps(path),SEED+i); r["dataset"]=name; out.append(r)
pd.DataFrame(out).to_csv("prime_null_calibrated_strain.csv",index=False)
json.dump(out,open("prime_null_calibrated_strain.json","w"),indent=2)
print(pd.DataFrame(out))
