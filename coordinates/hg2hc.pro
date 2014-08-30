;convert heliographic to heliocentric coordinates using the usual SSW routines.
;HC coords are in arcsecs
;HG coords are in degrees
;Rsun is in arcsec
;NOTE: inputting Rsun allows the conversion for FOVs other than earth
;      perspective. If Rsun is not input, earth perspective is assumed.
;
;If ROTDATE is set, then the HC coords will be valid on the
;ROTDATE as opposed to the DATE, which cooresponds to the HG coords.
;
;Example to determine the HG coord of an AR in MDI data a day after
;measured in HC coord:
;IDL> hg2hc,25.,-45.,outhcx,outhcy,rsun=rsun,date='1-jan-2013 00:00',rotdate='2-jan-2013 00:00',

pro hg2hc, inhgx, inhgy, outhcx, outhcy, date=indate, rsunarcsec=rsun, $
           rotdate=rotdate
date=indate
hgx=inhgx
hgy=inhgy

if n_elements(rotdate) eq 1 then begin
   ddays=(anytim(rotdate)-anytim(date))/24./3600.
   dlon=DIFF_ROT(ddays, hgy)
   hgx=theta_shift(hgx+dlon,/n180)
   date=rotdate
endif


hcxy=hel2arcmin(hgy,hgx, date=date, rsun=rsun)

outhcx=hcxy[0]*60.
outhcy=hcxy[1]*60.

return

end