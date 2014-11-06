;cluster event times by using an input maximum time separation between events in seconds
;the output is a list of indices that corresponds to each cluster ID and each event in the order of the input event list.
;assumes the events are already in time order
;input a list of 'tims'

function cluster_times,intims,maxsep

tims=anytim(intims)

ntims=n_elements(tims)
clustind=fltarr(ntims)

wts=flare_wait_time(tims) 

wbreakclust=where(wts gt maxsep)
nclust=n_elements(wbreakclust)

for i=0,nclust-1 do begin

;Determine the start and end points of each cluster
	if i eq 0 then wthisst=0 else wthisst=wbreakclust[i-1]
	wthisen=wbreakclust[i]-1

;Fill the cluster index
	clustind[wthisst:wthisen]=i

endfor

;fill the last cluster
clustind[wbreakclust[nclust-1]:*]=max(clustind)+1

return,clustind

end