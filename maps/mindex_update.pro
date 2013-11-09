;take an index that has been read from a map structure (map2index; that may have
;been rotated, drotted, etc) and use it to update the full index that
;was read from the original fits file

pro mindex_update, indmap, indfull, indnew, nozero=nozero

indnew=indfull

tags=strlowcase(tag_names(indmap))
ntags=n_elements(tags)

tagsfull=strlowcase(tag_names(indfull))

for i=0,ntags-1 do begin

   if keyword_set(nozero) then begin
      if data_type(indmap.(i)) eq 7 then $
         if strtrim((indmap.(i))[0],2) eq '' then continue
      if data_type(indmap.(i)) ne 7 then $
         if strtrim((indmap.(i))[0],2) eq 0 then continue
   endif

   thistag=tags[i]

;Find where the tag is exactly the same, not where just part of the
;tag name matches
   wtag=where(strpos(tagsfull,thistag) ne -1)

   if wtag[0] ne -1 then begin
      wtagmatch=where(strlen(tagsfull[wtag]) eq strlen(thistag))
      if wtagmatch[0] ne -1 then wtag=wtag[wtagmatch[0]] else wtag=-1
   endif

   if wtag[0] ne -1 then begin
      indnew.(wtag)=indmap.(i)
   endif else indnew=create_struct(indnew,thistag,indmap.(i))
;status=execute('add_prop,'+thistag+'=indmap.(i),/replace')

endfor

end
