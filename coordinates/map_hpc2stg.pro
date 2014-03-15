;Use WCS to convert a HPC (plane-of-sky) image to a stereographic deprojected image
;Uses tri-grid interpolation to re-map
;Input map should be created with mindex2map.pro so that map.index and map.wcs tags are available.
;
;Input:
;MAP = some image map with WCS tag
;
;Keywords:
;projlonlatcent = center of the polar projection in lat lon (currently doesn't work!)
;projscl = factor to scale up the projection image size, compared to original image size
;nan = value of NAN to use for filling bad pixels
;threshlon = maximum longitude to project
;mask = input AR mask (or any image to project also)
;projmask = output projected mask
;doprojscl = if set then deproject a pixel scale map
;projpxscl = projected map of pixel scale factor

;.r /archive/ssw/yohkoh/ucon/idl/mcallister/rect2pol.pro

function map_hpc2stg, inmap, inrefimg, projlonlatcent=inprojllc, projscl=inprojscl, nan=innan, threshlon=inthreshlon, $
	mask=mask,projmask=projmask, doprojscl=doprojscl, projpxscl=projpxscl, outrefproj=outrefproj, projlimbxy=projlimbxy, status=status
	status=0
map=inmap
image=map.data
ind=map.index
wcs=map.wcs

if n_elements(inprojllc) eq 2 then projlonlatc=float(inprojllc) else projlonlatc=[0.,0.]

if n_elements(inprojscl) eq 2 then projscl=float(inprojscl) else projscl=1.

if n_elements(innan) eq 1 then nan=innan else nan=(0./0.)

if n_elements(inthreshlon) eq 1 then threshlon=inthreshlon else threshlon=80.

stgmapnum = 4 ;index to tell wcs which map projection you want

;min_lon = 0
;max_lon = 345
;lon_spacing = 15
;min_lat = -75
;max_lat = 90
;lat_spacing = 15

; Based on the ranges for latitude and longitude, as well as their spacing,
; generate the latitude and longitude arrays.
;num_lon = long((max_lon - min_lon)/lon_spacing) + 1
;lon = dindgen(num_lon)*lon_spacing + min_lon
;num_lat = long((max_lat - min_lat)/lat_spacing) + 1
;lat = dindgen(num_lat)*lat_spacing + min_lat
;longitude = dblarr(num_lon,num_lat)
;for i = 0,num_lat - 1 do longitude[*,i] = lon
;latitude = dblarr(num_lon,num_lat)
;for i = 0,num_lon - 1 do latitude[i,*] = lat


;Size of input image
imgsz=size(image,/dim)

;Determine the coordinate arrays for the image
COORD = WCS_GET_COORD(WCS) ;coord in sol-x and sol-y
xx=reform(coord[0,*,*])
yy=reform(coord[1,*,*])

;wcs_convert_from_coord,wcs,coord,'HG',hglon,hglat

;stop


;Get radial array of degrees from D.C. as if image was looking down on the pole. (center=90 deg, limb=0?)
rrfrac=((xx^(2.)+yy^(2.))^(.5))/map.rsun;dparams.rsunasec

;Find minimum and maximum X and Y pixel bounds for limb in image
limbmask=fltarr(imgsz[0],imgsz[1])
limbmask[where(rrfrac le 1)]=1.
xbound=minmax(where(total(limbmask,2)<1 gt 0))
ybound=minmax(where(total(limbmask,1)<1 gt 0))


;Identify off disk pixels
woff=where(rrfrac gt 1.)
if woff[0] ne -1 then rrfrac[woff]=nan
rrdeg=asin(rrfrac)/!dtor*(-1.)+90.12

;Get rid of pixels within X number of degrees from the edge (assuming center of image is 90)
wedge=where(rrdeg lt (90.-threshlon))
if wedge[0] ne -1 then rrdeg[wedge]=nan

;Get azimuthal coordinates where pole is centered on stereographic projection center
theta=(rect2pol(xx,yy)) ;[0:imgsz[0]-1,*]
thsz=size(theta,/dim)
theta=theta[imgsz[0]:*,*]
;Shift values to positive degrees (and change direction of theta)
theta=theta_shift((theta)/!dtor+90.) ;-min(theta)
if woff[0] ne -1 then theta[woff]=nan


;center the projection on a specific point
;hglonc=hglon-projlonlatc[0]
;hglatc=hglat-projlonlatc[1]


;Determine the pixel scaling at each point
sclgrad=ar_losgrad(rrdeg)
pxscl=sclgrad*(2.*!pi*map.rsun/map.dx/360.)

;Maximum projected scaling
maxpxscl=max(pxscl)

;Estimate the deprojected image size by summing the 'true/corrected' pixel sizes, assuming 0 distortion 
;And multiply by the root 2 incase the resulting image is 45deg rotated.
projsz=[total(pxscl[*,imgsz[1]/2.]),total(pxscl[imgsz[0]/2.,*])]*sqrt(2.)

;CONVERSION
; Convert the spherical coordinates into x-y coordinates by using wcssph2xy.
;wcssph2xy,hglonc,hglatc,stgx,stgy,stgmapnum
wcssph2xy,theta,rrdeg,stgx,stgy,stgmapnum
;stgx=-stgx

;Scale in new pixel coord remapped system
if (where(finite(stgx) eq 1))[0] eq -1 or (where(finite(stgy) eq 1))[0] eq -1 then begin
	print,'% MAP_HPC2STG: No good projectable points!
	status=-1
	return,''
endif
minstgx=min(stgx[where(finite(stgx) eq 1)])
minstgy=min(stgy[where(finite(stgy) eq 1)])
stgpxx=stgx-minstgx
stgpxy=stgy-minstgy

maxxy=[max(stgpxx[where(finite(stgpxx) eq 1)]),max(stgpxy[where(finite(stgpxy) eq 1)])]

;Ratio of X to Y dimensions
fracxoy=maxxy[0]/maxxy[1]

stgpxx=stgpxx/max(maxxy)*max(projsz) ;*fracxoy
stgpxy=stgpxy/max(maxxy)*max(projsz)

;Determine position of the limb
wcssph2xy,findgen(1000)/999.*360.,fltarr(1000)+(5.),limbstgx,limbstgy,stgmapnum
limbstgpxx=limbstgx-minstgx
limbstgpxy=limbstgy-minstgy
limbstgpxx=limbstgpxx/max(maxxy)*max(projsz) ;*fracxoy
limbstgpxy=limbstgpxy/max(maxxy)*max(projsz)
wlimbgood=where(finite(limbstgpxx) eq 1)
projlimbx=limbstgpxx[wlimbgood]
projlimby=limbstgpxy[wlimbgood]
projlimbxy=[transpose(projlimbx),transpose(projlimby)]

;coordstg=coord
;coordstg[0,*,*]=stgx
;coordstg[0,*,*]=stgy
;pixel = wcs_get_pixel( wcs, coordstg)

;EXTAST, hdr,  astr
;AD2XY, lon ,lat, astr, x, y
;adxy, hdr, hglonc, hglatc, pxx, pxy

;Re-scale the projection coordinates -> scale values to an array a specified factor larger than the original image
;xbound=float(minmax(xx))
;ybound=float(minmax(yy))
;stgxbound=float(minmax(stgx[where(finite(stgx) eq 1)])) > (-90) < (90)
;stgybound=float(minmax(stgy[where(finite(stgy) eq 1)])) > (-90) < (90)
;stgx=(stgx-stgxbound[0])/(stgxbound[1]-stgxbound[0])*imgsz[0]*projscl
;stgy=(stgy-stgybound[0])/(stgybound[1]-stgybound[0])*imgsz[1]*projscl

;Insert data values into locations in projected array determined by stereographic X, Y arrays
wins=where(finite(stgpxx) eq 1)
winsx=stgpxx[wins]
winsy=stgpxy[wins]


;Project and Interpolate the image
stgproj = reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[0]), image,output_size=[max(winsx),max(winsy)]))

;Project the corresponding mask
if n_elements(mask) gt 0 then projmask=reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[0]), mask, output_size=[max(winsx),max(winsy)])) ;

;Project the corresponding input ref image
if n_elements(inrefimg) gt 0 then outrefproj=reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[0]), inrefimg, output_size=[max(winsx),max(winsy)]))

if keyword_set(doprojscl) then begin
	projrrdeg=reform( WARP_TRI( winsx, winsy, (wins mod imgsz[0]), (wins/imgsz[0]), rrdeg, output_size=[max(winsx),max(winsy)]))
	projpxscl=ar_losgrad(projrrdeg)*(2.*!pi*map.rsun/map.dx/360.)
	projpxsclb=ar_buff(projpxscl, widthbuff=10, valbuff=0)
	projpxsclb=smooth(projpxsclb,[5,5])
	projpxscl=ar_buff(projpxsclb, widthbuff=10, /inverse)
endif

return, stgproj

end