;Given positions in pixel coordinates (x = [0->nx-1]; y = [0->ny-1]),
;determine the HC x and y coordinates in arcseconds
;Input:
;    XPX, YPX = pixel coordinates of AR positions.
;    DX, DY = arcsec/px
;    XC, YC = FOV center in arcsec from solar disk center
;    XS, YS = X and Y px size of the image

pro px2hc, xpx, ypx, hcx, hcy, dx=dx, dy=dy, xc=xc, yc=yc, xs=xs, ys=ys

hcx=(xpx-xs/2.)*dx+xc

hcy=(ypx-ys/2.)*dy+yc




return

end
