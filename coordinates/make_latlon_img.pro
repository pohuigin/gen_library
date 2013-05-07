;----------------------------------------------------------------------------->

;Re-map images to a Lat-Lon grid
;setting NOREMAP just returns the averaged magnetogram and nothing else.
function make_latlon_img, infiles, map=inmap, mag=setmag, posmag=setpos, negmag=setneg, $
	euv=seteuv, tmid=tmid, logscale=logscale, missval=missval, $
	latbin=latbin, lonbin=lonbin, lonbound=lonbound, latbound=latbound, $
	setrebin=setrebin, rebinfact=rebinfact, dofilter=dofilter, $
	outfluxmap=outfluxmap, outmask=projmask, outhg=hgcoord, outavgimg=avgimg, $
	noremap=noremap

rsunmm=695.5 ;radius of sun in Mm
radpasec=2.*!pi/(360.*3600.)
missval=-9999.

if n_elements(inmap) gt 0 and data_type(inmap) eq 8 then begin

	map_arr=inmap

endif else begin

	ff=infiles
	nff=n_elements(ff)

	for j=0,nff-1 do begin

		if keyword_set(seteuv) then map=make_butterfly_euv(ff[j], logscale=logscale, index=outind)

		if keyword_set(setmag) then map=make_butterfly_mag(ff[j], index=outind, dofilter=dofilter)

		if j eq 0 then map_arr=map else map_arr=[map_arr,map]

	endfor

	inindex=outind

endelse

map_rot=drot_map(map_arr,time=anytim(tmid,/vms), miss=missval)

if n_elements(map_rot) lt 2 then imgavg=map_rot.data $
	else imgavg=average(map_rot.data,3,miss=missval)

;Make positive only or negative only version of the magnetogram
if keyword_set(setmag) then begin
	if keyword_set(setpos) then imgavg = imgavg > 0.
	if keyword_set(setneg) then imgavg = imgavg < 0.
endif

;AVERAGE MAP STACK IN Z
;SET MISS VAL, AVERAGE WITHOUT THE MISS VAL


;MAKE GRID ON IMAGE IN HGLAT LON, PROJECT TO LAT-LON GRID, SEE IF IT IS CORRECT!!!
;!!! Need to make this depend on Lat-Lon resolution !!! use input latbin and lonbin
;projdim=[361,181]

nlat=ceil(abs(latbound[1]-latbound[0])/latbin)+1.
nlon=ceil(abs(lonbound[1]-lonbound[0])/lonbin)+1.
projdim=[nlon,nlat]
projlim=[lonbound,latbound]
lon = (findgen(projdim[0])*lonbin+projlim[0]) # replicate(1,projdim[1])
lat = replicate(1,projdim[0]) # (findgen(projdim[1])*latbin+projlim[2])
projmask=fltarr(projdim[0],projdim[1])+1.

;Create World Coordinate System structure
if data_type(inindex) ne 8 then wcs = fitshead2wcs( map_rot ) $
	else wcs = fitshead2wcs( inindex )
COORD = WCS_GET_COORD(WCS)

;Assume image rotation is 0 degrees
wcs.ROLL_ANGLE=0.

;Get coordinate arrays
xx=reform(coord[0,*,*])
yy=reform(coord[1,*,*])
rr=(xx^(2.)+yy^(2.))^(.5)

;Get radius of Sun in arcsecs, particular to the data source
dsunmm=wcs.position.DSUN_OBS/1d6 ;put dist. to sun in Mm
rsunmm=WCS_RSUN(units='Mm') ;radius of sun in Mm
rsunasec=atan(rsunmm/dsunmm)/radpasec

;stop

if keyword_set(setmag) then begin
	;Create cosine correction map
	coscor=rr
	;coscor=coscor/max(coscor)
	coscor=1./cos(asin(coscor/rsunasec))
	coscor[where(rr gt rsunasec)]=1
	;plot,1./!dtor*asin(rr[512:*,512]/rsunasec),coscor[512:*,512] & vline,60 & hline,2
	;Limit correction to maximum area a pixel can cover on edge of disk
	thetalim=asin(1.-(wcs.cdelt)[0]/(rsunasec)) ;should it be half a pixel or a full pixel? asin(1.-(wcs.cdelt)[0]/(2.*rsunasec))
	coscor=coscor < 1./cos(thetalim)
	
	;Cosine correct the image
	imgavg=imgavg*coscor
	fluxmap=imgavg*(map.dx*map.dy*(rsunmm/map.rsun)^(2.))*coscor^(2.)
endif

avgimg=imgavg
if keyword_set(noremap) then return,avgimg

;!!!TO DO!!! (DONE! 20100526 - P.A.H.)
;output mask of where pixels cover
;output number of images used to make slice
;output transformed image
;output number of pixels included in each latitude slice (collapse masks in longitude??)
; do coordinate conversion here:

if keyword_set(setrebin) then begin
	;Rebin the image to 1/4 to increase SNR
	;Optimized for images of 1k x 1k!! Must be evenly divisable by BINFACTOR
	if n_elements(rebinfact) ne 1 then binfactor=4. else binfactor=rebinfact
	wcs.cdelt=wcs.cdelt*binfactor
	wcs.crpix=wcs.crpix/binfactor
	wcs.naxis=wcs.naxis/binfactor
	;imgavgrb=rebin(imgavg,(wcs.naxis)[0],(wcs.naxis)[1])
	imgavgrb=reduce(imgavg,binfactor,binfactor,/average,miss=missval)
	if keyword_set(setmag) then fluxmaprb=reduce(fluxmap,binfactor,binfactor,/average,miss=missval)
endif else begin
	imgavgrb=imgavg
	if n_elements(fluxmap) eq 0 then fluxmap=imgavg
	fluxmaprb=fluxmap
endelse
undefine,COORD

;Remap image to Lat-Lon grid 
;wcs_convert_to_coord, wcs, coord, ’HG’, lon, lat
HGLN=lon & HGLT=lat
WCS_CONVERT_TO_COORD, WCS, COORD, 'HG', HGLN, HGLT
pixel = wcs_get_pixel( wcs, coord )
proj = reform( interpolate( imgavgrb, pixel[0,*,*], pixel[1,*,*] ))
if keyword_set(setmag) then fluxproj = reform( interpolate( fluxmaprb, pixel[0,*,*], pixel[1,*,*] ))

hgcoord=[[[HGLN]],[[HGLt]]]

;Replace missing pixels
wmiss=where(proj eq missval)
if wmiss[0] ne -1 then begin
	proj[wmiss]=missval
	projmask[wmiss]=0.
	if keyword_set(setmag) then fluxproj[wmiss]=missval
endif


;proj=wcspixcoord( dum, outx, outy, xx=xx, yy=yy, outdex=indproj, index=inindex, data=imgavg, $
;	/project, /hgs, resolution=[1.,1.], /cos_correction)

;OUTPUT MASK OF IMAGE AVERAGING

;OUTPUT N IMAGES FOR SLICE

outproj=proj
if keyword_set(setmag) then outfluxmap=fluxproj

return,outproj

end

;----------------------------------------------------------------------------->
