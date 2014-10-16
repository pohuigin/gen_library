
function conv_p2c, pix, time, dc=dc, off_limb=off_limb, $
  roll=roll, hxa=hxa, cmd=cmd, suncenter=suncenter, pix_size=pix_size0, $
  radius=radius, qs=qs

;+
;NAME:
;	conv_p2c
;PURPOSE:
;	To convert from an SXT pixel location to Carrington coordinates
;SAMPLE CALLING SEQUENCE:
;	clon = conv_p2c(pix, time)
;	clon = conv_p2c([x,y], time, /dc)
;	clon = conv_p2c(pix, time, suncenter=[400,400])
;INPUT:
;	pix	- The pixel coordinates of the point(s) in question.
;		  Larger pixel address towards the N and W.
;			(0,*) = E/W direction
;			(1,*) = N/S direction
;OPTIONAL INPUT:
;	time	- The time for the conversion in question.  This is needed
;		  for SXT so that the pixel location of the center of the sun
;		  can be determined.  It may be an index structure.
;OUTPUT:
;	clon	- The Carrington longitude or decimal Carrington rotation
;		  number (eg 1857,23) and heliographic latitude
;		  in degrees.
;                       (0,*) = longitude (degrees) or decimal Carrington
;				rotation number (if DC is set)
;                       (1,*) = latitude (degrees) N positive
;OPTIONAL KEYWORD INPUT:
;	dc	- If set output longitude is in decimal Carrington rotation
;		  number
;	roll	- This is the S/C roll value in degrees
;       hxa     - If set, use HXA_SUNCENTER to determine the location of the
;                 sun center in pixels, which means that only HXA data is
;                 used.  Default is to use GET_SUNCENTER instead, which uses
;                 both HXA and IRU data to determine the pointing.
;	cmd	- If set, use SXT_CMD_PNT to determine the location of the
;                 sun center in pixels. Default is to use GET_SUNCENTER.
;	suncenter - Pass the derived location of the sun center in pixels (x,y)
;	pix_size - The size of the pixels in arcseconds.  If not passed, it
;		  uses GT_PIX_SIZE (2.45 arcsec).  This option allows the
;		  routine to be used for ground based images.
;	radius	- The radius in pixels.  GET_RB0P is called to get the radius
;		  and it is used to get the pixel size.  This option allows the
;		  routine to be used for ground based images.
;OPTIONAL KEYWORD OUTPUT:
;       off_limb - A flag which is set to 1 when there are points off the limb
;HISTORY:
;	Written 14-Feb-94 by G.L. Slater using Morrison's CONV_P2H as a
;		template
;TODO:
;	Add string output option
;-

ang   = conv_p2a(pix, time, arcmin=arcmin, roll=roll, hxa=hxa, cmd=cmd, $
	       suncenter=suncenter, pix_size=pix_size0, radius=radius)
helio = conv_a2h(ang, time, arcmin=arcmin, off_limb=off_limb)
out   = conv_h2c(helio, time, dc=dc)

if keyword_set(qs) eq 1 then stop
return, out

end

