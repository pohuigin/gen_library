;  script to generate fibril image

;  needs SSW for SOT software

function directional_filter,datarr, do_test=do_test, $
	hwid=inhwid, r0=inr0, l0=inl0, b0=inb0, $
	binfac=inbinfac, arrowbin=inarrowbin, $
	outmagimage=magimage, outplotstr=outplotstr

if not keyword_set(do_test) then do_test=0

;  setup
nfilt=4  ;  number of directions (Jahne says only 4 are needed)
angles=((linrange(nfilt+1,0,180)+(90./nfilt))*!dtor)(0:nfilt-1)

if not keyword_set(inhwid) then hwid=15 else hwid=inhwid  ;  half width of kernel
if not keyword_set(inr0) then r0=4.0 else r0=inr0  ;  highest detectable wave number 
if not keyword_set(inl0) then l0=2.0 else l0=inl0  ;  angular spread (lower number = wider angular spread)
if not keyword_set(inb0) then b0=2.0 else b0=inb0  ;  half-width of the wave number range

if not keyword_set(inbinfac) then binfac=10 else binfac=inbinfac ;16  ;  rebin factor (same for both dimensions), should be integral
if not keyword_set(inarrowbin) then arrowbin=10 else arrowbin=inarrowbin ;16  ;  rebin factor for pointer image, should be integral

;  create filters in phase space
xgrid=linrange(hwid*4+1,-hwid*2,hwid*2)#replicate(1,hwid*4+1)
ygrid=transpose(xgrid)
rgrid=sqrt(xgrid*xgrid+ygrid*ygrid)
wh=where(rgrid eq 0,nwh)
if nwh gt 0 then rgrid(wh)=1d-5
cpgrid=xgrid/rgrid  ;  generates an error at centroid
cpgrid(hwid*2,hwid*2)=0.0     ;  fixes above error
spgrid=ygrid/rgrid  ;  generates an error at centroid
spgrid(hwid*2,hwid*2)=0.0     ;  fixes above error
radpart=exp(-alog(rgrid/r0)^2/(b0/2)^2)
hfilte=fltarr(hwid*4+1,hwid*4+1,nfilt,/noz)
hfilto=complexarr(hwid*4+1,hwid*4+1,nfilt,/noz)
for i=0,nfilt-1 do begin
  costerm=cpgrid*cos(angles(i))+spgrid*sin(angles(i))
  hfilte(*,*,i)=radpart*costerm^(2*l0)
  hfilto(*,*,i)=complex(0,1)*sign_mld(costerm)*radpart*costerm^(2*l0)
endfor

;  create convolution kernels (even kernels detect ridges, odd kernels detect
;  edges, adding their responses in quadrature reveals directionality)
kernele=fltarr(hwid*4+1,hwid*4+1,nfilt,/noz)
kernelo=fltarr(hwid*4+1,hwid*4+1,nfilt,/noz)
for i=0,nfilt-1 do kernele(*,*,i)=$
  shift(float(fft(/inv,shift(hfilte(*,*,i),-hwid*2,-hwid*2))),hwid*2,hwid*2)
for i=0,nfilt-1 do kernelo(*,*,i)=$
  shift(float(fft(/inv,shift(hfilto(*,*,i),-hwid*2,-hwid*2))),hwid*2,hwid*2)
kernele=kernele(hwid:hwid*3,hwid:hwid*3,*)
kernelo=kernelo(hwid:hwid*3,hwid:hwid*3,*)  ;  odd kernels already normalized

if keyword_set(do_test) then begin

  ;  test image: concentric sinusoidal rings with increasing wavenumber
  xgrid=(findgen(1024)-511.5)#replicate(1,1024)
  ygrid=transpose(xgrid)
  r2=xgrid*xgrid+ygrid*ygrid
  imprep=sin(r2/1000)  ;  change divisor to match fibril width

endif else begin

  imprep=datarr

endelse

;  get filtered images
nax=size(imprep,/dim)
imfilte=make_array(dim=[nax,nfilt],/float,/noz)
for i=0,nfilt-1 do imfilte(*,*,i)=convol(imprep,kernele(*,*,i),/edge_tr)
imfilto=make_array(dim=[nax,nfilt],/float,/noz)
for i=0,nfilt-1 do imfilto(*,*,i)=convol(imprep,kernelo(*,*,i),/edge_tr)
imfiltm=sqrt(imfilte*imfilte+imfilto*imfilto)

;  get orientation angle
xcu=total(imfiltm*rebin(reform(cos(angles(0:nfilt-1)*2),1,1,nfilt),$
  nax(0),nax(1),nfilt),3)
ycu=total(imfiltm*rebin(reform(sin(angles(0:nfilt-1)*2),1,1,nfilt),$
  nax(0),nax(1),nfilt),3)
xc=rebin(xcu,nax/binfac)
yc=rebin(ycu,nax/binfac)
orient=rebin(atan(yc,xc),nax,/sample)
mag1=sqrt(total(imfiltm*imfiltm,3))
mag2=rebin(sqrt(xc*xc+yc*yc),nax,/sample)




;stop


;  define color table
topval=1.0
botval=0.0
mask1=linrange(129,0,1)
mask2=replicate(1d,257)
mask3=reverse(mask1)
mask4=replicate(0d,257)
mask=[mask1(1:*),mask2(1:*),mask3(1:*),mask4(1:*)]*(topval-botval)+botval
index=indgen(256)*3
r=(byte(255*shift(mask,-256)))(index)
g=(byte(255*mask))(index)
b=(byte(255*shift(mask,256)))(index)

;  plot orientation vector, with luminence proportional to magnitude
if do_test then begin
  ;scim,orient,win=0+do_test,outim=outorient,/quiet
  ;scim,[mag1,mag2],win=4+do_test,/quiet
  magimage=rebin(mag2/(2*total(kernele(*,*,0))^2),[size(mag2,/dim),3])
  bsiz=(max(magimage)-min(magimage))/1000
;  hgram=float(hist_mld(magimage,bsiz,i=hix,/cum))/n_elements(magimage)
;  imscale=hix((where(hgram ge 0.97))(0))
imscale=1.
  scim,orient,outim=outorient,/nowin,/quiet
  image=byte([[[r(outorient)]],[[g(outorient)]],[[b(outorient)]]]*((magimage/imscale)<1))
;  scim,image,true=3,win=12+do_test,/quiet
endif else begin
  scim,orient,outim=outorient,/quiet,/nowin
  ;scim,[mag1,mag2]/[imprep,imprep],win=4+do_test,/quiet
  magimage=rebin(mag2/(total(kernele(*,*,0))^2*imprep),[size(mag1,/dim),3])
;  hgram=float(hist_mld(magimage,0.001,i=hix,/cum))/n_elements(magimage)
;  imscale=hix((where(hgram ge 0.97))(0))
imscale=1.
;  scim,orient,outim=outorient,/nowin,/quiet
  image=byte([[[r(outorient)]],[[g(outorient)]],[[b(outorient)]]]*((magimage/imscale)<1))
;  scim,image,true=3,win=12+do_test,/quiet
;  scim,image,true=3,/quiet
endelse

;stop

;return,orient

;  plot original image with pointers overlaid
;scim,imprep,win=8+do_test,/quiet
;scim,imprep,win=16+do_test,/quiet
naxarrow=nax/arrowbin
xgrid=(lindgen(naxarrow(0))*arrowbin+arrowbin/2)#replicate(1,naxarrow(1))
ygrid=replicate(1,naxarrow(0))#(lindgen(naxarrow(1))*arrowbin+arrowbin/2)
ngrid=n_elements(xgrid)
arrlen=magimage(xgrid,ygrid,replicate(0,ngrid))/imscale
;plot,[0,nax(0)],[0,nax(1)],xmar=[0,0],ymar=[0,0],xsty=5,ysty=5,/nodata,/noerase
;for i=0l,ngrid-1l do plots,xgrid(i)-(0.5*arrowbin)*sin(orient(xgrid(i),ygrid(i))/2)*arrlen(i)*[-1,1],ygrid(i)+(0.5*arrowbin)*cos(orient(xgrid(i),ygrid(i))/2)*arrlen(i)*[-1,1],col=0,thick=5
;for i=0l,ngrid-1l do plots,xgrid(i)-(0.5*arrowbin)*sin(orient(xgrid(i),ygrid(i))/2)*arrlen(i)*[-1,1],ygrid(i)+(0.5*arrowbin)*cos(orient(xgrid(i),ygrid(i))/2)*arrlen(i)*[-1,1]

outplotstr={orient:orient,outorient:outorient,image:image,nax:nax,ngrid:ngrid, $
	xarrow:xgrid-(0.5*arrowbin)*sin(orient(xgrid,ygrid)/2)*arrlen, $
	yarrow:ygrid+(0.5*arrowbin)*cos(orient(xgrid,ygrid)/2)*arrlen}

return,orient

end
