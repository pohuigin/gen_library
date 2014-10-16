
function conv_p2ap, pix, time_in, arcmin_out=arcmin_out, $
  rsun_unit=rsun_unit, spherical=spherical, $
  hxa=hxa, cmd=cmd, suncenter=suncenter, pix_size=pix_size0, $
  pix_rad=pix_rad, roll=roll, radians=radians, $
  qstop=qstop

;+
;NAME:
;	conv_p2ap
;PURPOSE:
;	To convert CCD pixel coordinates to polar coordinates (radius, position angle).
;SAMPLE CALLING SEQUENCE:
;	out = conv_p2ap(pix, time_in)
;	out = conv_p2ap(pix, suncenter=[400,400])
;INPUT:
;	pix	- The pixel coordinates of the point(s) in question.  Larger pixel
;		  address towards the N and W.
;			(0,*) = E/W direction
;			(1,*) = N/S direction
;OPTIONAL INPUT:
;	time_in	- The time for the conversion in question.  This is needed
;		  for SXT so that the pixel location of the center of the sun
;		  can be determined.
;OUTPUT:
;	out	- The radius and position angle corresponding to the pixel
;		  coordinates.  The radius is given in arcsec by default.
;		  If ARCMIN_OUT is set the radius is given in arcmin.
;		  If RSUN_UNIT is set the radius is given in units of solar
;		  radii.
;			(0,*) = Radius in arcsec or arcmin or solar radii.
;			(1,*) = Position angle of feature measured eastward from solar
;				north pole.
;OPTIONAL KEYWORD INPUT:
;	arcmin_out
;		- If set, return radius in units of arc minutes.
;	rsun_unit -
;		  If set, return radius in units solar radii.
;       spherical -
;                 If set, then in place of the radius coordinate return
;                 the angle between the specified point and the axis
;                 defined by the center of the solar sphere and the center
;                 of the solar disk.
;	roll	- This is the spacecraft roll value in degrees.
;	hxa	- If set, use HXA_SUNCENTER to determine the location of the
;		  sun center in pixels.  Default is to use GET_SUNCENTER.
;	cmd	- If set, use SXT_CMD_PNT to determine the location of the
;                 sun center in pixels. Default is to use GET_SUNCENTER.
;	suncenter -
;		  Pass the derived location of the sun center in pixels (x,y)
;	pix_size -
;		  The size of the pixels in arcseconds.  If not passed, it
;		  uses GT_PIX_SIZE (2.45 arcsec).  This option allows the
;		  routine to be used for ground based images.
;	pix_rad	- The radius in pixels.  GET_RB0P is called to get the radius
;		  and it is used to get the pixel size.  This option allows the
;		  routine to be used for ground based images.
;HISTORY:
;	Written 20-Mar-95 by G. Slater starting from MDM's CONV_P2A
;-

ang_in = conv_p2a(pix, time_in, arcmin=arcmin_out, roll=roll, $
  hxa=hxa, cmd=cmd, suncenter=suncenter, $
  pix_size=pix_size0, radius=pix_rad)

out = conv_a2ap(ang_in, time_in, arcmin_in=arcmin_in, $
  arcmin_out=arcmin_out, rsun_unit=rsun_unit, spherical=spherical, $
  radians=radians)

if keyword_set(qstop) then stop

return, out
end

