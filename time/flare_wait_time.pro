;---------------------------------------------------------->
;Written: Paul A. Higgins 20130605
;Input an array of flare times
;Return an array of wait times between consecutive flares
;
;if inverse is set then input an array of wait times and the time each flare occurred will come out (with the first flare being at t=0)
;output will be in anytim long integer

function flare_wait_time, intimes, inverse=inverse, outtim=outtim

time=anytim(intimes)

ntime=n_elements(time)

if keyword_set(inverse) then begin

	ftimes=fltarr(ntime)
	for i=1l,ntime-1l do ftimes[i]=ftimes[i-1l]+time[i]
	
	output=ftimes
	
endif else begin
	
	wait=[-1,time[1:ntime-1]-time[0:ntime-2]]
	outtim=[-1,time[1:ntime-1]]

;stop

	;waittimes=times[1:ntimes-1] - times[0:ntimes-2]
	
	;account for initial flare (no wait time)
	;waittimes=[1./0.,waittimes]
	
	output=wait

endelse


return, output

end
;---------------------------------------------------------->
