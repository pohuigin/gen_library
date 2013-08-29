;generate the functional shape of a exponential distribution
;y=exp(-alpha*x)
;where alpha is the slope of the log-linear exponential line
;
;specify the mean, min, max x-values of the distribution
;set bin to change the bin size of the distribution
;set amp to specify an amplitude for the dist.
;
;set montecarlo to generate a distribution from random numbers, instead of using the analytical function.
;set normalize to normalize the amplitude of the dist by N -> becomes probability
;
;if amp and normalize are not set then the amplitude is N within x->x+dx  

function exponential, alpha=inalpha, min=inmin, max=inmax, bin=inbin, $
	amp=inamp, normalize=normalize, $
	montecarlo=montecarlo, nmonte=innmonte, seed=seed, $
	outx=outx, outdist=dist

if keyword_set(normalize) then donorm=1 else donorm=0

if n_elements(inalpha) eq 1 then alpha=double(inalpha) else alpha=1d

minp=double(inmin)
maxp=double(inmax)

if n_elements(inamp) ne 1 then amp=0 else amp=inamp

if n_elements(inbin) ne 1 then binmc=1. else binmc=inbin

x=bingen(bin=binmc, min=minp, max=maxp)

if keyword_set(montecarlo) then begin
	if n_elements(innmonte) ne 1 then nmonte=10000 else nmonte=innmonte
	dist=randomu(seed,nmonte,gamma=1,/double)
	ymc=double(histogram(dist,bin=binmc,min=min(x),max=max(x),loc=xhist))

;normalise the distribution
	if donorm then ymc=ymc/total(ymc*binmc)


	outy=ymc
	outx=xhist

endif else begin

;	wn=where(x lt 0)
;	if wn[0] ne -1 then x[wn]=0
	
	ya=exp(-alpha*x)
	

	outy=ya
	outx=x

endelse

if amp ne 0 then outy=outy/max(outy)*amp

return,outy

end