;Returns the inclination between the arc connecting two reference points along a GC and the equator
;from Leonard (1953)
;
;coordinates are in geographic longitude latitude
;Alonlat: first reference point on great circle (GC), [longitude, latitude] in degrees
;Blonlat: second reference point on great circle (GC), [longitude, latitude] in degrees
function gc_inc, inalonlat, inblonlat, outeqnode=outnlonlat
alonlat=float(inalonlat)
blonlat=float(inblonlat)

;convert to radians
alonlat=alonlat*!dtor
blonlat=blonlat*!dtor

;get position of equatorial node nearest to reference mid point between A and B
nlon=atan((sin(alonlat[0,*])*tan(blonlat[1,*])-sin(blonlat[0,*])*tan(alonlat[1,*]))/(cos(alonlat[0,*])*tan(blonlat[1,*])-cos(blonlat[0,*])*tan(alonlat[1,*])))
nlonlat=[nlon,transpose(fltarr(n_elements(nlon)))]

outnlonlat=nlonlat/!dtor

;get inclination between GC and equator
inc=atan(tan(alonlat[1,*])/sin(alonlat[0,*]-nlonlat[0,*]))

return,inc/!dtor
end