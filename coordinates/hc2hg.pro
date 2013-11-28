;convert heliocentric to heliographic coordinates using the usual SSW routines.
;HC coords are in arcsecs
;HG coords are in degrees
;Rsun is in arcsec
;Optionally outputs the carrington longitude
;NOTE: inputting Rsun allows the conversion for FOVs other than earth
;      perspective. If Rsun is not input, earth perspective is assumed.
;
;If ROTDATE is set, then the HG and CAR coords will be valid on the
;ROTDATE as opposed to the DATE, which cooresponds to the HC coords.
;
;Example to determine the HG coord of an AR in MDI data a day after
;measured in HC coord:
;IDL> hc2hg,301.,-200.,rsun=,outhgx,outhgy,outcarx,date='1-jan-2013 00:00',rotdate='2-jan-2013 00:00',

pro hc2hg, hcx, hcy, hgx, hgy, carx, date=indate, rsunarcsec=rsun, $
           rotdate=rotdate
date=indate

hglatlon=arcmin2hel(hcx/60., hcy/60., date=date, rsun=rsun)

hgy=hglatlon[0]
hgx=hglatlon[1]

if n_elements(rotdate) eq 1 then begin
   ddays=(anytim(rotdate)-anytim(date))/24./3600.
   dlon=DIFF_ROT(ddays, hgy)
   hgx=theta_shift(hgx+dlon,/n180)
   date=rotdate
endif

carx=tim2carr(date, offset=hgx)


return

end
