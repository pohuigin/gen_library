;+
; ROUTINE:    rothel2xy
;
; PURPOSE:    Rotate heliographic coords valid at a given time
;             to a later time and return the heliographic and
;             heliocentric coordinates. 
;             Can also be used simply to convert heliographic to 
;             heliocentric coordinates
;
; USEAGE:     rothel2xy, hel_start, t_start, t_end, hel_end, xy_start, $
;                        xy_end, /print
;
; INPUT:      hel_start = the heliographic coords   
;             t_start = the time the coordinates are valid 
;                       at in 'dd-mon-yyyy hh:mm' format
;             t_end = the time to rotate the coords to in 'dd-mon-yyyy hh:mm' format
;
; OUTPUT:     hel_end = the end heliographic coordinate
;             xy_start = the start (solar_x, solar_y) coords  
;             xy_end = the end (solar_x, solar_y) coords
;
; KEYWORDS    print = prints the coordinates to the standard output
;
; EXAMPLE:    rothel2xy, 'N12W43', '20-oct-2000 13:40', '20-oct-2000 18:00', /print
;             
;             will rotate 'N12W43' valid at '20-oct-2000 13:40' to
;             '20-oct-2000 18:00' and print the heliographic and
;             heliocentric coords.
;              
;             rothel2xy,'N12W43', /print
;           
;             will simply convert 'N12W43' to heliocentric coordinates
;             and print the result
;	      
;
; AUTHOR:     20-oct-2000, P. T. Gallagher (ptg@bbso.njit.edu)
;
;-

pro rothel2xy, hel_start, t_start, t_end, hel_end, xy_start, xy_end, print = print

; If hel_start is only entered, then set get the current time
; and set to t_start and t_end

  if ( n_elements( t_end ) eq 0 ) then begin
    get_utc, current_time, /vms
    t_start = current_time
    t_end   = current_time
  endif
  
; Make sure the dates are in vms format

  t_start = anytim( t_start, /vms )
  t_end   = anytim( t_end,   /vms )
  
; Convert heliographic to (Solar_X/",Solar_Y/")

  xy_start = hel2arcmin( strmid( hel_start, 0, 3 ), $
                         strmid( hel_start, 3, 3 ), $
			 date = t_start) * 60.

; Rotate coords to t_end

  xy_end = rot_xy( xy_start( 0 ), xy_start( 1 ), $
                   tstart = t_start, tend = t_end )  
  
; Convert xy_end to heliographic

  hel_end = arcmin2hel( xy_end( 0 ) / 60., xy_end( 1 ) / 60., date = t_end )     

; Print!

  t_start  = arr2str( t_start, /trim )
  xy_start = strcompress( string( round( xy_start ) ), /re )
  t_end    = arr2str( t_end, /trim )
  hel_end  = strcompress( string( round( hel_end ) ), /re )
  xy_end   = reform( strcompress( string( round( xy_end ) ), /re ) )
      
  if ( strmid( hel_end( 0), 0, 1 ) eq '-' ) then $
       hel_end( 0 ) = 'S' + strmid( hel_end( 0 ), 1, 2 ) else $
       hel_end( 0 ) = 'N' + hel_end( 0 )
  if ( strmid( hel_end(1 ), 0, 1 ) eq '-' ) then $
       hel_end( 1 ) = 'E' + strmid( hel_end( 1 ), 1, 2 ) else $
       hel_end( 1 ) = 'W' + hel_end( 1 )
  
  if ( keyword_set( print ) ) then begin
    print, ' ' 
    print, 'At ' + t_start + ': ' + hel_start + ' = ' + '(' + xy_start(0) + $
           '"' + ', ' + xy_start( 1 ) + '")'
    if ( n_elements( current_time ) eq 0 ) then begin
      print, 'At ' + t_end + ': ' + hel_end(0) + hel_end(1)+ ' = ' + '(' + xy_end(0) +$
             '"' + ', ' + xy_end( 1 ) + '")'
    endif
    print, ' ' 
  endif
  
; Bad programming to deal with rothel2xy, 'N12W12', xy_end
 
  if ( n_elements( current_time ) ne 0 ) then t_start = xy_end

end
