;set N to the log base number to calculate the logarithm of
;if N is not srt, it does natural log

function alogn, val, n

if n_elements(n) ne 1 then n=exp(1)


vlog=ALOG(val) / ALOG(n)


return, vlog

end
