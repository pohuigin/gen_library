;Read a standard data text file into a structure.
;An example parameter file:
;
;	#This is header blah blah
;	#Also header blah
;	#FORMAT; F,A,F,I
;	#variable1; variable2; variable3; variable4
;	234.12; string lalala; 10.2E3; -2
;	234.12; string lalala; 10.2E3; -2
;
;Read out the header as a string array
;	If NUMHEAD is supplied, use that to determine the number of header lines to read out
;	If not assume a maximum of 100 header lines
;If the FORMAT line is supplied, use it to determine the formatting of each column
;	Otherwise assume string for all
;	Unless format keyword is input
;Use the last commented line as the tag names for the output structure.
;
;NOTES
;	1. Assumes '&!' does not appear anywhere in data file, otherwise may cause problems with header read-out.
;

function read_data_file, file, format=informat, header=outheader, numhead=innumhead

;Set max number of header lines
if n_elements(innumhead) eq 1 then numhead=innumhead else numhead=100

;Read out the header
readcol, file, rawhead, num=numhead, delim='&!',form='A'
whead=where(strpos(rawhead,'#') eq 0)

colnames=rawhead[max(whead)]
colarr=strtrim(str_sep(strmid(colnames,1,strlen(colnames)-1),';'),2)
colarr=colarr[where(colarr ne '')] 
ncol=n_elements(colarr)

wformat=(where(strpos(rawhead,'#FORMAT;') eq 0))[0]
if wformat eq -1 then begin
	if n_elements(informat) ne 1 then begin 
		format=strjoin(strarr(ncol)+'A',',')
	endif else begin
		format=informat
	endelse
endif else begin
	format=strtrim((str_sep(rawhead[wformat],';'))[1],2)
endelse

;Pull out header string array
header=rawhead[whead]

;set up execute string to read out the variable names from READCOL
vararr='var'+strtrim(indgen(ncol),2)
varstr=strjoin(vararr,',')

;Determine if there are more than 24 columns in CSV file
if ncol gt 25 then begin

	varstr1=strjoin(vararr[0:24],',')
	format1=strjoin((str_sep(format,','))[0:24],',')
	readcolstr1='readcol, file, '+varstr1+', comment=''#'', format='''+format1+''', delim='';'''

	varstr2=strjoin(vararr[25:*],',')
	format2=strjoin(strarr(25)+'X',',')+','+strjoin((str_sep(format,','))[25:*],',')
	readcolstr2='readcol, file, '+varstr2+', comment=''#'', format='''+format2+''', delim='';'''

	status1=execute(readcolstr1)
	status2=execute(readcolstr2)
	status=strjoin([status1,status2],',')

endif else begin

	readcolstr='readcol, file, '+varstr+', comment=''#'', format='''+format+''', delim='';'''

;Read parameters from meta data file
	status=execute(readcolstr)

endelse

;use execute to make an empty structure (with the tag names from the column names)
;blank='{'+strjoin(colnames+':'''',','')+'}'

;Create empty structure
formarr=str_sep(format,',')

csformat=format2create_struct(format)



;!!!!!!! FIX this... need to translate readcol formatting into create_Struct formatting :(

;       TAG_DESCRIPT -  String descriptor for the structure, containing the
;               tag type and dimensions.  For example, 'A(2),F(3),I', would
;               be the descriptor for a structure with 3 tags, strarr(2), 
;               fltarr(3) and Integer scalar, respectively.
;               Allowed types are 'A' for strings, 'B' or 'L' for unsigned byte 
;               integers, 'I' for integers, 'J' for longword integers, 
;               'K' for 64bit integers, 'F' or 'E' for floating point, 
;               'D' for double precision  'C' for complex, and 'M' for double 
;               complex.   Uninterpretable characters in a format field are 
;               ignored.


;! continue making yafta routine. need to determine which yafta meta AR structures go with which SMART2 ARs in the meta file
;! probably need to save DATAFILE, ARID for the new tracked meta file... the number of rows should be the same for each...





create_struct,blankstr,'',colarr,csformat

;replicate the structure to the number of lines read from READCOL
ndata=n_elements(var0)
datastr=replicate(blankstr,ndata)

;use a loop to fill each field with varN
;Cut off extra spaces for strings
for i=0,ncol-1 do $
	if formarr[i] eq 'A' then status2=execute('datastr.(i)=strtrim('+vararr[i]+',2)') $
		else status2=execute('datastr.(i)='+vararr[i])

;output the filled structure
outstruct=datastr

outheader=header

return,outstruct

end