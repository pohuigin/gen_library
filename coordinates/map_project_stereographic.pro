;Remap the data into a stereographic projection
function map_project_stereographic, inmap, params=params, dparams=dparams, $
	inverse=inverse, inproject=inproject, instgx=instgx, instgy=instgy, $ ;input all of the above to produce an inverse projection
	outstgx=outstgx, outstgy=outstgy, $ ;output these to  allow the inverse projection later on
	outprojlon=outprojlon, outprojlat=outprojlat, outprojdc=outprojdc, $ ;Set these to get the projected HG lat. lon. arrays for overplotting grid lines on the projection
	dplot=doplot
	
map=inmap
image=map.data

ind=map.index
wcs=map.wcs

if n_elements(params) gt 0 then isparams=1 else isparams=0
if isparams then nan=params.nan else nan=1./0.
if isparams then threshlon=params.threshlon else threshlon=90.
if isparams then projscl=params.projscl else projscl=1.

;stop

;Size of input image
imgsz=size(image,/dim)

;Determine the coordinate arrays for the image
COORD = WCS_GET_COORD(WCS) ;coord in sol-x and sol-y
xx=reform(coord[0,*,*])
yy=reform(coord[1,*,*])

;stop

;WTF! WHY is XX a mirror image???
;xx=-xx
;yy=-yy

if keyword_set(inverse) then begin
	;Setup input arrays
	projdat=inproject
	stgx=instgx
	stgy=instgy
	imgszp=size(projdat,/dim)

	;Determine matching tie points between projection and deprojection
	wmatch=where(finite(stgx) eq 1)
	winsx=wmatch mod imgsz[0] ;positions in the output (HPC) image
	winsy=wmatch/imgsz[1]
	wpx=stgx[wmatch] ;positions in the input (stereographic) image
	wpy=stgy[wmatch]
	
	;De-project and interpolate to get back to an HPC projection
	deproj = reform( WARP_TRI( winsx, winsy, wpx, wpy, projdat, output_size=imgsz ))
	deprojmap=map
	deprojmap.data=deproj
	
	return,deprojmap
	
endif

;Get radial array of degrees from D.C. as if image was looking down on the pole. (center=90 deg, limb=0?)
rrfrac=((xx^(2.)+yy^(2.))^(.5))/map.rsun;dparams.rsunasec

;Find minimum and maximum X and Y pixel bounds for limb in image
limbmask=fltarr(imgsz[0],imgsz[1])
limbmask[where(rrfrac le 1)]=1.
xbound=minmax(where(total(limbmask,2)<1 gt 0))
ybound=minmax(where(total(limbmask,1)<1 gt 0))

;Identify off disk pixels
woff=where(rrfrac gt 1.)
rrfrac[woff]=params.nan
rrdeg=asin(rrfrac)/!dtor*(-1.)+90.12

;Get rid of pixels within X number of degrees from the edge (assuming center of image is 90)
wedge=where(rrdeg lt (90.-params.threshlon))
if wedge[0] ne -1 then rrdeg[wedge]=params.nan

;Get azimuthal coordinates
theta=rect2pol(xx,yy)
thsz=size(theta,/dim)
theta=theta[thsz[0]/2:*,*]
;Shift values to positive degrees (and change direction of theta)
theta=(theta-min(theta))/!dtor
theta[woff]=nan

;Project to stereographic coordinates
STEREOGRAPHIC, theta, rrdeg, stgx, stgy ;output is normalised to limb of Sun

;Account for clipping of edges (stretch a bit further)
stgx=stgx*(90./threshlon)
stgy=stgy*(90./threshlon)

;Re-scale the projection coordinates -> scale values to an array a specified factor larger than the original image
stgx=(((stgx+1.)/2.)*(xbound[1]-xbound[0])+xbound[0])*projscl
stgy=(((stgy+1.)/2.)*(ybound[1]-ybound[0])+ybound[0])*projscl

;Insert data values into locations in projected array determined by stereographic X, Y arrays
wins=where(finite(stgx) eq 1)
winsx=stgx[wins]
winsy=stgy[wins]

;Project and Interpolate the image
projdat = reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[1]), map.data, output_size=imgsz*projscl ))

if keyword_set(doplot) then begin
	;Project the coordinate arrays
	wcs_convert_from_coord, wcs, coord, ’hg’, hglon, hglat 
	outprojlon = reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[1]), hglon, output_size=imgsz*params.projscl ))
	outprojlat = reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[1]), hglat, output_size=imgsz*params.projscl ))
	;HG Angle from disk center (latitute if looking down on pole)
	outprojdc = reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[1]), rrdeg, output_size=imgsz*params.projscl ))

	chole_plotproj, projheii, projmag, projlon, projlat, projdc
	
;	rrdeg=asin(rrfrac)/!dtor*(-1.)+90.
;	outprojdc = reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[1]), rrdeg, output_size=imgsz*params.projscl ))
;	!p.multi=[0,2,1]
;	plot_image,map.data>(-100)<100
;	contour,rrdeg,lev=reverse([89,80,70,60,50,40,30,20,10]),c_lines=0,color=0,/over
;	contour,rrdeg,lev=reverse([89,80,70,60,50,40,30,20,10]),c_lines=2,color=255,/over
;	plot_image,rot(projdat,180)>(-100)<100
;	contour,outprojdc,lev=reverse([89,80,70,60,50,40,30,20,10]),c_lines=0,color=255,/over
;	contour,outprojdc,lev=reverse([89,80,70,60,50,40,30,20,10]),c_lines=2,color=0,/over	
	
;	stop
endif




































;Output the stereographic position arrays to allow the inverse projection later on
outstgx=stgx
outstgy=stgy

;Output the projections
;dparams.wcs=wcs
outproj=projdat
return,outproj

end
