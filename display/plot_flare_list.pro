;Make a flare list plot with goes classes etc.

pro plot_flare_list, intim, inint, goes=goes, log=log,_extra=_extra

tim=anytim(intim)

if keyword_set(goes) then begin
	goes=1
	log=1
	int=goes_class2int(int)
endif else begin
	goes=0
	int=inint
endelse

if keyword_set(log) then log=1
if not keyword_set(log) then log=0

if goes then yran=[1d-7,1d-3]
utplot,tim-tim[0],int,tim[0],chars=2,/ylog,yran=yran,ps=-1,title='last events coverage',_extra=_extra

if goes then hline,[1d-6,1d-5,1d-4],color=!red,lines=2,_extra=_extra
if goes then xyouts,[0,0,0],[1d-6,1d-5,1d-4],['C','M','X'],/data,_extra=_extra


end