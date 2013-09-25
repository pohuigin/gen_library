;A map oriented wrapper for BUFFER_2D.pro

function map_buffer_2d, map, _extra=_extra



data=map.data

newdata=buffer_2d(data,_extra=_extra)

newmap=map

add_prop,newmap,data=newdata,/replace








return,newmap

end
