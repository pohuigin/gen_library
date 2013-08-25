;Prep a 2D magnetogram image for display
;Scale a magnetogram to +-500 G and make the background the same value as the max in the image

function magscl, mag, maxscl=maxscl, minscl=minscl,nobg=nobg

if not keyword_set(maxscl) then maxscl=500.

if not keyword_set(minscl) then minscl=-500.

outmag=mag

if not keyword_set(nobg) then begin
   wfill=where(mag eq mag[0,0])
   if wfill[0] ne -1 then outmag[wfill]=maxscl
endif

outmag[0,0]=maxscl
outmag[1,0]=minscl

outmag=bytscl(outmag,min=minscl,max=maxscl)

return,outmag

end
