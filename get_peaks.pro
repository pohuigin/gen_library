;Another light curve peak selector.
;returns WHERE() array of peaks
;PEAKSCALE = estimated width of peaks in pixels

function get_peaks, inarr, npeaks=innpeaks, nstddev=innstddev, peakscale=inpeakscale, $
                    wpeakall=wpeakall, peakval=peakval, peakthresh=arrthresh

arrorig=inarr
arr=inarr

if n_elements(inpeakscale) ne 1 then peakscale=5 else peakscale=inpeakscale/2.
if n_elements(innstddev) ne 1 then nstddev=1 else nstddev=innstddev
if n_elements(innpeaks) ne 1 then npeaks=1 else npeaks=innpeaks

ntries=npeaks+10 

arrmin=min(arr)
arrmean=mean(arr)
arrstdv=stddev(arr)

arrthresh=arrmean+arrstdv*nstddev



wpeakall=fltarr(ntries)-1
wpeaks=0
peakval=0

for i=0,ntries-1 do begin
   thiswmax=(where(arr eq max(arr)))[0]
   wpeakall[i]=thiswmax

;Test for valid peak
   if arrorig[thiswmax-peakscale>0] lt arrorig[thiswmax] and $
      arrorig[thiswmax+peakscale<(n_elements(arr)-1)] lt arrorig[thiswmax] and $
      arrorig[thiswmax] gt arrthresh then begin
   
        peakval=[peakval,arrorig[thiswmax]]
   	wpeaks=[wpeaks,thiswmax]
   
   endif

if n_elements(wpeaks) ge npeaks+1 then break

   arr[thiswmax-peakscale>0:thiswmax]=arrmin
   arr[thiswmax:thiswmax+peakscale<(n_elements(arr)-1)]=arrmin

endfor

if n_elements(wpeaks) eq 1 then wpeaks=-1 else begin
   wpeaks=wpeaks[1:*]
   peakval=peakval[1:*]

;Order peaks by position
   speaks=sort(wpeaks)
   wpeaks=wpeaks[speaks]
   peakval=peakval[speaks]

endelse

return,wpeaks

end
