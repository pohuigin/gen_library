;input in arcsec
;Use after running sub_map, when desired width is truncated by the
;limb
;This buffers out the width or height of the image to match the
;desired image size


;UNFINISHED!!!!!!!
function map_buffer, inmap, buffval=inbuffval;, xycen=inxycen, xwidth=inx, yheight=iny

map=inmap

if n_elements(inbuffval) ne 1 then buffval=0 else buffval=inbuffval

imgsz=size(map.data,/dim)
buffx=fltarr(imgsz[0]/4.,imgsz[1])*buffval
datbuff=[buffx,map.data,buffx]
buffy=fltarr(imgsz[0]*1.5,imgsz[1]/4.)*buffval
datbuff=[[buffy],[datbuff],[buffy]]
add_prop,map,data=datbuff,/replace

return,map








;map=inmap
;xycen=inxycen
;xwidth=inx
;yheight=iny

;imgsz=size(map.data)

;if xwidth ne imgsz[0] then begin
;   buffx=xwidth-imgsz[0]
;   buffimgx=fltarr(buffx,imgsz[1])
;   if xycen[0] gt 0 then 
;endif
;if yheight ne imgsz[1] then begin
;
;endif

;if xwidth ne imgsz[0] or yheight ne imgsz[1] then add_prop,map,data=newdat,/replace










end
