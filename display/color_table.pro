pro color_table, minmax, x12,y12, left=left, right=right, top=top,bottom=bottom,title=title, rr=rr, gg=gg, bb=bb, log=log, $
	shadowtext=shadowtext

tvlct,rr0,gg0,bb0,/get
if n_elements(rr) gt 1 and n_elements(gg) gt 1 and n_elements(bb) gt 1 then tvlct,rr,gg,bb

min0=minmax[0]
max0=minmax[1]
ctarr=rebin(findgen(255)/254.*(max0-min0)+min0,255,50)
if n_elements(x12) lt 2 or n_elements(y12) lt 2 then thispos=[.6,.85,.95,.9] else thispos=[x12[0],y12[0],x12[1],y12[1]]

thisscale=double(max0-min0)/254d
thisorigin=min0 > thisscale
if keyword_set(log) then thisoriginx=thisorigin  else thisoriginx=min0

;origpos=!p.position
;!p.position=[.5,.8,.8,.9]

;plot the color gradient
plot_image,ctarr[1:*,*],position=thispos,yticklen=.001,xticklen=.001,xtit='',ytit='',/noerase,xtickname=strarr(10)+' ',ytickname=strarr(10)+' '

;stop

setcolors,/sys,/silent
if keyword_set(shadowtext) then begin
;	plot_image,ctarr[1:*,*],yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,origin=[thisoriginx,thisorigin],scale=thisscale,xticklen=1,xlog=log,color=0,thick=2,charthick=4;,xticks=2
;	plot_image,ctarr[1:*,*],yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,origin=[thisoriginx,thisorigin],scale=thisscale,xticklen=1,xlog=log,color=255,thick=2,charthick=1.4,/data
	plot,fltarr(100,100),yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,xran=minmax,xticklen=1,xlog=log,color=!black,thick=2,charthick=4,/nodata
	plot,fltarr(100,100),yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,xran=minmax,xticklen=1,xlog=log,color=!white,thick=2,charthick=1.4,/nodata
;endif else plot_image,ctarr[1:*,*],yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,origin=[thisoriginx,thisorigin],scale=thisscale,xticklen=1,xlog=log,color=255,thick=2,charthick=5,/nodata;,xticks=2
endif else plot,fltarr(100,100),yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=1.4,position=thispos,xran=minmax,xticklen=1,xlog=log,color=255,thick=2,charthick=5,/nodata;,xticks=2

;plot_image,ctarr[1:*,*],yticklen=.001,ytickname=strarr(10)+' ',xtit=title,/noerase,charsize=2,position=thispos,origin=[thisoriginx,thisorigin],scale=thisscale,xticklen=1,xlog=log,/nodata,color=0;,xticks=2


tvlct,rr0,gg0,bb0




;!p.position=origpos

end