;Plots a circle at the given location, with the prescribed radius (for X-class), 
;to represent a flare in a movie
;
;POSITION - the plot position of the flare circle center
;FRAME - used like seed in a random number generator
;NFRAME - the number of frames where the flare is plotted
;STARTFRAME - the reference frame to the peak time frame (default=-1)
;COLOR - the color of the peak time circle (0-255)
;
;Run for multimple iterations when making a movie, EX:
;IDL> frame=0
;IDL> frame=plot_flare_circ(frame, position=position, nframe=5, color=255) ;frame=0
;IDL> frame=plot_flare_circ(frame, position=position, nframe=5, color=255) ;frame=1
;IDL> frame=plot_flare_circ(frame, position=position, nframe=5, color=255) ;frame=2
;IDL> frame=plot_flare_circ(frame, position=position, nframe=5, color=255) ;frame=3
;IDL> frame=plot_flare_circ(frame, position=position, nframe=5, color=255) ;frame=4

function plot_flare_circle, thisframe, position=position, radius=inradius, nframe=innframe, startframe=instartframe, color=incolor, _extra=_extra

if not keyword_set(inradius) then radius=10. else radius=inradius
if not keyword_set(innframe) then nframe=5 else nframe=innframe
if not keyword_set(instartframe) then startframe=-1 else startframe=instartframe
if not keyword_set(incolor) then color=255 else color=incolor

;framefrac=1-(thisframe-(startframe+1.)/float(nframe)
;colorf=color*framefrac

if thisframe eq startframe then colorf=color*0.5
if thisframe eq startframe+1 then colorf=color
if thisframe eq startframe+2 then colorf=color*0.6
if thisframe eq startframe+3 then colorf=color*0.3
if thisframe eq startframe+4 then colorf=color*0.15

draw_circle,position[0],position[1],radius,color=colorf, _extra=_extra














nextframe=thisframe+1.

return, nextframe

end