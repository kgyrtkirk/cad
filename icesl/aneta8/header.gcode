G21 ;metric values
G90 ;absolute positioning
M82 ;set extruder to absolute mode
M107 ;start with the fan off

M104 S<TOOLTEMP> ; set temperature
M140 S<HBPTEMP> ; set bed temperature to be reached
G28  ; home all axes
G29  ; perform bed autoleveling?
M109 S<TOOLTEMP> ; wait for temperature to be reached
M190 S<HBPTEMP> ; wait for bed temperature to be reached


G92 E0 ;zero the extruded length
M117 Cleaning...;Put Cleaning message on screen
; G1 X100 Y0 F4000 ; move half way along the front edge
; G1 Z1 ; move nozzle close to bed
; G4 P10000 ; wait 10 seconds for nozzle length to stabilize
G1 F200 E10 ; extrude 10 mm of filament
G1 z15 F12000 E5 ; move 15 mm up, fast, while extruding 5mm
G92 E0 ; reset extruder

G1 F9000 ; what's the point of this?
M117 Printing (IceSL)...
