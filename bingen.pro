;generate an array using min, max and bin input

function bingen, bin=bin, min=min, max=max

bin=float(bin)
min=float(min)
max=float(max)

n=ceil((max-min+bin)/bin)

x=findgen(n)*bin+min











return,x

end