;Return the distance along the great circle between two reference points
;from Leonard (1953)
;coordinates are in geographic longitude latitude
;Alonlat: first reference point on great circle (GC), [longitude, latitude] in degrees
;Blonlat: second reference point on great circle (GC), [longitude, latitude] in degrees
;OutEqNode: output the location of the nearest equatorial node to the reference point in degrees
;OutADist: distance between reference point A and the equatorial node of the GC. in degrees
function gc_dist, inalonlat, inblonlat, outeqnode=nlatlon, outadist=outda, outmid=outmid
alonlat=float(inalonlat)
isb=keyword_set(n_elements(inblonlat))
if isb then blonlat=float(inblonlat)

;A = pt 1, B = pt 2, P = N-pole of GC, N = closest equatorial node of GC to A

;convert to radians
alonlat=alonlat*!dtor
if isb then blonlat=blonlat*!dtor

;inclination between GC and equator
inc=gc_inc(alonlat/!dtor, blonlat/!dtor, outeqnode=nlonlat)*!dtor
nlonlat=nlonlat*!dtor

;distance of equatorial node to point A along GC
da=acos(cos(alonlat[0,*]-nlonlat[0,*])*cos(alonlat[1,*]))
outda=da/!dtor

;da2=atan(tan(alonlat[0,*]-nlonlat[0,*])/cos(inc))

;if there is no second reference point input, then just output the distance of A to the node, N
if not isb then return,outda

db=acos(cos(blonlat[0,*]-nlonlat[0,*])*cos(blonlat[1,*]))

;db2=atan(tan(blonlat[0,*]-nlonlat[0,*])/cos(inc))

;distance between the two points
alatsign=alonlat[1,*]/abs(alonlat[1,*])
blatsign=blonlat[1,*]/abs(blonlat[1,*])
diffhemisign=alatsign*blatsign

dd=abs(da-db*diffhemisign)


;print,'da=',outda
;print,'db=',db/!dtor
;print,'dd=',dd/!dtor
;stop




;dd2=abs(da2-db2)

;Find the mid point position between the two reference points
dmid=-(da+db)/2.
mlon=reform(atan(tan(dmid)*cos(inc))+(nlonlat[0,*]))
mlat=reform(atan(tan(inc)*sin(mlon-nlonlat[0,*])))
mlonlat=[mlon,mlat]
outmid=mlonlat/!dtor

;stop





return,dd/!dtor

end