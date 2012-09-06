; Project     : SOLAR MONITOR
;
; Name        : WINDOW_CAPTURE
;
; Purpose     : Capture the graphic device display and write the image to the specified file type.
;
; Category    : Funny Business
;
; Syntax      : IDL> window_capture,filename='image',/png
;
; Keywords    : FILENAME: The desired filename to be written.
;
;               JPEG: Writes a 'Joint Photographic Experts Group' file.
;
;               PNG: Writes a 'Portable Network Graphics' file.
;
;               PS: Writes a 'Post Script' file.
;
;				PDF: Use in combination with one of the other keywords.
;
; Example     : IDL> plot,findgen(500,500)
;               IDL> window_capture,filename='image',/png
;
; History     : Written 18-Jul-2007, Paul A. Higgins, (ARG/TCD)
;
; Contact     : pohuigin@gmail.com
;-->
;----------------------------------------------------------------------------->

;----------------------------------------------->
;input: INFILE - an image file to be converted to PDF
;output: OUTFILE - converted PDF file
pro conv2pdf, infile, outfile

outfile=strjoin((str_sep(infile,'.'))[0:n_elements(str_sep(infile,'.'))-2],'.')+'.pdf'
spawn,'convert '+infile+' '+outfile


end

;----------------------------------------------->

pro hardimage24, landscape=landsc, $
        xsize=xinch, ysize=yinch, xoffset=xoffset, yoffset=yoffset, filename=filename
;+
;NAME:
;HARDIMAGE24 -- copy window to ps for 24 bit color

;PURPOSE:
;	THIS IS THE 24 BIT VERSION.
;	This procedure makes a postscript file of the image on the
;current window and gives EXACTLY what you see on your workstation
;window.
;
;CALLING SEQUENCE:
;	HARDIMAGE24
;
;REQUIRED INPUTS:
;	none
;
;KEYWORDS:
;
;		FILENAME: The postscript file name you wish to save your image as.
;
;       LANDSCAPE: The default is to produce a 'portrait' plot. If
;you set landscape, it will produce a 'landscape' plot.
;
;       XSIZE: The width of the printed plot in the X direction. See
;note under YSIZE. The default is 7 inch in portrait, 9.5 inch in landscape.
;
;       YSIZE: The width of the printed plotin the Y direction. The
;default is 9.5 inch in portrait, 7.0 in landscape.
;NOTE: IN ALL CASES THE ASPECT RATIO OF THE PLOT WILL BE PRESERVED.
;Thus, either XSIZE or YSIZE will determine the maximum size of the plot,
;depending on which is smaller.
;
;       XOFFSET: The x offset. See code for defaults.
;       YOFFSET: The y offset. See code for defaults. Be careful if
;you specify this...you need to know how it is defined!
;
;OUTPUTS:
;	The postscript file, whose name is prompted for.

;EXAMPLE:
;	First create the 24-bit color image in the window and make it look
;EXACTLY as you want it to look on paper.  Then type HARDIMAGE24.  Then
;check the postscript file using the UNIX command xv.  If it looks OK,
;then make the hard copy with the UNIX command lp. 

;HISTORY:
;	Written by Carl Heiles. Origin is hardimage. 14 Oct 1999
;	modified and documented 8jan 00
;	modified by Paul Higgins (UCB/TCD) 17 Jul 2007
;		-Changed the 'Prompt User for Filename' to an input. 
;-

if not keyword_set(filename) then filename='hardimage.eps'
filenm=filename

common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
if (n_elements(r_curr) ne 0) then begin
rorig = r_orig
gorig = g_orig
borig = b_orig
rcurr = r_curr
gcurr = g_curr
bcurr = b_curr
endif

loadct,0,/silent

;FIRST TAKE CARE OF DEFINING INPUT PARAMETERS...
if not keyword_set(landsc) then landsc=0

if (landsc eq 0) then begin
if not keyword_set(xinch) then xinch=7.0
if not keyword_set(yinch) then yinch=9.5
endif else begin
if not keyword_set(xinch) then xinch=9.5
if not keyword_set(yinch) then yinch=7.0
endelse

if not keyword_set(xoffset) then begin
if (landsc eq 0) then begin
        xoffset = 0.5*(8.5 - xinch)
endif else begin
        xoffset = 0.5*(8.5 - yinch)
endelse
endif  

if not keyword_set(yoffset) then begin
if (landsc eq 0) then begin
        yoffset = 0.5*(11.0 - yinch)
endif else begin
        yoffset = 0.5*(11.0 - xinch) + xinch
endelse
endif    

;READ THE IMAGE FROM THE WINDOW.
imgtestred = tvrd(channel=1)
imgtestgreen = tvrd(channel=2)
imgtestblue = tvrd(channel=3)

;SCALE THE IMAGE ACCORDING TO THE CURRENT COLOR TABLE.
redimg = imgtestred
grnimg = imgtestgreen
bluimg = imgtestblue

;PROMPT FOR THE OUTPUT FILE NAME
print, 'Filename will be... ', filenm

;SET TO POSTSCRIPT, COPY THE IMAGE ONTO THE PS FILE...
set_plot, 'ps'  ;, /copy
device, filename=filenm, bits=8, landscape=landsc, /inch, /color, $
        xsize=xinch, xoff=xoffset, $
        ysize=yinch, yoff=yoffset

tv, [[[redimg]], [[grnimg]], [[bluimg]]], true=3 ;$

;CLOSE THE PS FILE AND GET BACK TO WINDOWS...
device, /close

if (n_elements(r_curr) ne 0) then begin
r_orig = rorig
g_orig = gorig
b_orig = borig
r_curr = rcurr
g_curr = gcurr
b_curr = bcurr
endif

set_plot, 'x'
return
end

;----------------------------------------------->

pro window_capture, filename=filename, gif=gif, ps=ps, png=png, jpeg=jpeg, pdf=pdf

if not keyword_Set(gif) and $
	not keyword_Set(ps) and $
	not keyword_Set(png) and $
	not keyword_Set(jpeg) then png=1

if not keyword_Set(filename) then filename='windowcap'

name=strsplit(filename,'.',/extract)
name=name[0]

test=TVRD()

imgsz=size(test)

if imgsz[1] lt 1 then begin
	print,' '
	print,'There is no window to capture.'
	print,' '
endif

imgcapture=bytarr(3,imgsz[1],imgsz[2])
imgcapture[0,*,*]=TVRD(channel=1)
;rr = byte(imgcapture[0,*,*])
imgcapture[1,*,*]=TVRD(channel=2)
;gg = byte(imgcapture[1,*,*])
imgcapture[2,*,*]=TVRD(channel=3)
;bb = byte(imgcapture[2,*,*])
imgcapture=byte(imgcapture)
tvlct, rr, gg, bb, /get

if keyword_set(ps) then begin
	hardimage24,filename=name+'.ps'
	if keyword_set(pdf) then conv2pdf, name+'.ps'
endif

if keyword_set(gif) then begin
	WRITE_GIF, name+'.gif', bytscl(total(imgcapture, 1)), rr, gg, bb
	if keyword_set(pdf) then conv2pdf, name+'.gif'
endif

if keyword_set(png) then begin
	WRITE_PNG, name+'.png', imgcapture;, rr, gg, bb
	if keyword_set(pdf) then conv2pdf, name+'.png'
endif

if keyword_set(jpeg) then begin
	WRITE_jpeg, name+'.jpg', imgcapture, true=1, quality=100
	if keyword_set(pdf) then conv2pdf, name+'.jpg'
endif

return

end

;----------------------------------------------->
