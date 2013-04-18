pro hline,y,_extra=_extra, xrange=inxrange, hlog=hlog;, multi=multi

if n_elements(y) lt 1 then y=0

if n_elements(inxrange) lt 1 then xrange= !x.crange else xrange=inxrange

;if keyword_set(multi) then begin
	if keyword_set(hlog) then for i=0,n_elements(y)-1 do oplot,10.^(xrange),[y[i],y[i]],_extra=_extra $
		else for i=0,n_elements(y)-1 do oplot,xrange,[y[i],y[i]],_extra=_extra
;endif else oplot,[min(x),max(x)],!y.crange,_extra=_extra

end