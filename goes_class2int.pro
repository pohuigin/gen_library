;Convert GOES class back into intensity values

function goes_class2int, class

nflr=n_elements(class)

intensity=fltarr(nflr)-1.

wa2=where(strpos(strlowcase(class),'a') ne -1)
wb2=where(strpos(strlowcase(class),'b') ne -1)
wc2=where(strpos(strlowcase(class),'c') ne -1)
wm2=where(strpos(strlowcase(class),'m') ne -1)
wx2=where(strpos(strlowcase(class),'x') ne -1)

;stop

if wa2[0] ne -1 then intensity[wa2]=float(strmid(class[wa2],1,3))*1d-8
if wb2[0] ne -1 then intensity[wb2]=float(strmid(class[wb2],1,3))*1d-7
if wc2[0] ne -1 then intensity[wc2]=float(strmid(class[wc2],1,3))*1d-6
if wm2[0] ne -1 then intensity[wm2]=float(strmid(class[wm2],1,3))*1d-5
if wx2[0] ne -1 then intensity[wx2]=float(strmid(class[wx2],1,3))*1d-4


return,intensity

end
