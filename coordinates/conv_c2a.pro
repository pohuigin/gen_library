
function conv_c2a, carr, time, dc=dc, roll=roll, $
  hxa=hxa, cmd=cmd, suncenter=suncenter, pix_size=pix_size0, $
  radius=radius, arcmin=arcmin, behind=behind, qs=qs

;+
;NAME:
;       conv_c2a
;PURPOSE:
;       Converts Carrington coordinates to
;	  anglular-offsets-from-suncenter coordinates
;SAMPLE CALLING SEQUENCE:
;	ang = conv_c2p(clon, time)
;	ang = conv_c2p(clon, time, /dc)
;	ang = conv_c2p(clon, suncenter=[400,400])
;INPUT:
;       clon    - The Carrington longitude and heliographic latitude
;                 in degrees.
;                       (0,*) = longitude (degrees)
;                       (1,*) = latitude (degrees) N positive
;       time    - The time for the conversion in question.  This is needed
;                 for SXT so that the pixel location of the center of the sun
;                 can be determined.  It may be an index structure.
;OUTPUT:
;       ang     - Vector of angles from sun center in default units of
;                 arcseconds.  It should be 2xN.
;                       (0,*) = angle in E/W direction with W positive
;                       (1,*) = angle in N/S direction with N positive
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
;       arcmin  - If set, output is in arcminutes, rather than
;                 arcseconds.
;OPTIONAL KEYWORD OUTPUT:
;       behind  - Returns a binary vector set to 1 when points are behind
;                 the visible limb.
;HISTORY:
;       Written 4-Aug-94 by G.L. Slater using CONV_H2P as a template
;TODO:
;-

helio = conv_c2h(carr, time, dc=dc)
ang   = conv_h2a(helio, time, arcmin=arcmin, behind=behind)

return, ang
end

