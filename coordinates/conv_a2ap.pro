
function conv_a2ap, ang_in, time_in, arcmin_in=arc_min_in, $
  arcmin_out=arcmin_out, rsun_unit=rsun_unit, spherical=spherical, $
  roll=roll, radians=radians, qstop=qstop

;+
;NAME:
;	conv_a2ap
;PURPOSE:
;	To convert angular offsets from sun center to either 2-D polar
;	coordinates or sun-centered spherical polar coordinates, in the
;	latter case using the assumption that all points are constrained
;	to lie on the surface of a sphere of radius equal to the solar
;	photospheric radius.
;SAMPLE CALLING SEQUENCE:
;       out = conv_a2ap(ang, time_in)
;       out = conv_a2ap(ang, time_in, /rsun_unit)
;INPUT:
;	ang_in	- The angular offsets in arcseconds as viewed from the earth.
;			(0,*) = E/W direction with W positive
;			(1,*) = N/S direction with N positive
;OPTIONAL INPUT:
;	time	- The time for the conversion in question.  This is needed
;		  for SXT so that the pixel location of the center of the sun
;		  can be determined.
;OUTPUT:
;	pix	- The pixel coordinates of the point(s) in question.  Larger pixel
;		  address towards the N and W.
;			(0,*) = E/W direction
;			(1,*) = N/S direction
;OPTIONAL KEYWORD INPUT:
;       arcmin_in
;		- If set, the input radius is assumed to be in units of
;		  arc minutes.
;       arcmin_out
;		- If set, the output radius is in units of arc minutes.
;       rsun_unit -
;                 If set, return radius in units solar radii.
;       spherical -
;                 If set, then in place of the radius coordinate return
;		  the angle between the specified point and the axis
;		  defined by the center of the solar sphere and the center
;		  of the solar disk.
;       roll    - This is the S/C roll value in degrees
;HISTORY:
;       Written 21-Mar-95 by G. Slater starting from MDM's CONV_A2P
;-

if (keyword_set(arcmin_in)) then ang = ang_in*60 else ang = ang_in
nout = n_elements(ang0)/2

if (n_elements(time_in) eq 0) then time = anytim2ints(!stime) else $
				   time = anytim2ints(time_in)
if ((n_elements(time) ne nout) and (n_elements(time) ne 1)) then begin
  message, 'Improper number of times.  Using first time for all points.', $
    /info
  time = time(0)
endif

x = float(ang_in(0,*)) & y = float(ang_in(1,*))

if n_elements(roll) ne 0 then begin
  sroll = sin(roll/!radeg)
  croll = cos(roll/!radeg)
  x =  croll*x + sroll*y
  y = -sroll*x + croll*y
endif

p_angle = atan(-x(0,*),y(0,*))
neg_vals = where(p_angle lt 0,count_neg)
if count_neg gt 0 then p_angle(neg_vals) = p_angle(neg_vals) + 2*!pi
if keyword_set(radians) eq 0 then p_angle = p_angle*!radeg

r = sqrt(x(0,*)*x(0,*) + y(0,*)*y(0,*))
r_out = r
if keyword_set(rsun_unit) then begin
  r_sun = get_rb0p(time,/r)
  r_out = r/r_sun
  if keyword_set(arcmin) then r_out = r_out*60.
endif
if keyword_set(spherical) then begin
  r_out = fltarr(n_elements(x)) + !pi/2
  r_sun = get_rb0p(time,/r)
  on_disk_vals = where(r le r_sun, count_on_disk)
  if count_on_disk gt 0 then $
    r_out(on_disk_vals)  = asin(r(on_disk_vals)/r_sun)
  if keyword_set(radians) eq 0 then r_out = r_out*!radeg
endif

out = transpose([[reform(r_out)],[reform(p_angle)]])

if keyword_set(qstop) then stop

return, out
end

