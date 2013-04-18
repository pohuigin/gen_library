;Rebin a map structure with fill fits header to some reduced resolution
;REBIN1K = reduce a 4096x4096 image to 1024x1024
;XY = array of new [X size, Y size] for the map.
;	If map size if an integer multiple of XY then REBIN() is used, otherwise CONGRID() is used 
;REBIN and CONGRID keywords can be fed through _EXTRA=_EXTRA
function map_rebin,inmap,rebin1k=rebin1k,xy=xy, _extra=_extra
map=inmap

data=map.data

if keyword_set(rebin1k) then begin	
;Reduce resolution to 1kx1k
	data=rebin(map.data,1024,1024) ;reduce resolution using neighborhood averaging
	map.CRPIX1=map.CRPIX1/4.
	map.CRPIX2=map.CRPIX2/4.
;		index.CRVAL1=???
;		index.CRVAL2=???
	map.CDELT1=map.CDELT1*4.
	map.CDELT2=map.CDELT2*4.
	map.NAXIS1=map.NAXIS1/4.
	map.NAXIS2=map.NAXIS2/4.

endif

if keyword_set(xy) then begin
	sz=size(map.data,/dim)
	if xy[0] mod sz[0] eq 0 and xy[1] mod sz[1] eq 0 then data=rebin(map.data,xy[0],xy[1],_extra=_extra) $
		else data=congrid(map.data,xy[0],xy[1],_extra=_extra)

	xfrac=float(sz[0])/float(xy[0])
	yfrac=float(sz[0])/float(xy[0])

	map.CRPIX1=map.CRPIX1/xfrac
	map.CRPIX2=map.CRPIX2/yfrac
;		index.CRVAL1=???
;		index.CRVAL2=???
	map.CDELT1=map.CDELT1*xfrac
	map.CDELT2=map.CDELT2*yfrac
	map.NAXIS1=map.NAXIS1/xfrac
	map.NAXIS2=map.NAXIS2/yfrac

endif

add_prop,map,data=data,/replace

return,map

end