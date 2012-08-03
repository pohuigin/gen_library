;HGLONMAP - output longitude map
;HGLATMAP - output latitude map
;imgsz=size(image_array)
;dxdy=[map.dx,map.dy]
;oflb -> output of offlimb pixels
;mdi -> restore mdi imgsz, dxdy
;TIME=TIME - map.time

pro hglatlon_map, hglonmap,hglatmap, dxdy, imgsz, oflb, time=date, plot=plot, mdi=mdi

;rtgetcarposondisk,pixpos,carlonlat,flagintersection,imsize=imsize,$
;  fovpix=fovpix,$
;  obspos=obspos,obsang=obsang,$
;  c2image=c2image,c3image=c3image,$
;  quiet=quiet,$
;  cor1=cor1,cor2=cor2,hi1=hi1,hi2=hi2,c1fov=c1fov,$
;  hlonlat=hlonlat,secchiab=secchiab,$
;  instr=instr,$
;  obslonlat=obslonlat,$
;  projtype=projtype,rollang=rollang,$
;  scchead=scchead,pv2_1=pv2_1,pcin=pcin

;WCS_CONV_CR_HG, CRLN, HGLN

;function conv_p2h, pix, date0, off_limb=off_limb, $
;		arcmin=arcmin, roll=roll, $
;		hxa=hxa, cmd=cmd, suncenter=suncenter, $
;		pix_size=pix_size0, radius=radius, $
;		string=string

;for i=0,n_elements(hgmap) do begin;
;	thispix=[i mod imgsz[1], i/imgsz[2]];
;;	print,thispix;
;	helio = conv_p2h(thispix, suncenter=xyc, off_limb=off_limb);
;	if off_limb eq 1 then begin;
;		hglatmap[thispix[0],thispix[1]]=-1;
;		hglonmap[thispix[0],thispix[1]]=-1;
;	endif else begin;
;		hglatmap[thispix[0],thispix[1]]=helio[1];
;		hglonmap[thispix[0],thispix[1]]=helio[0];
;	endelse;
;endfor;
;;
;stop;

if keyword_set(mdi) then begin
	imgsz=[2,1024,1024]
	dxdy=[1.98403,1.98403]
endif

hglatmap=fltarr(imgsz[1],imgsz[2])
hglonmap=fltarr(imgsz[1],imgsz[2])


angx=rot(congrid(transpose(findgen(imgsz[1])/(imgsz[1]*1.)*(dxdy[0]*imgsz[1])-dxdy[0]*imgsz[1]/2.),imgsz[1],imgsz[2]),90)
angy=congrid(transpose(findgen(imgsz[2])/(imgsz[2]*1.)*(dxdy[1]*imgsz[2])-dxdy[1]*imgsz[2]/2.),imgsz[1],imgsz[2])

angxy=[reform(angx,1,long(imgsz[1])*long(imgsz[2])),reform(angy,1,long(imgsz[1])*long(imgsz[2]))]/60.
hglonlat=conv_a2h(angxy, date, /arcmin, off_limb=oflb, string=string)

hglonmap=reform(hglonlat[0,*],imgsz[1],imgsz[2])
hglatmap=reform(hglonlat[1,*],imgsz[1],imgsz[2])
oflb=reform(oflb,imgsz[1],imgsz[2])
woff=where(oflb eq 1)
hglonmap[woff]=-10d3
hglatmap[woff]=-10d3

if (where(finite(hglonmap) ne 1))[0] ne -1 then hglonmap[where(finite(hglonmap) ne 1)]=-10d3
if (where(finite(hglatmap) ne 1))[0] ne -1 then hglatmap[where(finite(hglatmap) ne 1)]=-10d3

if keyword_set(plot) then begin
	phglonmap=hglonmap
	phglatmap=hglatmap
	phglonmap[woff]=-180.
	phglatmap[woff]=-90.
	window,5,xs=800,ys=400
	!p.multi=[0,2,1]
	plot_image,phglonmap
	plot_image,phglatmap
	!p.multi=[0]
endif

return

end