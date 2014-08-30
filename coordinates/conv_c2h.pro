
function conv_c2h, carr, time, dc=dc, arcmin=arcmin, qs=qs

;+
;NAME:
;	conv_c2h
;PURPOSE:
;	To convert from Carrington coordinates to heliocentric coordinates
;	Carrington longitude or decimal Carrington rotation number is
;	input (along with helio_graphic latitude, optionally).
;	
;SAMPLE CALLING SEQUENCE:
;       helio = conv_c2h(273.16, time)
;       helio = conv_c2h([273.16, -25], time)
;       helio = conv_c2h([1857.23, 17], time, /dc)
;       helio = conv_c2h(carrington_longitude, time,)
;       helio = conv_c2h([carrington_longitude, helio_latitude], time,)
;       helio = conv_c2h(helio, suncenter=[400,400])
;INPUT:
;       carr_coords - The Carrington longitude or decimal Carrington
;                 rotation number (and heliographic latitude, if it was
;                 input - heliographic latitude will be carried through
;                 unchanged for convenience).
;                       (0,*) = longitude (degrees) or decimal Carrington
;                               rotation number
;                       (1,*) = latitude (degrees) N positive
;OPTIONAL INPUT:
;	time	- The time for the conversion requested.  This is needed
;		  to determine the location of a given carrington longitude
;		  in heliographic coordinates.
;OUTPUT:
;	helio	- The heliographic longitude and latitude in degrees.
;                       (0,*) = longitude (degrees)
;                       (1,*) = latitude (degrees) N positive
;OPTIONAL KEYWORD INPUT:
;	dc	- If set the input longitude is assumed to be decimal
;		  Carrington rotation number (eg 1857.23)
;		  number
;OPTIONAL KEYWORD OUTPUT:
;       behind -  A flag which is set to 1 when there are points behind limb
;HISTORY:
;	Written 14-Feb-94 by G.L. Slater using Morrison's CONV_P2H as a
;		template
;TODO:
;-

if n_elements(time) eq 0 then time = !stime
out = carr
c_lon_cen = tim2carr(time)
if keyword_set(dc) eq 1 then $
  out(0,*) = (1-(out(0,*)-fix(out(0,*))))*360. - c_lon_cen else $
  out(0,*) = out(0,*) - c_lon_cen
low = where(out(0,*) lt -180, count_lo)
if count_lo gt 0 then out(0,low) = out(0,low) + 360
hi = where(out(0,*) gt 180, count_hi)
if count_hi gt 0 then out(0,hi) = out(0,hi) - 360

if keyword_set(qs) eq 1 then stop
return, out

end

