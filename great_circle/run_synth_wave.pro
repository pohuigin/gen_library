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

loadct,0
plot_image,img,origin=[min(xr),min(yr)],scale=[dx,dy]
setcolors,/sys,/sil

alonlat=[23.,7.]
axy=hel2arcmin(alonlat[1],alonlat[0],date=date,rsun=rsun)*60.
blonlat=[76.,35.]
bxy=hel2arcmin(blonlat[1],blonlat[0],date=date,rsun=rsun)*60.

;TEST INCLINATION ROUTINE
inc=gc_inc(alonlat,blonlat,outeq=nlonlat)
print,'inc',inc

oplot,[axy[0],bxy[0]],[axy[1],bxy[1]],ps=-1,col=!red

;stop

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

;TEST DISTANCE ROUTINE
lbcl=gc_dist(alonlat, blonlat, outeqnode=nlatlon, outadist=da, outmid=mlonlat)
;lbclarr=gc_dist(aarr, barr, outeqnode=narr, outadist=daarr)

;stop

;TEST PLOTTING GCs (USING DISTANCE ALONG GC)
nmap=20
distarr=findgen(nmap)/float(nmap-1.)*70.+da[0] ;distance in degrees along the GC
plonlat=gc_fit(alonlat, blonlat, distarr=distarr, outfit=outadlonlat, outeqnode=outeqnode, outinc=outinc)

;pslonlat=gc_fit(alonlat, blonlat, /south)
;pxy=hel2arcmin(plonlat[1],plonlat[0],date=date)*60
;plots,pxy[0],pxy[1],ps=1,color=0
;plots,mxy[0],mxy[1],ps=1,color=0
;psxy=hel2arcmin(pslonlat[1],pslonlat[0],date=date)*60
;oplot,[pxy[0],psxy[0]],[pxy[1],psxy[1]],color=0,lines=1,ps=-1

;dxy=hel2arcmin(outadlonlat[1],outadlonlat[0],date=date)*60

dxy=hel2arcmin(outadlonlat[1,*],outadlonlat[0,*],date=date)*60

oplot,dxy[0,*],dxy[1,*],ps=-1,color=!orange

;make sample map
mreadfits,'~/science/procedures/chole_detect/data/mag/svsm_m1100_S2_20120706_1728.fts.gz',mind,mdat
index2map,mind,mdat,mmap
mmap.rsun=rsun
mmap.dx=dx
mmap.dy=dy
mmap.id='Synthetic Wave Data'
mmap.time='1-Jan-2012 00:00'
add_prop,mmap,data=img,/repl

loadct,0
;maparr=replicate(mmap,nmap) ;a dot
;a blurred dot
;a noisey blurred dot
lasttime=mmap.time
for i=0,n_elements(dxy[0,*])-1 do begin
	thisdat=fltarr(1024,1024)+1.
	thismap=mmap
	thismap.time=anytim(anytim(lasttime)+12.,/vms)
	print,[(dxy[0,i]+512.*mmap.dx)/mmap.dx,(dxy[1,i]+512.*mmap.dy)/mmap.dy]
	thisdat[fix(round((dxy[0,i]+512.*mmap.dx)/mmap.dx)),fix(round((dxy[1,i]+512.*mmap.dy)/mmap.dy))]=1000000.
	
	;do blur
;	thisdat=smart_grow(thisdat,rad=20,/gaus)
	
	thismap.data=thisdat ;*img
;	plot_map,thismap;,smooth=10

;	stop
	maparr[i]=thismap
	lasttime=thismap.time
endfor

save,maparr,file='~/science/procedures/gen/great_circle/data/synth_wave_dot.sav',/compress
;save,maparr,file='~/science/procedures/gen/great_circle/data/synth_wave_gauss.sav'
;save,maparr,file='~/science/procedures/gen/great_circle/data/synth_wave_gauss_noise.sav'


stop

end