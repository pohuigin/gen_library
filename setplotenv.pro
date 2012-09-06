pro setplotenv, xwin=xwin, psfile=psfile, default=default, filename=filename, $
                xs=xs, ys=ys, sys=sys, _extra=_extra,silent=silent

if not keyword_set(sys) then nocolors=1

if not keyword_set(xwin) and not keyword_set(psfile) and not keyword_set(default) then xwin=1

if not keyword_set(filename) then filename=''

if keyword_set(default) then begin
	!x.thick = 0
	!y.thick = 0
	!p.thick = 0
	!p.charsize = 0
	!p.charthick = 0
	!p.psym = 0
	!p.font = -1

	if not keyword_set(silent) then print,[[' '],['Environment variables have been set to default.'],[' ']]
endif

if keyword_set(xwin) then begin
	if keyword_set(_extra) then window, 8, retain=2, _extra=_extra else begin
		window, 8,xsize=800,ysize=600, retain=2
		wset, 8
	endelse

	!x.thick = 2
	!y.thick = 2
	!p.thick = 2
	!p.charsize = 2
	!p.charthick = 2
;	!p.psym = 8
	!p.font = 1
	DEVICE, SET_FONT='Times Bold', /TT_FONT 

	if not keyword_set(silent) then print,[[' '],['Environment variables have been optimized for XWindows.'],[' ']]
endif

if keyword_set(psfile) then begin
        if not keyword_Set(xs) then xs=14
        if not keyword_Set(ys) then ys=8
	!x.thick = 10
	!y.thick = 10
	!p.thick = 5
	!p.charsize = 2
	!p.charthick = 5
;	!p.psym = 8
	!p.font = 0

	tvlct,rr,gg,bb,/get
	save,rr,gg,bb,file='tmp_ct_store.sav'

	if not keyword_set(silent) then print,[[' '],['Environment variables have been optimized for PostScript.'],[' ']]

;	if not keyword_set(_extra) then begin & carl=1 & encapsulate=1 & endif
;	if keyword_set(filename) then psopen,filename, /times, /bold, /inch, $
;		encapsulate=encapsulate, _extra=_extra

	if keyword_set(filename) then begin
		if keyword_set(nofont) then psopen,filename, /inch, /encapsulate, xs=xs, ys=ys, _extra=_extra, /color,font=-1 $
			else psopen,filename, /bold, /inch, /encapsulate, xs=xs, ys=ys, _extra=_extra, /color,/helvetica;, /times
		setcolors,nocolors=nocolors,sys=sys,silent=silent
	endif


	if not keyword_set(silent) then if keyword_set(filename) then print,[[' '],['PostScript file has been opened.'],[' ']]
endif

end
