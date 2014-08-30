;Weighted running average
;
;width = total width of running average in points (pixels)
;make sure it is odd!
;
;weights = array of arbitrarily scaled weights

function weight_run_avg, arr, weights, inwidth

width=fix(inwidth)

arrsz=n_elements(arr)
arravg=fltarr(arrsz)

arrind=findgen(arrsz)

arrwid=indgen(width)-width/2

icent=0l

warr=minmax(icent+arrwid) > 0 < (arrsz-1)

while warr[0] ne -1 and icent lt arrsz do begin

	arravg[icent]=total(arr[warr[0]:warr[1]]*weights[warr[0]:warr[1]])/total(weights[warr[0]:warr[1]])

	icent=icent+1l

	warr=minmax(icent+arrwid) > 0 < (arrsz-1)

endwhile


return, arravg

end