;Pull out the uniq elements from an array

function uniqpx,inarray

array=inarray

sarray=sort(array)

arrays=array[sarray]

uarray=uniq(arrays)

arrayu=arrays[uarray]

return,arrayu

end