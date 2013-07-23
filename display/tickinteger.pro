  FUNCTION TickInteger, axis, index, number

     ; A special case.
     IF number EQ 0 THEN RETURN, '0' 

     intstr = strtrim(String(number, Format='(I)'),2)

     RETURN, intstr 

   END
