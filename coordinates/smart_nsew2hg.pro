;INVERSE = take hg lat and lon and produce a locagtion string (e.g.,
;N30E24 or S10W04

pro smart_nsew2hg, locstr, hglat, hglon, inverse=inverse

if not keyword_set(inverse) then begin

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

endif else begin

   nloc=n_elements(hglat)

   locstr=strarr(nloc)

   for i=0,nloc-1 do begin

      thislon=hglon[i]
      thislat=hglat[i]

      if thislon lt 1 then ew='E' else ew='W'
      if thislat lt 1 then ns='S' else ns='N'

      thisloc=ns+string(abs(thislat),form='(I02)')+ew+string(abs(thislon),form='(I02)')
     
      locstr[i]=thisloc

   endfor

   locstr=reform(locstr)

endelse

return

end
