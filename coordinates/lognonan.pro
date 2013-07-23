;use ALOG10, but remove the NANs
;LN = set to use natural logarithm
;MISS = value to set the NANs to (default is 0)

function lognonan, input, ln=ln, miss=inmiss

if n_elements(inmiss) ne 1 then miss=0 else miss=inmiss

if keyword_set(ln) then login=alog(input) $
	else login=alog10(input)

wnan=where(finite(login) ne 1)

if wnan[0] ne -1 then login[wnan]=miss

return,login

end