;Create a movie from a list of image files.
;
;Ex: 
;	IDL> ffmpeg_img2mov, '/Users/higgins/science/projects/stereo_sympathetic_flaring/11158/movie_304/*.png', '360sun_test_gaussweight', /avi
;GLOB = specify list of images
;OUTMOV = specify output movie file name
;	don't specify extension!
;SIZE = specify dimensions of movie
;
;Written: Paul A. Higgins - 20130725

pro ffmpeg_img2mov, inglob, inoutmov, size=size, mov=movext, avi=aviext, rate=inrate

;glob='./11158/minimovie/*.png'
if n_elements(inglob) ne 1 then glob='./11158/movie/*.png' else glob=inglob
if n_elements(inoutmov) ne 1 then outmov='./11158_disk_passage' else outmov=inoutmov

if keyword_set(movext) then ext='.mov'
if keyword_set(aviext) then ext='.avi'
if n_elements(ext) ne 1 then ext='.avi'

if n_elements(inrate) ne 1 then rate='20' else rate=strtrim(fix(inrate),2)
spawn,'ffmpeg -f image2 -r '+rate+' -pattern_type glob -i '''+glob+''' -b:v 20M '''+outmov+ext+'''',/sh



;stop

end
