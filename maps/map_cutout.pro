;Make a cut-out map structure with updated fits header info.
;Input arcsec. center, height, and width

function map_cutout,inmap, xycen=inxycen, xwidth=inxwidth, yheight=inyheight, $
         auxdat1=auxdat, outauxdat1=outauxdat, auxdat2=auxdat2, outauxdat2=outauxdat2, $
         auxdat3=auxdat3, outauxdat3=outauxdat3, refmap=refmap,buffval=buffval
;,indata,rebin1k=rebin1k,xy=xy, reduce=reducexy, _extra=_extra, $
;newdata=data

map=inmap

;stop

;Buffer the map image so that it doesn't get truncated when
;making a zoom near the limb.
map=map_buffer(map,buffval=buffval)

if keyword_set(refmap) then begin
   xycen=[refmap.xc,refmap.yc]
   refsz=size(refmap.data,/dim)
   xwidth=refsz[0]*refmap.dx
   yheight=refsz[1]*refmap.dy
   
;Use a reference map to make the cut-out
   sub_map,map,submap,ref_map=refmap,/preserve,/noplot

endif else begin
   xycen=inxycen
   xwidth=inxwidth
   yheight=inyheight

;Make the cut-out map
   sub_map,map,submap,xrange=[xycen[0]-xwidth/2.,xycen[0]+xwidth/2.],yrange=[xycen[1]-yheight/2.,xycen[1]+yheight/2.],/noplot
endelse

if keyword_set(auxdat) then begin
   auxmap=inmap
   auxmap.data=auxdat
   auxmap=map_buffer(auxmap)

   sub_map,auxmap,subaux,ref_map=submap,/preserve,/noplot
   outauxdat=subaux.data
endif
if keyword_set(auxdat2) then begin
   auxmap2=inmap
   auxmap2.data=auxdat2
   auxmap2=map_buffer(auxmap2)

   sub_map,auxmap2,subaux2,ref_map=submap,/preserve,/noplot
   outauxdat2=subaux2.data
endif
if keyword_set(auxdat3) then begin
   auxmap3=inmap
   auxmap3.data=auxdat3
   auxmap3=map_buffer(auxmap3)

   sub_map,auxmap3,subaux3,ref_map=submap,/preserve,/noplot
   outauxdat3=subaux3.data
endif

sz=size(submap.data,/dim)

maptag=strlowcase(tag_names(submap))

;Update the map tags

;stop

if (where(maptag eq 'crpix1'))[0] ne -1 then submap.CRPIX1=-xycen[0]*submap.dx;in px
if (where(maptag eq 'crpix2'))[0] ne -1 then submap.CRPIX2=-xycen[1]*submap.dy
;if (where(maptag eq 'crval1'))[0] ne -1 then submap.CRVAL1=
;if (where(maptag eq 'crval2'))[0] ne -1 then submap.CRVAL2=
;if (where(maptag eq 'cdelt1'))[0] ne -1 then submap.CDELT1=submap.CDELT1*reducexy[0]
;if (where(maptag eq 'cdelt2'))[0] ne -1 then submap.CDELT2=submap.CDELT2*reducexy[1]
if (where(maptag eq 'naxis1'))[0] ne -1 then submap.NAXIS1=xwidth*submap.dx
if (where(maptag eq 'naxis2'))[0] ne -1 then submap.NAXIS2=yheight*submap.dy
;if (where(maptag eq 'plate_x'))[0] ne -1 then submap.plate_x=xwidth*submap.dx/2.+xycen[0]*submap.dx;in px
;if (where(maptag eq 'plate_y'))[0] ne -1 then submap.plate_y=ywidth*submap.dy/2.+xycen[1]*submap.dy;in px
;if (where(maptag eq 'x_offset'))[0] ne -1 then submap.x_offset=-xycen[0]
;if (where(maptag eq 'y_offset'))[0] ne -1 then submap.y_offset=-xycen[1]
if (where(maptag eq 'xcen'))[0] ne -1 then submap.xcen=xycen[0]
if (where(maptag eq 'ycen'))[0] ne -1 then submap.ycen=xycen[1]
;if (where(maptag eq 'mdi_x0'))[0] ne -1 then submap.mdi_x0=xwidth*submap.dx/2.+xycen[0]*submap.dx;
;if (where(maptag eq 'mdi_y0'))[0] ne -1 then submap.mdi_y0=xwidth*submap.dx/2.+xycen[0]*submap.dx;

;if (where(maptag eq 'x0'))[0] ne -1 then submap.x0=xwidth*submap.dx/2.+xycen[0]*submap.dx;
;if (where(maptag eq 'y0'))[0] ne -1 then submap.y0=xwidth*submap.dx/2.+xycen[0]*submap.dx;

;if (where(maptag eq 'center_x'))[0] ne -1 then submap.center_x=xwidth*submap.dx/2.+xycen[0]*submap.dx;
;if (where(maptag eq 'center_y'))[0] ne -1 then submap.center_y=xwidth*submap.dx/2.+xycen[0]*submap.dx;

;	if not dodata then begin 
;		submap.xc=submap.xc/reducexy[0]
;		submap.yc=submap.yc/reducexy[1]
;		submap.dx=submap.dx*reducexy[0]
;		submap.dy=submap.dy*reducexy[1]
;		submap.roll_center=submap.roll_center/reducexy
;	endif

return,submap

end
