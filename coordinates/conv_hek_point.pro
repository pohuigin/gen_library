;Convert 'POINT(1.08190192552365 71.0988975761658)' to [1.08190192552365 71.0988975761658]

function conv_hek_point, pointstr


pointarr=(str_sep(pointstr,'('))[0]

pointarr=str_sep(pointarr,' ')
pointarr=strmid(pointarr,0,8)













return,pointarr

end