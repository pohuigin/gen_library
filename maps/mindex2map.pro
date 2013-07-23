;---------------------------------------------------------------------->
;+
; PROJECT:  	SolarMonitor
;
; PROCEDURE:    MINDEX2MAP
;
; PURPOSE:    	A wrapper for INDEX2MAP which maintains all of the original header 
;				information contained in the input index. INDEX2MAP leaves some out.
;
; USEAGE:     	mindex2map, index, data, map
;
; INPUT:        
;				INDEX		- A header structure output from routines such as MREADFITS.
;
;				DATA		- The image contained in the FITS file.
;
; KEYWORDS:   	
;				QUIET		- Do not print the EXECUTE() errors to the terminal.
;
;				NEST		- Instead of merging the FITS index with the MAP, nest the 
;							  index as a MAP keyword
;
;				FORCEDATA	- Make sure to overwrite any dodgey data field that exists 
;							  in the index structure already
;
; OUTPUT:    
;   	    	MAP			- The output (Zarro) image map structure with a complete 
;							FITS header.  
;   	    	
; EXAMPLE:    	
;				IDL> mreadfits,'soho_image.fits',index,data
;				IDL> mindex2map, index, data, map, /quiet
;         
; AUTHOR:     	10-Nov-2009 P.A.Higgins - Written
;				02-Aug-2012 PAH - switched from execute to using native CREATE_STRUCT routine
;				16-Jul-2013 PAH - tried to speed it up for STEREO when there are >100 tag names, 
;								  but it is still SLOW! Why is create_struct so slow??
;
; CONTACT:		info@solarmonitor.org
;
; VERSION   	0.0
;-
;---------------------------------------------------------------------->

pro mindex2map, inindex, indata, outmap, quiet=quiet, nest=nest, oldway=oldway, forcedata=forcedata

if keyword_set(quiet) then begin & doquiet1=1 & doquiet2=1 & endif else begin 
	doquiet1=0 & doquiet2=0 & endelse

data=indata
index=inindex

if keyword_set(oldway) then begin

	index2map,index,data,map
	
	;Find if there are any overlapping tag names (keep the map one if overlap is found)
	mtags=tag_names(map)
	itags=tag_names(index)
	
	match,mtags,itags,wm,wi

	;Run through and add tags one at a time to map (skipping if overlap is found)
	for i=0,n_elements(itags)-1 do $
		if (where(wi eq i))[0] eq -1 then map=create_struct(map,itags[i],index.(i))

	if keyword_set(forcedata) then add_prop,map,data=data,/replace
	
	outmap=map
	return

endif

wcs=fitshead2wcs(index)

wcs2map,data,wcs,map

;Find if there are any overlapping tag names (keep the map one if overlap is found)
mtags=tag_names(map)
itags=tag_names(index)

match,mtags,itags,wm,wi


ntag=n_elements(mtags)
nitag=n_elements(itags)

;using add_prop--------------------------------------------------------------->
if keyword_set(nest) then begin
	add_prop,map,index=index 
	add_prop,map,wcs=wcs 
endif else begin
;using create_struct---------------------------------------------------------->

	if ntag gt 50 then begin
	
		niter=ntag/50
		if ntag mod 50 gt 0 then niter=niter+1
	
		for j=0,niter-1 do begin
		
		;Check for repeated tag names
			indtag=0
			thisrng=[j*50, ((j*50+50-1) < (ntag-1))]
			for i=thisrng[0], thisrng[1] do $
				if (where(wm eq i))[0] eq -1 then indtag=[indtag,i]
			indtag=indtag[1:*]
			ngood=n_elements(indtag)
			
			exstr='index=create_struct('+strjoin( $
				strarr(ngood)+'mtags['+strtrim(indtag,2)+'],'+ $
				strarr(ngood)+'map.('+strtrim(indtag,2)+'),','')+' index)'
			status=execute(exstr)
		
		endfor
	
		map=index
	
	endif else begin
	
	;Check for repeated tag names
		indtag=0
		for i=0,ntag-1 do $
			if (where(wm eq i))[0] eq -1 then indtag=[indtag,i]
		indtag=indtag[1:*]
		ngood=n_elements(indtag)
		
		exstr='map=create_struct('+strjoin( $
			strarr(ngood)+'mtags['+strtrim(indtag,2)+'],'+ $
			strarr(ngood)+'map.('+strtrim(indtag,2)+'),','')+' index)'
		status=execute(exstr)
	
	endelse

endelse

if keyword_set(forcedata) then add_prop,map,data=data,/replace

outmap=map

return










;creating structure from scratch---------------------------------------------->
;Check for repeated tag names
indtag=0
for i=0,ntag-1 do $
	if (where(wm eq i))[0] eq -1 then indtag=[indtag,i]
indtag=indtag[1:*]
ngood=n_elements(indtag)

strmap=strjoin( $
	mtags[indtag]+':'+ $
	strarr(ngood)+'map.('+strtrim(indtag,2)+')',',')

strind=strjoin( $
	itags+':'+ $
	strarr(nitag)+'index.('+strtrim(indgen(nitag),2)+')',',')

exstr='map2={'+strmap+','+strind+'}'

status=execute(exstr)

stop

;using str_merge--------------------------------------------------------------->
map2=str_merge(index,map,/down)

stop

;using add_prop--------------------------------------------------------------->
map2=index
for i=0,ntag-1 do status=execute('add_prop,map2,'+mtags[i]+'=map.('+strtrim(i,2)+')'+',/replace')

stop

;using combine_structs-------------------------------------------------------->
;combine_structs,map,index,map2
;outmap=map2
;return


;for i=0,ntags-1 do begin
;	exstring='add_prop,map,'+tags[i]+'=index.(i)'
;	err = execute(exstring, doquiet1, doquiet2)
;endfor

outmap=map


end