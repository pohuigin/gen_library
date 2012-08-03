
function vangle,v1,v2
;+
;NAME:
;   VANGLE
;PURPOSE:
;   Computes the angle between two 3D vectors
;CATEGORY:
;CALLING SEQUENCE:
;   angle = vangle(v1,v2)
;INPUTS:
;   v1 = first vector: [x,y,z]
;   v2 = second vector: [x,y,z]
;OPTIONAL INPUT PARAMETERS:
;KEYWORD PARAMETERS
;OUTPUTS:
;   angle = angle between the vectors (radians)
;COMMON BLOCKS:
;SIDE EFFECTS:
;RESTRICTIONS:
;PROCEDURE:
;MODIFICATION HISTORY:
;   Written by T. Metcalf 1-Nov-93
;-

   magv1 = sqrt(total(v1^2))
   magv2 = sqrt(total(v2^2))
   return, acos(total(v1*v2)/(magv1*magv2))

end