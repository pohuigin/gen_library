;WHOOPS THIS ALREADY EXISTS (randomu(poisson=mean))
;Unfinished!
;generate a random numbers from a poisson distribution
;adapted from numerical recipes 7.4 (pg. 207)

function rand_poisson,nrand,mean=inmean

if n_elements(inmean) eq 1 then pmean=inmean else message,'Specify mean=poisson mean'

randarr=randomu(nrand)

g=exp(-pmean)

for i=0,nrand-1 do begin

	thisrand=randarr[i]

	if thisrand lt 12 then begin

		em=-1
		t=1

		em=em+1

endfor








end