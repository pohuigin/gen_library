;input a map mask (or image) and get a list of pixel (or data) coordinates of the
;contour outlines
;Optionally (over)plot the contours
;INSTRUCT = If a contour/info structure created by this routine is
;input, then skip to the plotting...

function map_contour2xy, map, level=inlevel, datacoord=datacoord, doplot=doplot, over=over, _extra=_extra, instruct=instruct

if data_type(instruct) eq 8 then begin
   doinstruct=1
   doplot=1
   goto,skiptoplot
endif else doinstruct=0

if n_elements(level) eq 0 then level=0.5 else level=inlevel

if data_type(map) eq 8 then begin

   dat=map.data
   xc=map.xc
   yc=map.yc
   dx=map.dx
   dy=map.dy

endif else begin
   
   dat=map
   xc=0.
   yc=0.
   dx=1.
   dy=1.

endelse

sz=size(dat,/dim)

contour,dat,level=level,path_xy=path_xy, path_info=path_info,/PATH_DATA_COORDS,/over

path_xyd=path_xy
path_xyd[0,*]=(path_xy[0,*]-sz[0]/2.)*dx+xc
path_xyd[1,*]=(path_xy[1,*]-sz[1]/2.)*dy+yc

outstr={path_xy:path_xy,path_xyd:path_xyd,path_info:path_info}

skiptoplot:
if doinstruct then begin
   path_xy=outstr.path_xy
   path_xyd=outstr.path_xyd
   path_info=outstr.path_info
endif

ninfos=n_elements(path_info)

maskval=0

if keyword_set(doplot) then begin
   for j=0,ninfos-1 do begin
      info1=path_info[j]
      xx=path_xy[0,info1.offset:info1.offset+info1.n-1]
      yy=path_xy[1,info1.offset:info1.offset+info1.n-1]

      xxd=xx*dx+xc ;path_xyd[0,info1.offset:info1.offset+info1.n-1]
      yyd=yy*dy+yc ;path_xyd[1,info1.offset:info1.offset+info1.n-1]

      if keyword_set(datacoord) then begin
         xx=xxd
         yy=yyd
      endif
      
      if keyword_set(over) then begin
         oplot,xx,yy,_extra=_extra
      endif else begin
         if i eq 0 then plot,xx,yy,_extra=_extra else oplot,xx,yy,_extra=_extra
         
      endelse

   endfor

endif






return,outstr

end
