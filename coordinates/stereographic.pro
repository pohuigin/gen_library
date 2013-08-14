pro stereographic, long, lat, x, y, southpole=southpole, inverse=inverse

;+
; NAME: STEREOGRAPHIC PURPOSE: Convert long and lat to X,Y, or vice-versa,
; using a stereographic projection.
;
; EXPLANATION:
;       The output X and Y coordinates are normalized so that latitude 0
;       (the equator) lies at radius R=1 [R = sqrt(x^2 + y^2)] The pole has
;            R=0 and lies at lat=90.
;       Output points can be centered on the north pole or south pole.
;
; CALLING SEQUENCE:
;       STEREOGRAPHIC, long, lat, X, Y, [ /SOUTHPOLE ], [ /INVERSE ]
;
; INPUTS:
;       long - longitude - scalar or vector, in degrees
;       lat - latitude - same number of elements as long, in degrees
;
; OUTPUTS:
;       X - X coordinate, same number of elements as long.   X is normalized
;           so that 90 deg away from the pole occurs at radius = 1
;       Y - Y coordinate, same number of elements as long.  Y is normalized
;           like X
;
; KEYWORDS:
;       /SOUTHPOLE - Keyword to indicate that the plot is to be centered on
;                    the south pole instead of the north pole.
;       /INVERSE - go from X,Y to long, lat
;-

if keyword_set(inverse) then begin
   radius= sqrt( x^2 + y^2)

   if keyword_set( southpole) then begin
      lat= -90.+ 2.*!radeg*atan(radius)
      long=!radeg*atan( y, -x)  
           endif else begin
         lat= 90.- 2.*!radeg*atan(radius)
         long=!radeg*atan( y, x) 
      endelse
      return
 endif


if keyword_set( southpole) then begin
   radius = tan( !dtor* 0.5* (-90.-lat))
   x= radius* cos(!dtor* long)
   y= -radius* sin(!dtor* long)

endif else begin
   radius = tan( !dtor* 0.5* (90.-lat))
   x= radius* cos(!dtor* long)
   y= radius* sin(!dtor* long)
endelse

return
end

