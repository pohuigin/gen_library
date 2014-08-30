;Given positions in heliocentric, projective coordinates,
;determine the PX x and y coordinates (x = [0->nx-1]; y = [0->ny-1])
;Input:
;    HCX, HCY = HC coordinates of AR positions.
;    DX, DY = arcsec/px
;    XC, YC = FOV center in arcsec from solar disk center
;    XS, YS = X and Y px size of the image

pro hc2px, hcx, hcy, xpx, ypx, dx=dx, dy=dy, xc=xc, yc=yc, xs=xs, ys=ys

xpx=(hcx-xc)/dx+xs/2.

ypx=(hcy-yc)/dy+ys/2.


return

end
