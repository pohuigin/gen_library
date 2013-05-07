;plot a magnetogram including image scaling and a color bar
;UNITS = the units to show on the colorbar title (e.g., '[G]')
pro plot_mag, inimage, _extra=_extra, units=units, colorbar=colorbar

image=inimage

if data_type(image) eq 8 then begin
	image.data=magscl(image.data, _extra=_extra)
	plot_map,image,_extra=_extra,/iso
endif else plot_image,magscl(image, _extra=_extra),_extra=_extra,/iso

if keyword_set(colorbar) then color_bar,magscl(image, _extra=_extra),0.96,0.98,0.1,0.9, _extra=_extra,/left,/norm,title=units

end