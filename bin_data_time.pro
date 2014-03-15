;TIME = anytim array corresponding to data
;DATA = data points to bin
;BIN = custom bin in seconds
;nanmiss=set to value for missing bins. routine will set these to NAN.

;TSTART = time to start bins at
;OUTERR = output an array of STDEVs; 1 for each bin

;temporally bin data (ie. sunspot number)
;returns average number of sunspots on disk during course of bin.

pro bin_data_time, data, time, odata, otime, bin=bin, $
	hour=hour, day=day, week=week, month=month, rotation=rotation, year=year, $
	totaldat=totaldat, meandat=meandat, mediandat=mediandat, nanmiss=nanmiss, tstart=intstart, $
	meanbindat=meanbindat, totbindat=totbindat, medianbindat=medianbindat,outerr=outerr

if not keyword_set(totaldat) and not keyword_set(meandat) and not keyword_set(mediandat) then meandat=1

time1=time
data1=data

nan=1./0.

if n_elements(intstart) gt 0 then tstart=intstart else tstart=min(time);max(time)
time1=time1-tstart

if n_elements(bin) lt 1 then begin 
	if keyword_set(hour) then bin=3600.
	if keyword_set(day) then bin=3600.*24.
	if keyword_set(week) then bin=3600.*24.*7.
	if keyword_set(month) then bin=3600.*24.*30.5
	if keyword_set(rotation) then bin=3600.*24.*27.
	if keyword_set(year) then bin=3600.*24.*365.
	
	if n_elements(bin) lt 1 then bin=3600.*24.
endif

npts=floor(max(time1)/float(bin))+1 ;,/l64)

timebin=findgen(npts)
databin=fltarr(npts)
outerr=fltarr(npts)

for i=0,npts-1 do begin
	
	wthisbin=where(time1 ge float(i)*bin and time1 lt float(i+1)*bin)
	if wthisbin[0] eq -1 then continue
	
	;need to calculate properties (take mean or total) for each disk image and average over bin!!
	thistim=time1[wthisbin]
	utims=thistim[uniq(thistim)]
	ntims=n_elements(utims)
	thisdata=fltarr(ntims)
	for j=0,ntims-1 do begin
		wthistim=where(thistim eq utims[j])
		if keyword_set(meandat) then thisdata[j] = mean(data1[wthisbin[wthistim]])
		if keyword_set(totaldat) then thisdata[j] = total(data1[wthisbin[wthistim]])
		if keyword_set(mediandat) then thisdata[j] = median(data1[wthisbin[wthistim]])

	endfor
	outerr[i] = stddev(thisdata)
	databin[i] = mean(thisdata)
	if keyword_set(totbindat) then databin[i] = total(thisdata)
	if keyword_set(medianbindat) then databin[i] = median(thisdata)
end

if n_elements(nanmiss) gt 1 then $
	if (where(databin eq nanmiss))[0] ne -1 then databin[where(databin eq nanmiss)]=nan

otime=timebin*bin+tstart
odata=databin

;sum points in each bin to make new array.

end
