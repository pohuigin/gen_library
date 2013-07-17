;Use WCS to get HG coordinate map from a map structure

pro map_gethg, map, wcs=wcs, hglon=hglon, hglat=hglat

if data_type(wcs) ne 8 then wcs=map.wcs ;fitshead2wcs(map.index)

coord=wcs_get_coord(wcs)

wcs_convert_from_coord,wcs,coord,'HG',hglon,hglat



end