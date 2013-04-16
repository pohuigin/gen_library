;expects 20080101
;if you set /VMS then it expects '1-jan-2008'
;does 1-day spacing unless seconds, minutes, hours, or days keyword is specified

function datearr, tstart, tend, vms=vms, seconds=seconds, minutes=minutes, hours=hours, days=days

if not keyword_set(vms) then begin
	tstart1=anytim(file2time(strtrim(tstart,2)),/date,/vms)
	tend1=anytim(file2time(strtrim(tend,2)),/date,/vms)
endif else begin
	tstart1=tstart
	tend1=tend
endelse

if not keyword_set(seconds) and not keyword_set(minutes) and not keyword_set(hours) and not keyword_set(days) then begin
;	dates = TIME2FILE( TIMEGRID( ANYTIM( '15-may-99' ), ANYTIM( '15-jun-99' ), /DAYS, /VMS ), /DATE )
	dates = TIME2FILE( TIMEGRID( ANYTIM( tstart1 ), ANYTIM( tend1 ), /DAYS, /VMS ), /DATE )
endif else dates = TIME2FILE( TIMEGRID( ANYTIM( tstart1 ), ANYTIM( tend1 ), seconds=seconds, minutes=minutes, hours=hours, days=days, /VMS ))

dates=dates[uniq(dates)]

return,dates

end