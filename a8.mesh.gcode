

G29 I999
M421 I0 J0 Z0.76
M421 I0 J1 Z0.67
M421 I0 J2 Z0.59
M421 I0 J3 Z0.49
M421 I0 J4 Z0.30
M421 I1 J0 Z0.43
M421 I1 J1 Z0.37
M421 I1 J2 Z0.27
M421 I1 J3 Z0.18
M421 I1 J4 Z-0.04
M421 I2 J0 Z0.03
M421 I2 J1 Z0.04
M421 I2 J2 Z-0.07
M421 I2 J3 Z-0.19
M421 I2 J4 Z-0.09
M421 I3 J0 Z-0.41
M421 I3 J1 Z-0.34
M421 I3 J2 Z-0.48
M421 I3 J3 Z-0.62
M421 I3 J4 Z-0.86
M421 I4 J0 Z-0.95
M421 I4 J1 Z-0.87
M421 I4 J2 Z-1.02
M421 I4 J3 Z-1.22
M421 I4 J4 Z-1.40

G29 T         ; View the Z compensation values.
G29 S1        ; Save UBL mesh points to EEPROM.
G29 F 10.0    ; Set Fade Height for correction at 10.0 mm.
G29 A         ; Activate the UBL System.

M851 Z-0.6
M500          ; Save current setup. WARNING - UBL will be active at power up, before any G28.


