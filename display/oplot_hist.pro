;Overplot a histogram by plotting a series of horizontal bars 
;which start at the beginning of each regular bin and extend 
;one bin length
;
;VERTICAL: set to make a plot on its side (e.g., a marginalised histogram, summing over 
;		   the X-axis), rather than a normal horizontal one.
;

pro oplot_hist,distxhist,flareyhist,_extra=_extra, vertical=vertical

if keyword_set(vertical) then vertical=1 else vertical=0

bin=distxhist[1]-distxhist[0]

nbin=n_elements(distxhist)

if vertical then begin
	for i=0,nbin-1 do vline,flareyhist[i],yran=[distxhist[i],distxhist[i]+bin],_extra=_extra
endif else begin
	for i=0,nbin-1 do hline,flareyhist[i],xran=[distxhist[i],distxhist[i]+bin],_extra=_extra
endelse 

end