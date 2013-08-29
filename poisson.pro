;generate the functional shape of a poisson distribution
;specify the mean, min, max x-values of the distribution
;set bin to change the bin size of the distribution
;set amp to change the amplitude of the dist.
;
;set montecarlo to generate a distribution from random numbers, instead of using the analytical function.
;set normalize to normalise the monte carlo by n -> probablility
;
;if amp and normalize are not set then the amplitude is N within x->x+dx  

function poisson,mean=inlambda, min=inmin, max=inmax, bin=inbin, $
	amp=inamp, rescale=inrs, $
	montecarlo=montecarlo, nmonte=innmonte, normalize=normalize, $
	outx=outx, outdist=dist

if n_elements(inrs) eq 1 then rs=inrs else rs=1

lambda=double(inlambda)
minp=double(inmin)
maxp=double(inmax)

if n_elements(inbin) ne 1 then binmc=1. else binmc=inbin

if n_elements(normalize) ne 1 then donorm=1 else donorm=0

if n_elements(inamp) ne 1 then amp=0 else amp=inamp

x=bingen(bin=binmc, min=minp, max=maxp)

if keyword_set(montecarlo) then begin
	if n_elements(innmonte) ne 1 then nmonte=10000 else nmonte=innmonte
	dist=randomu(seed,nmonte,poisson=lambda,/double)
	ymc=double(histogram(dist,bin=binmc,min=min(x),max=max(x),loc=xhist))

	;normalise the distribution
	if donorm then ymc=ymc/total(ymc*binmc)

outy=ymc
outx=xhist

endif else begin

	wn=where(x lt 0)
	if wn[0] ne -1 then x[wn]=0
	
	ya=(lambda*rs)^(x)*exp(-lambda*rs)/factorial(x)

outy=ya
outx=x

endelse

if amp ne 0 then outy=outy/max(outy)*amp


return,outy

end