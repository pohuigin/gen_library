;Rebin a map structure with fill fits header to some reduced resolution
;REBIN1K = reduce a 4096x4096 image to 1024x1024
pro map_rebin,map,rebin1k=rebin1k

if keyword_set(rebin1k) then begin	
;Reduce resolution to 1kx1k
	map.data=rebin(map.data,1024,1024) ;reduce resolution using neighborhood averaging
	map.CRPIX1=map.CRPIX1/4.
	map.CRPIX2=map.CRPIX2/4.
;		index.CRVAL1=???
;		index.CRVAL2=???
	map.CDELT1=index.CDELT1*4.
	map.CDELT2=index.CDELT2*4.
	map.NAXIS1=index.NAXIS1/4.
	map.NAXIS2=index.NAXIS2/4.
endif















end