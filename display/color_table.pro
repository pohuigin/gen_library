pro color_table, minmax, x12,y12, left=left, right=right, top=top,bottom=bottom,title=title, rr=rr, gg=gg, bb=bb, log=log, $
	shadowtext=shadowtext, vertical=vertical,color=incolor, nodata=noplotdata, charthick=incharthick, charsize=incharsize

if n_elements(incharsize) ne 0 then charsize=1.4 else incharsize=charsize

if n_elements(incharthick) eq 0 then charthick=5 else charthick=incharthick

if n_elements(incolor) eq 0 then color=255 else color=incolor

if not keyword_set(noplotdata) then begin
	tvlct,rr0,gg0,bb0,/get
	if n_elements(rr) gt 1 and n_elements(gg) gt 1 and n_elements(bb) gt 1 then tvlct,rr,gg,bb
endif

min0=minmax[0]
max0=minmax[1]

if keyword_set(vertical) then ctarr=transpose(rebin(findgen(255)/254.*(max0-min0)+min0,255,50)) $
	else ctarr=rebin(findgen(255)/254.*(max0-min0)+min0,255,50)

if n_elements(x12) lt 2 or n_elements(y12) lt 2 then thispos=[.6,.85,.95,.9] else thispos=[x12[0],y12[0],x12[1],y12[1]]

thisscale=double(max0-min0)/254d
thisorigin=min0 > thisscale
if keyword_set(log) then thisoriginx=thisorigin  else thisoriginx=min0

;origpos=!p.position
;!p.position=[.5,.8,.8,.9]

;plot the color gradient
if not keyword_set(noplotdata) then plot_image,ctarr[1:*,*],position=thispos,yticklen=.001,xticklen=.001,xtit='',ytit='',/noerase,xtickname=strarr(10)+' ',ytickname=strarr(10)+' '

;stop

setcolors,/sys,/silent

if not keyword_set(vertical) then begin
	if keyword_set(shadowtext) then begin
		plot,fltarr(100,100),yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,xran=minmax,xticklen=1,xlog=log,color=!black,thick=2,charthick=4,/nodata
		plot,fltarr(100,100),yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,xran=minmax,xticklen=1,xlog=log,color=!white,thick=2,charthick=1.4,/nodata
	endif else plot,fltarr(100,100),yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=charsize,position=thispos,xran=minmax,xticklen=1,xlog=log,color=color,thick=2,charthick=charthick,/nodata;,xticks=2
endif else begin
	if keyword_set(shadowtext) then begin
		plot,fltarr(100,100),xticklen=.001,xtickname=strarr(10)+' ',ytit=title,/noerase,charsize=1.4,position=thispos,yran=minmax,yticklen=1,ylog=log,color=!black,thick=2,charthick=4,/nodata
		plot,fltarr(100,100),xticklen=.001,xtickname=strarr(10)+' ',ytit=title,/noerase,charsize=1.4,position=thispos,yran=minmax,yticklen=1,ylog=log,color=!white,thick=2,charthick=1.4,/nodata
	endif else plot,fltarr(100,100),xticklen=.001,xtickname=strarr(10)+' ',ytit=title,/noerase,charsize=charsize,position=thispos,yran=minmax,yticklen=1,ylog=log,color=color,thick=2,charthick=charthick,/nodata;,xticks=2
endelse

;plot_image,ctarr[1:*,*],yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=2,position=thispos,origin=[thisoriginx,thisorigin],scale=thisscale,xticklen=1,xlog=log,/nodata,color=0;,xticks=2


if not keyword_set(noplotdata) then tvlct,rr0,gg0,bb0




;!p.position=origpos

end