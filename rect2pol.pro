;+
;       NAME: rect2pol
;
;       PURPOSE:  Convert rectangular coordinates to polar coordinates
;
;       METHOD:  
;
;       CALLING SEQUENCE: polar = rect2pol(x,y)
;
;       PARAMETERS:	x,y	input rectangular cordinates
;			polar	[radius, theta] 
;				theta is in +/- radians from x-axis		
;
;       HISTORY: Copied from IDL manual, AMcA, August 1994.
;-
FUNCTION rect2pol,x,y

return, [sqrt(x*x + y*y),atan(y,x)]

end
