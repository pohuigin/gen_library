;Convert where indices to x,y coordinates in a 2d image
;input the output of the where statement, and the x-size of the image 

pro w2xy, win, szx, xout, yout

xout=long(round(win)) mod long(round(szx))

yout=long(round(win))/long(round(szx))

end