
function conv_c2p, carr, time, dc=dc, roll=roll, $
  hxa=hxa, cmd=cmd, suncenter=suncenter, pix_size=pix_size0, $
  radius=radius, qs=qs

;+
;NAME:
;       conv_c2p
;PURPOSE:
;       To convert from Carrington coordinates to SXT pixel location
;SAMPLE CALLING SEQUENCE:
;	pix = conv_c2p(clon, time)
;	pix = conv_c2p(clon, time, /dc)
;	pix = conv_c2p(clon, suncenter=[400,400])
;INPUT:
;       clon    - The Carrington longitude and heliographic latitude
;                 in degrees.
;                       (0,*) = longitude (degrees)
;                       (1,*) = latitude (degrees) N positive
;OPTIONAL INPUT:
;       time    - The time for the conversion in question.  This is needed
;                 for SXT so that the pixel location of the center of the sun
;                 can be determined.  It may be an index structure.
;OUTPUT:
;       pix     - The pixel coordinates of the point(s) in question.
;                 Larger pixel address towards the N and W.
;                       (0,*) = E/W direction
;                       (1,*) = N/S direction
;OPTIONAL KEYWORD INPUT:
;       dc      - If set input longitude is assumed to be decimal
;		  Carrington rotation number (eg 1857.23)
;                 number
;       roll    - This is the S/C roll value in degrees
;       hxa     - If set, use HXA_SUNCENTER to determine the location of the
;                 sun center in pixels, which means that only HXA data is
;		  used.  Default is to use GET_SUNCENTER instead, which uses
;		  both HXA and IRU data to determine the pointing.
;       cmd     - If set, use SXT_CMD_PNT to determine the location of the
;                 sun center in pixels. Default is to use GET_SUNCENTER.
;       suncenter - Pass the derived location of the sun center in pixels (x,y)
;       pix_size - The size of the pixels in arcseconds.  If not passed, it
;                 uses GT_PIX_SIZE (2.45 arcsec).  This option allows the
;                 routine to be used for ground based images.
;       radius  - The radius in pixels.  GET_RB0P is called to get the radius
;                 and it is used to get the pixel size.  This option allows
;		  the routine to be used for ground based images.
;OPTIONAL KEYWORD OUTPUT:
;HISTORY:
;       Written 14-Feb-94 by G.L. Slater using Morrison's CONV_H2P as a
;               template
;TODO:
;-

helio = conv_c2h(carr, time, dc=dc)
ang   = conv_h2a(helio, time, arcmin=arcmin)
out   = conv_a2p(ang, time, arcmin=arcmin, roll=roll, $
		 hxa=hxa, cmd=cmd, suncenter=suncenter, $
		 pix_size=pix_size0, radius=radius)

return, out
end

