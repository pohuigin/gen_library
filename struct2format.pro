;Generate a format string for use with READCOL from an input structure.
;Use case example:
;	formatstr=struct2format(struct)
;	spawn,'echo ''FORMAT: '+formatstr+''' > '+outfile
;
;A routine to read the data_type of a bunch of variables and output the readcol format string so that I can automatically put the format string into the headers of future CSV files
;From READCOL: scalar string containing a letter specifying an IDL type for each column of data to be read.  
;	Allowed letters are:
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
;

function struct2format, instruct, typearr=typearr
struct=instruct[0]

ntag=n_elements(tag_names(struct))

typearr=strarr(ntag)

formarr=strarr(ntag)

for i=0,ntag-1 do begin

	thisform=size(struct.(i),/type)
	typearr[i]=thisform
	
	case thisform of
		0: formarr[i]='A'
		1: formarr[i]='B'
		2: formarr[i]='I'
		3: formarr[i]='L'
		4: formarr[i]='F'
		5: formarr[i]='D'
		6: formarr[i]='F'
		7: formarr[i]='A'
		8: formarr[i]='A'
		9: formarr[i]='D'
		10: formarr[i]='A'
		11: formarr[i]='A'
		12: formarr[i]='U'
		13: formarr[i]='L'
		14: formarr[i]='LL'
		15: formarr[i]='LL'
		else: formarr[i]='A'
	endcase

endfor

formatstr=strjoin(formarr,',')

return,formatstr

end