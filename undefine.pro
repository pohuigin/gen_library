;http://www.idlcoyote.com/tips/variable_undefine.html

PRO UNDEFINE, varname  
   tempvar = SIZE(TEMPORARY(varname))
   END