;plot a magnetogram including image scaling and a color bar
;UNITS = the units to show on the colorbar title (e.g., '[G]')
pro plot_mag, image, _extra=_extra, units=units

plot_image,magscl(image, _extra=_extra),_extra=_extra,/iso
color_bar,magscl(image, _extra=_extra),0.96,0.98,0.1,0.9, _extra=_extra,/left,/norm,title=units

end