;Take a structure (or an array of structures) and convert it into a string or string array, 
;formatted to be easily read into a CSV file.

function struct2string,instruct, formatstring=outform, inform=inform, delim=indelim
struct=instruct
nstruct=n_elements(struct)
stringarr=strarr(nstruct)

if n_elements(indelim) eq 0 then delim=';' else delim=indelim

if n_elements(inform) eq 1 then formstring=inform $
	else formstring=struct2format(struct[0], typearr=typearr)
formarr=str_sep(formstring,',')

tags=tag_names(struct[0])
ntags=n_elements(tags)

strform=strarr(ntags)

for i=0,ntags-1 do begin
	thisform=strlowcase(formarr[i])

;	A - string data, 
;	B - byte, 
;	D - double precision, 
;	F- floating point, 
;	I - short integer, 
;	L - longword, 
;	LL - 64 bit integer, 
;	U - unsigned short integer, 
;	Z - longword hexadecimal, 
;	X - skip a column.

	case thisform of 
		'a': strform[i]=''
		'b': strform[i]='(I4)'
		'd': strform[i]='(F12.4)'
		'f': strform[i]='(E12.4)'
		'i': strform[i]='(I7)'
		'l': strform[i]='(I12)'
		'll': strform[i]='(I20)'
		'u': strform[i]='(I7)'
		'z': strform[i]=''
		'x': strform[i]=''
	endcase

endfor


;			spawn,'echo "'+strjoin([archkstruct.(0),string(archkstruct.(1),form='(I10)'), $
;				string(archkstruct.(2),form='(I10)'),string(archkstruct.(3),form='(F10.2)'), $
;				string(archkstruct.(4),form='(F10.2)'),string(archkstruct.(5),form='(F10.2)'), $
;				string(archkstruct.(6),form='(F10.2)'),string(archkstruct.(7),form='(F10.2)'), $
;				string(archkstruct.(8),form='(F10.2)'),string(archkstruct.(9),form='(F10.2)'), $
;				string(archkstruct.(10),form='(F10.2)')],'; ')+'" >> '+fcsvar,/sh


for i=0,nstruct-1 do begin
	
	thisstruct=struct[i]
	
	tagnums=strtrim(fix(findgen(ntags)),2)
	
	exstrarr='string(thisstruct.('+tagnums+'),form='''+strform+''')'
	exstr='stringarr[i]=strjoin(['+strjoin(exstrarr,',')+'],'''+delim+''')'
	
	status=execute(exstr)
	
endfor






outstring=stringarr
return,outstring

end