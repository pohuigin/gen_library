;Calculate the distance along the line connecting two rectilinear points.

function distcal,x1,y1,x2,y2

dist=sqrt((x2-x1)^2+(y2-y1)^2)

return,dist
end
