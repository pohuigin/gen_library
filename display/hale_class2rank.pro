;Convert SRS Hale Class string to 'rank' number. alpha=1, beta=2, beta-gamma=3,beta-gamma-delta=4 ...

function hale_class2rank, inclass

class=strtrim(inclass,2)
nstring=n_elements(class)
rank=fltarr(nstring)

for i=0,nstring-1 do begin

	case class[i] of 
		'a' : rank[i]=1.
		'b' : rank[i]=2.
		'bg' : rank[i]=3.
		'g' : rank[i]=3.
		'bd' : rank[i]=3.5
		'gd' : rank[i]=3.5
		'bgd' : rank[i]=4.
		else : rank[i]=1.
	endcase

endfor





return,rank

end