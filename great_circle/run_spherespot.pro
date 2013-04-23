;script to test putting a spot on a sphere at some lon and lat position 

tstart='29-mar-2013 00:00'

map=getjsoc_hmi_read(tstart, info_struct=info_struct) ;, nodata=nodata, nocalibrate=nocalibrate, rebin=rebin, timegrid=timegrid

map=ar_processmag(map)

map_gethg, map, wcs=wcs, hglon=hglon, hglat=hglat

spot=sphere_spot([45.,55.], 10., hglon, hglat) 

;dpts=gc_dist(rebin([loncent,latcent],2,npx), [reform(loncoord,1,npx),reform(latcoord,1,npx)])











stop

end