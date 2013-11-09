;Take a structure, a formatting string, a header string array, and an output file name,
;and output a CSV file with the formatted contents of the structure.
;
;Header lines need ot begin with #
;

pro write_data_file_out, file, string, init=init

if keyword_Set(init) then init=1 else init=0

if init then spawn,'echo "'+string+'" > '+file, /sh $
	else spawn,'echo "'+string+'" >> '+file, /sh

end

;----------------------------------------------------------------------------->

pro write_data_file, instruct, filecsv=infile, formstring=inform, header=inhead, append=append, nodata=nodata, noform=noform, notag=notag
struct=instruct

if n_elements(infile) eq 1 then file=infile else file='write_data_file'+time2file(systim(/utc),/sec)+'.txt'

if n_elements(inform) eq 1 then formstr=inform else formstr=struct2format(struct[0])

if n_elements(inhead) ne 0 then header=inhead else header='#No header was supplied'

formline='#FORMAT; '+formstr

tagline='#'+strjoin(tag_names(struct[0]),';')

readcolline='#To read this CSV file into IDL, run: IDL> readcol,'''+(reverse(str_sep(file,'/')))[0]+''','+strjoin(strlowcase(tag_names(struct[0])),',')+',delim='';'',comment=''#'',format='''+formstr+'''

;Initialise the CSV file

if not keyword_set(append) then begin

	write_data_file_out, file, header[0], /init
	
	for i=1l,n_elements(header)-1l do write_data_file_out, file, header[i]
	
	write_data_file_out, file, readcolline
	
	if not keyword_set(noform) then write_data_file_out, file, formline
	
	if not keyword_set(notag) then write_data_file_out, file, tagline

endif

if not keyword_set(nodata) then begin
	for j=0l,n_elements(struct)-1l do begin
	
		thisline=struct2string(struct[j], inform=formstr)
	
		write_data_file_out, file, thisline
	
	endfor
endif

end