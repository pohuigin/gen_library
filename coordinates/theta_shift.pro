;-------------------------------------------------------------------------->
;Make sure that longitudes run from 0-360
function sw_theta_shift, inarr, n180to180=n180to180

outarr=inarr

if (where(inarr ge 360))[0] ne -1 then outarr[where(inarr ge 360)]=outarr[where(inarr ge 360.)]-360.
if (where(inarr lt 0))[0] ne -1 then outarr[where(inarr lt 0)]=outarr[where(inarr lt 0.)]+360.

;stop

if keyword_set(n180to180) then begin
	if (where(outarr ge 180))[0] ne -1 then outarr[where(outarr ge 180)]=outarr[where(outarr ge 180.)]-360.
	if (where(outarr lt -180))[0] ne -1 then outarr[where(outarr lt -180)]=outarr[where(outarr lt -180)]+360.
endif

return, outarr

end

