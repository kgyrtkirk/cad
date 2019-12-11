G28             ; Home XYZ.
G29 P1          ; Do automated probing of the bed.
; G29 P2 B T      ; Manual probing of locations USUALLY NOT NEEDED!!!!
; G29 P3 T        ; Repeat until all mesh points are filled in.

G29 T           ; View the Z compensation values.
G29 S1          ; Save UBL mesh points to EEPROM.
G29 F 10.0      ; Set Fade Height for correction at 10.0 mm.
G29 A           ; Activate the UBL System.
M500            ; Save current setup. WARNING: UBL will be active at power up, before any `G28`.

G29 S-1		; output calib to terminal
