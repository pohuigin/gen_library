;Rebins data in one direction to arbitrary size (same num of dimensions)
;allows for missing values to be ignored
;
;array = (1 or 2d array) input array to be rebinned
;dim = (1 element) new rebinned dimension size of array
;(opt.) missval = flagged value for missing data
;(opt.) direction = direction to rebin over for 2d arrays: 1=x, 2=y

function rebin1d, inarray, inbin, missval=inmissval, direction=indir

array=inarray

if n_elements(inbin) lt 1 then begin
	print,'Must supply BIN variable'
	return,''
endif else bin=float(inbin)

ndim=(size(array))[0]

if ndim eq 1 then begin
	dir=1
	dim=floor(n_elements(array)/float(bin)) 
endif else begin
	if n_elements(indir) gt 0 then dir=indir else dir=1
	if dir eq 1 then dim=floor(n_elements(array[*,0])/float(bin))
	if dir eq 2 then begin
		dim=floor(n_elements(array[0,*])/float(bin))
		array=transpose(array)
	endif
	imgsz=size(array,/dim)
endelse

if n_elements(inmissval) gt 0 then begin
	missval=inmissval 
	wbad=where(array eq missval or finite(array) ne 1)
endif else begin
	wbad=where(finite(array) ne 1)
endelse
wgood=where(finite(array) eq 1)

if wbad[0] eq -1 then domiss=0 else begin
	domiss=1
	missval=min(array[wgood])-1d3
	array[wbad]=missval
endelse

if ndim eq 1 then outarray=fltarr(dim) else outarray=fltarr(dim,imgsz[1])

for i=0,dim-1 do begin

	if ndim eq 1 then begin
		thisbin=array[i*bin:i*bin+bin-1]
		outarray[i]=average(thisbin, miss=missval)
	endif else begin
		thisbin2d=array[i*bin:i*bin+bin-1,*]
		thisbin=average(thisbin2d, 1, miss=missval)
		;thisbin=transpose(fltarr(bin))
		;for j=0,bin-1 do thisbin[0,j]=mean(thisbin2d[*,j])
		outarray[i,*]=thisbin
	endelse

endfor

if dir eq 2 then outarray=transpose(outarray)


return, outarray

end