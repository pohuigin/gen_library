;TAG_DESCRIPT -  String descriptor for the structure, containing the
;	tag type and dimensions.  For example, 'A(2),F(3),I', would
;	be the descriptor for a structure with 3 tags, strarr(2), 
;	fltarr(3) and Integer scalar, respectively.
;	Allowed types are: 
;		'A' for strings, 
;		'B' or 'L' for unsigned byte integers, 
;		'I' for integers, 
;		'J' for longword integers, 
;		'K' for 64bit integers, 
;		'F' or 'E' for floating point, 
;		'D' for double precision  
;		'C' for complex, 
;		and 'M' for double complex.   
;		Uninterpretable characters in a format field are ignored.


function format2create_struct, informatstr

formatstr=informatstr

format=strlowcase(str_sep(formatstr,','))

nform=n_elements(format)

csformarr=strarr(nform)

for i=0,nform-1 do begin

	thisform=format[i]

	case thisform of
		'a': csformarr[i]='A'
		'b': csformarr[i]='B'
		'd': csformarr[i]='D'
		'f': csformarr[i]='F'
		'i': csformarr[i]='I'
		'l': csformarr[i]='J'
		'll': csformarr[i]='K'
		'u': csformarr[i]='I'
		'z': csformarr[i]='A'
		'x': csformarr[i]='A'
		else: csformarr[i]='A'
	endcase		

endfor


outform=strjoin(csformarr,',')

return, outform

end