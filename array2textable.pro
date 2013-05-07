;+
;(opt.) /aanda: Create a A&A style latex table (default)
;(req.) array: data columns in x and data rows in y
;(opt.) columns: names of columns in table
;(opt.) caption: for table caption
;(opt.) label: reference lable for table
;(opt.) outfile: output file name for .TXT file
;(opt.) /quiet: set if not running by hand to avoid user prompt. Take care not to overwrite output file.
;
;example: IDL> array2textable, findgen(3,3), ['$ x $', '$ \sigma $', 'Errors'],/aanda
;
;Written: Paul A. Higgins - 26-apr-2011
;
;Contact: pohuigin@gmail.com
;-

pro array2textable, array, columns, caption, label=label, outfile=outfile, aanda=aanda, quiet=quiet

if n_elements(array) lt 2 then begin & print,'ARRAY must be an array' & return & endif
array=strtrim(array,2)
ncol=n_elements((transpose(array))[0,*])
nrow=n_elements((transpose(array))[*,0])

if n_elements(columns) ne ncol then columns=strarr(ncol)+'BLANK'
if n_elements(caption) ne 1 then caption='BLANK' 
if n_elements(label) ne 1 then label='BLANK'
if n_elements(outfile) ne 1 then outfile=curdir()+'latex_table_'+time2file(systim(/utc))+'.txt'
coltag=strjoin(strarr(ncol)+'c',' ')
colname=strjoin(columns,' & ')

tabletex0=['\begin{table}', $
	'\caption{'+caption+'}', $      			; title of Table
	'\label{'+label+'}', $      				; is used to refer this table in the text
	'\centering', $                             ; used for centering table
	'\begin{tabular}{'+coltag+'}', $          		; centered columns (4 columns)
	'\hline\hline', $                        	; inserts double horizontal lines
	colname+' \\\\ ', $   ; table heading
	'\hline']                                   ; inserts single horizontal line

datarr=''
for i=0,nrow-1 do datarr=[datarr,strjoin(array[*,i],' & ')+' \\\\ ']
datarr=datarr[1:*]

;		'1 & 50 & $-837$ & 970 \\', $      		; inserting body of the table
;		'2 & 47 & 877      & 230 \\', $
;		'3 & 31 & 25        & 415 \\', $
;		'4 & 35 & 144      & 2356 \\', $
;		'5 & 45 & 300      & 556 \\', $

tabletex1=['\hline', $                                 ; inserts single line
	'\end{tabular}', $
	'\end{table}']

tabletext=[tabletex0, datarr, tabletex1]

;Clear the .TXT file
if not keyword_set(quiet) then begin
	if file_exist(outfile) then begin
		print,'OUTFILE already exists! Overwrite?? Answer "y" or "n".'
		answ=''
		read,answ
		if strlowcase(strmid(answ,0,1)) ne 'y' then begin
			print,'OK, then type new output file name ending in ".txt".'
			answ=''
			read,answ
			if strtrim(answ,2) eq '' then outfile=curdir()+'latex_table_'+time2file(systim(/utc))+'.txt' else outfile=answ
		endif
	endif
endif
spawn,'echo "" > '+outfile

;Output the table latex to a .TXT file
for j=0,n_elements(tabletext)-1 do spawn,'echo "'+tabletext[j]+'" >> '+outfile


print,'outfile is: '+outfile

end