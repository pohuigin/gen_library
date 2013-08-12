;generate the functional shape of a poisson distribution

function poisson,inx,inlambda, rs=inrs

if n_elements(inrs) eq 1 then rs=inrs else rs=1

x=double(inx)

wn=where(x lt 0)
if wn[0] ne -1 then x[wn]=0

lambda=double(inlambda)

outy=(lambda*rs)^(x)*exp(-lambda*rs)/factorial(x)


return,outy

end