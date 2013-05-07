pro smart_nsew2hg, locstr, hglat, hglon


nloc=n_elements(locstr)

hglat=strarr(nloc)
hglon=strarr(nloc)

for i=0,nloc-1 do begin

	thisloc=locstr[i]

	if strmid(thisloc,0,1) eq 'S' then mlat=-1 else mlat=1
	thishglat=fix(strmid(thisloc,1,2))*mlat
	if strmid(thisloc,3,1) eq 'E' then mlon=-1 else mlon=1
	thishglon=fix(strmid(thisloc,4,2))*mlon

	thishglat=fix(thishglat)
	thishglon=fix(thishglon)
	
	hglat[i]=thishglat
	hglon[i]=thishglon

endfor

hglat=reform(hglat)
hglon=reform(hglon)

end