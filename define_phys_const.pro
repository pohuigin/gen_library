;*********************************************
;       Define Physical Constants	         *
;*********************************************
                       
DEFSYSV, '!DDTOR',             !DPI/180.0D0, 1     ;Double precision degrees to radians
DEFSYSV, '!DRADEG',            180.0D0/!DPI, 1     ;Double precision radians to degrees

DEFSYSV, '!c',			      299792458.0D0, 1     ;Speed of light in vacuum (m s^-1)
DEFSYSV, '!Planck',          6.62606876D-34, 1     ;Planck constant (J s)
DEFSYSV, '!Universal_gas',      8314.4720D0, 1     ;Universal gas constant (J K^-1 kmol^-1)
DEFSYSV, '!Stefan_Boltzmann',  5.670400D-08, 1     ;Stefan-Boltzman constant (W m^-2 K^-4)
DEFSYSV, '!Avogadro',        6.02214199D+26, 1     ;Avogadro's number (molecules kmol^-1)
DEFSYSV, '!Gconst',               6.673D-11, 1     ;Gravitational constant (J K^-1)
DEFSYSV, '!kB',        		  1.3806503D-23, 1     ;Boltzmann's constant (N m^2 kg^-2)

DEFSYSV, '!a0',                 6371220.0D0, 1     ;Mean radius of the Earth (m)
DEFSYSV, '!g',                       9.81D0, 1     ;Acceleration of gravity at sea level (m s^-2)
DEFSYSV, '!S0',                    1367.0D0, 1     ;Solar constant (W m^-2)
DEFSYSV, '!tauDSolar',                86400, 1     ;Length of mean solar day (s)
DEFSYSV, '!tauDSidereal',         86164.0D0, 1     ;Length of sidereal day (s)
DEFSYSV, '!tauYSolar',         31556925.0D0, 1     ;Length of mean solar year (s)
DEFSYSV, '!Omega', 2.0D0*!DPI/!tauDSidereal, 1     ;Rotation rate of the Earth (rad s^-1)
DEFSYSV, '!lightyear', 		  9.4605284D+15, 1     ;Light year in meters
DEFSYSV, '!parsec',		   	 3.08567758D+16, 1     ;Parsec in meters

DEFSYSV, '!Rair',                     287.0, 1     ;Gas constant for dry air (J K^-1 kmol^-1)
DEFSYSV, '!Cp',                      1004.0, 1     ;Specific heat of dry air at constant pressure (J K^-1 kg^-1)
DEFSYSV, '!Cv',                       717.0, 1     ;Specific heat of dry air at constant volume (J K^-1 kg^-1)

DEFSYSV, '!Lv',                      2.5E06, 1     ;Latent heat of vaporization (J kg^-1)
DEFSYSV, '!Lf',                     3.34E05, 1     ;Latent heat of fusion (J kg^-1)
DEFSYSV, '!Cw',                      4218.0, 1     ;Specific heat of liquid water at 0 C (J kg^-1)

DEFSYSV, '!Msun',               1.98892D+30, 1     ;Solar mass (kg)
DEFSYSV, '!Rsun',				   6.955D+8, 1     ;Solar radius (m)

DEFSYSV, '!eps_0',		 8.854187817620D-12, 1	   ;Electric permittivity of free space (F m^-1)
DEFSYSV, '!mu_0',           1.2566370614D-6, 1	   ;Magnetic permeability of free space (N A^-2)

DEFSYSV, '!e_mass',        	 9.10938291D-31, 1	   ;Electron mass (kg)
DEFSYSV, '!e_q', 	        1.602176565D-19, 1     ;Electron charge (C)

DEFSYSV, '!p_mass',		    1.672621777D-27, 1	   ;Proton mass (kg)
