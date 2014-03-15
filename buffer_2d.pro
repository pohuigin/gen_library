;Append a buffer to make input image a certain size
;VALUE - specify the value of the buffer
;XS - desired new X-size for the image
;YS - '' Y-size ''
;if only XS or YS is input then only that dimension will be buffered

function buffer_2d,image,value=invalue,xs=inxs,ys=inys

imgsz=size(image,/dim)

if n_elements(inxs) ne 1 then xs=imgsz[0] else xs=inxs > imgsz[0]

if n_elements(inys) ne 1 then ys=imgsz[1] else ys=inys > imgsz[1]

if n_elements(invalue) ne 1 then value=0 else value=invalue

newimage=fltarr(xs,ys)
newimage[*,*]=value

x0=(xs-imgsz[0])/2.
x1=x0+imgsz[0]
y0=(ys-imgsz[1])/2.
y1=y0+imgsz[1]
newimage[x0:x1-1,y0:y1-1]=image












return,newimage

end
