;---------------------------------------------------------------------------->
;+
; Project     : Aurora Research (Summer 2008)
;
; Name        : PEAKSELECT
;
; Purpose     : Find prominant peaks in a well behaved function array.
;
; Category    : Fourier Analysis
;
; Syntax      : IDL> peakselect, wpeakarr, peakarr, npeaks=10, $
;               IDL> power=yarray, secarr = xarray, range = [x1,x2]
;
; Input       : POWER     - The Y-Axis array. (eg. the power array
;                           in a Fourier transform.)
;
;               SECARR    - The X-Axis array. (eg. the frequency array in
;                           a Fourier transform.)
;
; Output      : WPEAKARR  - The indices of the peaks found. Will have
;                           a maximum of NPEAKS elements.
;
;               PEAKARR   - The X values of the peaks found. Will have
;                           a maximum of NPEAKS elements.
;
; Keywords    : RANGE     - A two element array. The X range over which to 
;                           find peaks. 
;
;               NPEAKS    - A scalar. The number of peaks you would like 
;                           to find. Default is 10.
;
;               SENSITIVE - Set a threshold for a minimum peak
;                           height. The threshold is the mean of the
;                           POWER array multiplied by scalar SENSITIVE.
;
; Example     : IDL> peakselect, wpeakarr, peakarr, npeaks=1, $
;               IDL> power=yarray, secarr = xx, range = [x1,x2]
;
; History     : Written 1-Jul-2008, Paul Higgins, (SSL/UCB)
;
; Contact     : phiggins@ssl.berkeley.edu
;-
;---------------------------------------------------------------------------->

pro peakselect, wpeakarr, peakarr, npeaks = npeaks, power = power, $
                secarr = secarr, range = range, sensitive = sensitive, peakrad = peakrad, buffrad = buffrad

if not keyword_set(npeaks) then npeaks = 10
if not keyword_set(sensitive) then sensitive = 1.
if not keyword_set(range) then range = [secarr[4], secarr[n_elements(secarr)-4]]
if not keyword_set(buffrad) then frad = 3 else frad = buffrad
if not keyword_set(peakrad) then pkrad = 3 else pkrad = peakrad

filler = 1d40
npower = n_elements(power)
dpower = fltarr(npower)+filler
maxit = npower

;CREATE DERIVATIVE ARRAY
for i = 1, npower-1 do begin
  dpower[i] = abs(power[i]-power[i-1])
endfor

if keyword_set(range) then begin
  wrng0 = (where(abs(secarr-range[0]) eq min(abs(secarr-range[0]))))[0]
  wrng1 = (where(abs(secarr-range[1]) eq min(abs(secarr-range[1]))))[0]
  wrng = [wrng0, wrng1]

  dpower[0:wrng[0]] = filler
  dpower[wrng[1]:*] = filler
endif

dpower0 = dpower

meanthresh = sensitive*mean(power[wrng[0]:wrng[1]])

;FIND ALL ZERO DERIVATIVES
minarr = fltarr(npeaks)
i = 0
n = 0
while i le npeaks-1 do begin
  thismin = (where(dpower eq min(dpower)))[0]
  if min(dpower) eq filler then break
;CHECK FOR MAXIMUM
  if power[thismin+pkrad] le power[thismin] and $
    power[thismin-pkrad] le power[thismin] then begin

  if power[thismin] gt meanthresh then begin
    minarr[i] = thismin
    i = i+1
  endif
  endif

;ZERO FOUND MAX
  if thismin lt frad then dpower[0:thismin] = filler else $
    dpower[thismin-frad:thismin] = filler
  if thismin gt npower-(frad+1) then dpower[thismin:*] = filler else $
    dpower[thismin:thismin+frad] = filler
  n = n+1
  if n gt maxit then begin print,[' ', 'NO MORE PEAKS! ('+strcompress(maxit, /remo)+' runs)', ' '] & break & endif

;!p.multi = 0
;plot, secarr, dpower, xr = [0, .002], yr = [0, 1d30]
;oplot, secarr, power, lines = 2
;stop
endwhile

wmin = where(minarr ne 0)
if wmin[0] ne -1 then minarr = minarr[wmin] else minarr = ''

wpeakarr = minarr
if wmin[0] ne -1 then peakarr = secarr[minarr] else peakarr = ''

;!p.multi = [0, 1, 2]
;plot, secarr, power, xr = range
;oplot, secarr[minarr], fltarr(10)+mean(power), ps = 4
;plot, secarr, dpower0, xr = range
;print, peakarr
;stop

wsort = sort(power[wpeakarr])

;stop

end
