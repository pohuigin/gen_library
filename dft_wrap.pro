pro dft_wrap, fxarr, fyarr, xout, yout, plotx, ploty, frange=infran, plot=plot, ps=ps, wpeak=outwpeak, xpeak=outxpeak,_extra=_extra

n=1024.
if n_elements(infran) lt 1 then fran=[0,1./reverse(xarr[0])] else fran=infran

foutx=findgen(n)/(n-1.)*(fran[1]-fran[0])+fran[0];*0.00555556*2.

dft,fxarr,fyarr,foutx,fouty

power=abs(fouty)^2.

xout=foutx
yout=power

peakwidth=1./(fxarr[2]-fxarr[1])
sensitive=.001;max(power[n_elements(power)/2.:*])*.1
peakselect, wpeakarr, peakarr, npeaks = 20., power = power, secarr = foutx,sensitive=sensitive,range=[.001,.01]
wpeakarr=reverse(wpeakarr[sort(peakarr)])
peakarr=reverse(peakarr[sort(peakarr)])
;xran=[foutx[wpeakarr[1]],(reverse(foutx))[0]]
yran=[0,max(power[wpeakarr[1:*]])];power[wpeakarr[1]]*20.];[0,sensitive*20.]

outwpeak=wpeakarr
outxpeak=peakarr

if keyword_set(plot) then begin
	if not keyword_set(ps) then setplotenv,/xwin
	!p.background=255
	!p.color=0
	pmulti=!p.multi
	!p.multi=[0,1,2]
	setcolors,/sys,/quiet

	plot,fxarr/365.,fyarr,_extra=_extra,/xsty;,xtit='X',ytit='Y'
	
	
	plot,foutx,power,xtit='Period [months]',ytit='Power',xran=xran,/xsty,yran=yran,xtick_get=getxtick,xtickname=strarr(10)+' ';,/ylog
	getxtick=1./getxtick/(365./12.) & getxtick[0]=0.
	axis,xaxis=0,xtickname=string(strtrim(getxtick,2),form='(A4)'),/xsty

	vline,peakarr,color=!red,lines=2
	
	!p.multi=pmulti
endif

plotx=foutx
ploty=power

end