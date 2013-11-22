;Returns the inclination between the arc connecting two reference points along a GC and the equator
;from Leonard (1953)
;
;coordinates are in geographic longitude latitude
;Alonlat: first reference point on great circle (GC), [longitude, latitude] in degrees
;Blonlat: second reference point on great circle (GC), [longitude, latitude] in degrees
function gc_inc, inalonlat, inblonlat, outeqnode=outnlonlat
alonlat=float(inalonlat)
blonlat=float(inblonlat)

wa0=where(alonlat eq 0)
wb0=where(blonlat eq 0)
if wa0[0] ne -1 then alonlat[wa0]=alonlat[wa0]+0.001
if wb0[0] ne -1 then blonlat[wb0]=blonlat[wb0]+0.001

;convert to radians
alonlat=alonlat*!dtor
blonlat=blonlat*!dtor

;!!!try to correct for problem when determining angles when A and B are on either side of the equator
lonshift=alonlat[0,*]

;get position of equatorial node nearest to reference mid point between A and B
;nlon=atan((sin(alonlat[0,*])*tan(blonlat[1,*])-sin(blonlat[0,*])*tan(alonlat[1,*]))/(cos(alonlat[0,*])*tan(blonlat[1,*])-cos(blonlat[0,*])*tan(alonlat[1,*])))
nlon=atan((sin(alonlat[0,*]-lonshift)*tan(blonlat[1,*])-sin(blonlat[0,*]-lonshift)*tan(alonlat[1,*]))/(cos(alonlat[0,*]-lonshift)*tan(blonlat[1,*])-cos(blonlat[0,*]-lonshift)*tan(alonlat[1,*])))+lonshift

;!!!!! GIVING me the wrong inclination, node point sometimes for when longitudes are greater than 90


nlonlat=[nlon,transpose(fltarr(n_elements(nlon)))]

outnlonlat=nlonlat/!dtor

;get inclination between GC and equator
inc=atan(tan(alonlat[1,*])/sin(alonlat[0,*]-nlonlat[0,*]))

return,inc/!dtor
end