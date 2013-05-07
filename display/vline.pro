pro vline,x,_extra=_extra, yrange=inyrange, vlog=vlog;, multi=multi

if n_elements(x) lt 1 then x=0

if n_elements(inyrange) lt 1 then yrange= !y.crange else yrange=inyrange

;if keyword_set(multi) then begin
	if keyword_set(vlog) then for i=0,n_elements(x)-1 do oplot,[x[i],x[i]],10.^(yrange),_extra=_extra $
		else for i=0,n_elements(x)-1 do oplot,[x[i],x[i]],yrange,_extra=_extra
;endif else oplot,[min(x),max(x)],!y.crange,_extra=_extra

end