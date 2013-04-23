;Make a spot on the Sun given coordinate arrays and an input centroid and radius
;Coordinates are in geographic longitude latitude.
;
;LONLAT = spot centroid location, [longitude, latitude] in degrees
;RADIUS = spot radius in degrees
;LONCOORD = longitude coordinates of output image (could be obtained from WCS_COORD().)
;LATCOORD = latitude coordinates of output image

function sphere_spot, inlonlat, inradius, loncoord, latcoord

loncent=inlonlat[0]
latcent=inlonlat[1]
radius=inradius

wofflimb=where(finite(loncoord) ne 1)
wonlimb=where(finite(loncoord) eq 1)

;if wofflimb[0] ne -1 then begin
;	loncoord[wofflimb]=1d6 ;max(loncoord[wonlimb])
;	latcoord[wofflimb]=1d6 ;max(latcoord[wonlimb])
;endif

sz=long(size(loncoord,/dim))
npx=n_elements(loncoord)

dpts=gc_dist(rebin([loncent,latcent],2,npx), [reform(loncoord,1,npx),reform(latcoord,1,npx)])

if wofflimb[0] ne -1 then dpts[wofflimb]=max(dpts[wonlimb])

dist=reform(dpts,sz[0],sz[1])


;plot_image,dist
;contour,dist,level=10,/over


contour,dist,level=10,/path_data_coords,path_info=c_info,path_xy=c_xy

;pull out the largest contour (there should only be one)
c_info=(c_info[where(c_info.n eq max(c_info.n))])[0]
c_xy=c_xy[*,c_info.offset:c_info.offset+c_info.n-1.]

spot=polyfillv( c_xy[0,*], c_xy[1,*], sz[0], sz[1])

spotarr=fltarr(sz[0],sz[1])
spotarr[spot]=1


outimage=spotarr

return,outimage

end