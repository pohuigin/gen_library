;Returns the position on of the north pole of a great circle on a sphere.
;from Leonard (1953)
;
;coordinates are in geographic longitude latitude
;ALonLat: first reference point on great circle (GC), [longitude, latitude] in degrees
;BLonLat: second reference point on great circle (GC), [longitude, latitude] in degrees
;DistArr: an input array of distances along the GC corresponding to the first set of ALonLat and BLonLat pts. in the arrays 
function gc_fit, inalonlat, inblonlat, distarr=indistarr, outfit=outadlonlat, outeqnode=outeqnode, outinc=outinc, south=south
alonlat=float(inalonlat)
blonlat=float(inblonlat)
isd=keyword_set(n_elements(indistarr))
if isd then distarr=indistarr*!dtor

;A = pt 1, B = pt 2, P = N-pole of GC, P' = S-pole of GC

;convert to radians
alonlat=alonlat*!dtor
blonlat=blonlat*!dtor

;find the angle of the GC Npole to the global Npole using 2 points along the GC
plon=atan((cos(alonlat[0,*])*tan(blonlat[1,*])-cos(blonlat[0,*])*tan(alonlat[1,*]))/(sin(blonlat[0,*])*tan(alonlat[1,*])-sin(alonlat[0,*])*tan(blonlat[1,*])))

plat=atan(-cos(plon-alonlat[0,*])/tan(alonlat[1,*]))

plonlat=[plon,plat]

;stop

;given a distance array (input in degrees and converted to rad), determine the set of corresponding a,b lon,lat pts.
;if isd then print,'ISD'
if isd then begin
	inc=gc_inc(alonlat[*,0]/!dtor, blonlat[*,0]/!dtor, outeqnode=nlonlat)*!dtor
	nlonlat=nlonlat*!dtor

;	alonlat2=alonlat
;	alonlat2[0,*]=(alonlat2[0,*]+(-alonlat2[0,*]/abs(alonlat2[0,*]))*180*!dtor)
;	blonlat2=blonlat
;	blonlat2[0,*]=(blonlat2[0,*]+(-blonlat2[0,*]/abs(blonlat2[0,*]))*180*!dtor)

;	inc2=gc_inc(alonlat2[*,0]/!dtor, blonlat2[*,0]/!dtor, outeqnode=nlonlat2)*!dtor

	wgt0=where(distarr ge 0)
	wlt0=where(distarr lt 0)

	if (wgt0)[0] ne -1 then adlon=atan(tan(distarr[wgt0])*cos(inc[0]))+(nlonlat[*,0])[0] else adlon=0
;	if (wlt0)[0] ne -1 then adlon2=atan(tan(distarr[wlt0])*cos(inc2[0]))+(nlonlat2[*,0])[0] else adlon2=0
	if (wgt0)[0] ne -1 then adlat=atan(tan(inc[0])*sin(adlon-(nlonlat[*,0])[0])) else adlat=0
;	if (wlt0)[0] ne -1 then adlat2=atan(tan(inc2[0])*sin(adlon2-(nlonlat2[*,0])[0])) else adlat2=0

;	adlonlat=[transpose([reform(adlon),reform(adlon2)]),transpose([reform(adlat),reform(adlat2)])]
	
	adlonlat=[transpose(reform(adlon)),transpose(reform(adlat))]
;stop	
	;convert output variables
	outadlonlat=adlonlat/!dtor
	outeqnode=nlonlat/!dtor
	outinc=inc/!dtor
endif

if keyword_set(south) then begin
	signarr=-plon/abs(plon)
	splon=(plon+signarr*180*!dtor)
	splat=-plat
	return,[transpose(reform(splon)),transpose(reform(splat))]/!dtor
endif

return, plonlat/!dtor

end