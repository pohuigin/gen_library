;Rebin a map structure with fill fits header to some reduced resolution
;REBIN1K = reduce a 4096x4096 image to 1024x1024
;XY = array of new [X size, Y size] for the map.
;	If map size if an integer multiple of XY then REBIN() is used, otherwise CONGRID() is used 
;REBIN and CONGRID keywords can be fed through _EXTRA=_EXTRA
;REDUCE = set to a 2 element array specifying the factor to reduce the image by (e.g., [2,2] will reduce the image size by a factor of 2)
;
;Notes:
;		CAREFUL, setting /rebin1k and setting reduce=[nx,ny] appears to give you two different things, because one uses REBIN() nearest neighbor averaging, and the other uses REDUCE(,/average), some other kind of averaging...

function map_rebin,inmap,indata,rebin1k=rebin1k,xy=xy, reduce=reducexy, _extra=_extra, $
	newdata=data
map=inmap

if n_elements(indata) gt 0 then dodata=1 else dodata=0

if dodata then data=indata else data=map.data

maptag=strlowcase(tag_names(map))

if keyword_set(rebin1k) then begin	
;Reduce resolution to 1kx1k
	data=rebin(data,1024,1024) ;reduce resolution using neighborhood averaging
	if (where(maptag eq 'crpix1'))[0] ne -1 then map.CRPIX1=map.index.CRPIX1/4.
	if (where(maptag eq 'crpix2'))[0] ne -1 then map.CRPIX2=map.index.CRPIX2/4.
;		index.CRVAL1=???
;		index.CRVAL2=???
	if (where(maptag eq 'cdelt1'))[0] ne -1 then map.CDELT1=map.index.CDELT1*4.
	if (where(maptag eq 'cdelt2'))[0] ne -1 then map.CDELT2=map.index.CDELT2*4.
	if (where(maptag eq 'naxis1'))[0] ne -1 then map.NAXIS1=map.index.NAXIS1/4.
	if (where(maptag eq 'naxis2'))[0] ne -1 then map.NAXIS2=map.index.NAXIS2/4.
	if not dodata then begin 
		map.xc=map.xc/4.
		map.yc=map.yc/4.
		map.dx=map.dx*4.
		map.dy=map.dy*4.
		map.roll_center=map.roll_center/4.
	endif
	if where(maptag eq 'wcs') ne -1 then begin
		map.wcs.naxis=map.wcs.naxis/4.
		map.wcs.crpix=map.wcs.crpix/4.
		map.wcs.cdelt=map.wcs.cdelt*4.
;		map.wcs.crval=map.wcs.crval

	endif
endif

if keyword_set(xy) then begin
	sz=size(map.data,/dim)
	if xy[0] mod sz[0] eq 0 and xy[1] mod sz[1] eq 0 then data=rebin(data,xy[0],xy[1],_extra=_extra) $
		else data=congrid(data,xy[0],xy[1],_extra=_extra)

	xfrac=float(sz[0])/float(xy[0])
	yfrac=float(sz[0])/float(xy[0])

	if (where(maptag eq 'crpix1'))[0] ne -1 then map.index.CRPIX1=map.index.CRPIX1/xfrac
	if (where(maptag eq 'crpix2'))[0] ne -1 then map.index.CRPIX2=map.index.CRPIX2/yfrac
;		index.CRVAL1=???
;		index.CRVAL2=???
	if (where(maptag eq 'cdelt1'))[0] ne -1 then map.index.CDELT1=map.index.CDELT1*xfrac
	if (where(maptag eq 'cdelt2'))[0] ne -1 then map.index.CDELT2=map.index.CDELT2*yfrac
	if (where(maptag eq 'naxis1'))[0] ne -1 then map.index.NAXIS1=map.index.NAXIS1/xfrac
	if (where(maptag eq 'naxis2'))[0] ne -1 then map.index.NAXIS2=map.index.NAXIS2/yfrac
	if not dodata then begin 
		map.xc=map.xc/xfrac
		map.yc=map.yc/yfrac
		map.dx=map.dx*xfrac
		map.dy=map.dy*yfrac
		map.roll_center=map.roll_center/[xfrac,yfrac]
	endif
	if where(maptag eq 'wcs') ne -1 then begin
		map.wcs.naxis=map.wcs.naxis/[xfrac,yfrac]
		map.wcs.crpix=map.wcs.crpix/[xfrac,yfrac]
		map.wcs.cdelt=map.wcs.cdelt*[xfrac,yfrac]
;		map.wcs.crval=map.wcs.crval
	endif
endif

if n_elements(reducexy) eq 2 then begin
	data=reduce(map.data,reducexy[0],reducexy[1],/average)
	
	if (where(maptag eq 'crpix1'))[0] ne -1 then map.index.CRPIX1=map.index.CRPIX1/reducexy[0]
	if (where(maptag eq 'crpix2'))[0] ne -1 then map.index.CRPIX2=map.index.CRPIX2/reducexy[1]
;		index.CRVAL1=???
;		index.CRVAL2=???
	if (where(maptag eq 'cdelt1'))[0] ne -1 then map.index.CDELT1=map.index.CDELT1*reducexy[0]
	if (where(maptag eq 'cdelt2'))[0] ne -1 then map.index.CDELT2=map.index.CDELT2*reducexy[1]
	if (where(maptag eq 'naxis1'))[0] ne -1 then map.index.NAXIS1=map.index.NAXIS1/reducexy[0]
	if (where(maptag eq 'naxis2'))[0] ne -1 then map.index.NAXIS2=map.index.NAXIS2/reducexy[1]
	if not dodata then begin 
		map.xc=map.xc/reducexy[0]
		map.yc=map.yc/reducexy[1]
		map.dx=map.dx*reducexy[0]
		map.dy=map.dy*reducexy[1]
		map.roll_center=map.roll_center/reducexy
	endif
	if where(maptag eq 'wcs') ne -1 then begin
		map.wcs.naxis=map.wcs.naxis/reducexy
		map.wcs.crpix=map.wcs.crpix/reducexy
		map.wcs.cdelt=map.wcs.cdelt*reducexy
;		map.wcs.crval=map.wcs.crval
	endif
endif

if not dodata then add_prop,map,data=data,/replace

return,map

end