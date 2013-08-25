;Read a standard parameter text file.
;An example parameter file:
;
;	#Parameter; Value; Type; Comment
;	some_name; a string of some sort; A; explanation of the parameter usage
;	another_name; 9393.284; F; a different explanation
;

function read_param_file, fparam, meta=outmeta


;Read parameters from meta data file
readcol, fparam, param, val, type, meta, comment='#', format='A,A,A,A', delim=';',/silent
param=strtrim(param,2)
val=strtrim(val,2)
type=strtrim(type,2)
meta=strtrim(meta,2)

;Make array of data types for each field in structure
dataspec=strjoin(type,',')

;Create empty structure
create_struct, paramstruct, '', param, dataspec

;Fill the structure
for i=0,n_elements(param)-1 do paramstruct.(i)=val[i]

;Output the description of each parameter
outmeta=[[param],[meta]]


return,paramstruct

end
