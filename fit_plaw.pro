;Purpose:	fit data using a function of the form y=c*x^(a)
;			assumes 1/n poisson error for each data pt., unless NOPOISSON is set.
;
;Result:	the [c,a] fitting parameters, and optionally fit data for over plotting.
;
;Use:		p=fit_plaw(xx, yy, yfit=yfit, test=test)
;
;Issues:	Routine finds the power-law slope perfectly but can not find the "c" parameter at all, and 
;			breaks if there is any Y-offset in the input data

function fit_plaw, inxx, inyy, yfit=outyfit, xfit=outxfit, perror=perror,test=test, $
	limxfit=xfitlim, chisqred=chisqdred, nopoisson=nopoisson

xx=inxx
yy=inyy

;crop data to specified limits
if n_elements(xfitlim) eq 2 then begin
	wlim=where(xx gt min(xfitlim) and xx lt max(xfitlim))
	if wlim[0] eq -1 then print,'data is not within specified limits'
	xx=xx[wlim]
	yy=yy[wlim]
endif else print,'xfitlim must be 2 elements'


;take log of each array
x10=alog10(xx)
y10=alog10(yy)

;get rid of non finite data points
wgoodx=where(finite(x10) eq 1)
x10=x10[wgoodx]
y10=y10[wgoodx]
wgoody=where(finite(y10) eq 1)
x10=x10[wgoody]
y10=y10[wgoody]

;center the function near zero to reduce errors
meany=mean(y10)
y10s=y10-meany

;Fitting Proof
;X=log(x)
;Y=log(y)
;y=b*x^a+c
;log(y)=log(b*x^a+c)
;assume c negligible
;Y=log(b*x^a)
;Y=log(b)+log(x^a)
;B=logb
;Y=B+a*log(x)
;Y=B+a*X

;assume poisson errors
if not keyword_set(nopoisson) then yerr=abs(1./y10)

;do linear fitting
param=mpfitexpr('P[0]+P[1]*X', x10, y10s, yerr, [1.,1.],yfit=fitp,perror=perror)

;compensate for the introduced off-set
b=10.^(param[0]+meany)

;repower-law the fit data
yfit=b*xx^(param[1])

;Calculate reduced ChiSQd for fit
;Weights = 1/STDV or 1/Y?? or 1/N?
weights=1./yy
chisqd=total((yy-yfit)^2*weights)
chisqdred=chisqd/float(n_elements(yy)-2.)

outyfit=yfit
outxfit=xx

;plot the fit
if keyword_set(test) then begin
plot, xx, yy,/xlog,/ylog,ps=-4,color=180,/xsty,/ysty
setcolors,/sys,/silent
oplot,xfitout,yfit,color=!green
endif

return,param

end