;script to test the great circle routines in heliographic coordinates

;CONSTRUCT A VIRTUAL SUN
date=systim(/utc)
xyrcoord,[0,1024,1024],xx,yy,rr
;plot_image,rr
xr=(findgen(1024)-512)*2.
yr=(findgen(1024)-512)*2.
rr=rr*2.                 
rsun=960.
rsunmin=rsun/60.
img=fltarr(1024,1024)
wsun=where(rr le rsun)
img[wsun]=1.         
dx=2.
dy=2.
plot_image,img,origin=[min(xr),min(yr)],scale=[dx,dy]
alonlat=[10.,10.]
axy=hel2arcmin(10.,10.,date=date,rsun=rsun)*60.
blonlat=[15.,5.]
bxy=hel2arcmin(5.,15.,date=date,rsun=rsun)*60.

;TEST INCLINATION ROUTINE
inc=gc_inc(alonlat,blonlat,outeq=nlonlat)
print,'inc',inc

oplot,[axy[0],bxy[0]],[axy[1],bxy[1]],ps=-1,col=!red

;PLOT HG GRID LINES ON SPHERE
nlat=19
nlon=181
gridlat=(findgen(nlat)-9)*10.
gridlon=findgen(nlon)-90.
for i=0,nlat-1 do begin
	thisxy=hel2arcmin(fltarr(nlon)+gridlat[i],gridlon,date=date,rsun=rsun)*60.
	thisxyvert=hel2arcmin(gridlon,fltarr(nlon)+gridlat[i],date=date,rsun=rsun)*60.
	oplot,thisxy[0,*],thisxy[1,*],lines=1,color=!blue
	oplot,thisxyvert[0,*],thisxyvert[1,*],lines=1,color=!blue
endfor

;PLOT LIMB ON SPHERE
lblat=findgen(900)/(899.)*180.-90.
lblat=[lblat,reverse(lblat)]
lblon=[fltarr(900)+90.,fltarr(900)-90.]
lbxy=hel2arcmin(lblat,lblon,date=date,rsun=rsun)
oplot,lbxy[0,*]*60,lbxy[1,*]*60.,col=!forest,thick=2

;contour,rr,lev=rsun,col=!forest,/over;,/noerase,/iso,pos=[.1,.1,.9,.9]

;stop

;      !red,     !orange, !green,  !forest
aarr=[[-60,45],[-45,-30],[55,-35],[25,40]]
barr=[[-55,55],[-40,-40],[70,-20],[35,55]]

print,gc_inc(aarr,barr)

aarras=hel2arcmin(aarr[1,*],aarr[0,*],date=date,rsun=rsun)*60.
barras=hel2arcmin(barr[1,*],barr[0,*],date=date,rsun=rsun)*60.

for i=0,3 do oplot,[aarras[0,i],barras[0,i]],[aarras[1,i],barras[1,i]],ps=-1,color=!red+i

;stop

;TEST DISTANCE ROUTINE
lbcl=gc_dist(alonlat, blonlat, outeqnode=nlatlon, outadist=da, outmid=mlonlat)
lbclarr=gc_dist(aarr, barr, outeqnode=narr, outadist=daarr)

;plot the axis of the GC
mxy=hel2arcmin(mlonlat[1,0],mlonlat[0,0],date=date)*60.
oplot,[pxy[0],mxy[0]],[pxy[1],mxy[1]],ps=-1,lines=1,color=0

;TEST PLOTTING GCs (USING DISTANCE ALONG GC)
distarr=findgen(360)-180. ;-da[0] ;distance in degrees along the GC
plonlat=gc_fit(alonlat, blonlat, distarr=distarr, outfit=outadlonlat, outeqnode=outeqnode, outinc=outinc)
pslonlat=gc_fit(alonlat, blonlat, /south)

pxy=hel2arcmin(plonlat[1],plonlat[0],date=date)*60
plots,pxy[0],pxy[1],ps=1,color=0
plots,mxy[0],mxy[1],ps=1,color=0
psxy=hel2arcmin(pslonlat[1],pslonlat[0],date=date)*60
oplot,[pxy[0],psxy[0]],[pxy[1],psxy[1]],color=0,lines=1,ps=-1

;dxy=hel2arcmin(outadlonlat[1],outadlonlat[0],date=date)*60

dxy=hel2arcmin(outadlonlat[1,*],outadlonlat[0,*],date=date)*60

oplot,dxy[0,*],dxy[1,*],ps=3,color=!red

stop

end