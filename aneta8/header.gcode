;Sliced at: {day} {date} {time}
G21        ;metric values
G90        ;absolute positioning
M82        ;set extruder to absolute mode
M107       ;start with the fan off
G28 ; Auto Home All AXIS
G29 ; Auto Bed Levelling


G1 Z15.0 F{travel_speed} ;move the platform down 15mm
G92 E0 ;zero the extruded length
M117 Cleaning...;Put Cleaning message on screen
G1 X100 Y0 F4000 ; move half way along the front edge
G1 Z.3 ; move nozzle close to bed
; M109 S200 ; heat nozzle to 200 degC and wait until reached
G4 P10000 ; wait 10 seconds for nozzle length to stabilize
G1 E10 ; extrude 10 mm of filament
G1 Z15 F12000 E5 ; move 15 mm up, fast, while extruding 5mm
G1 Z30 F12000 ; move 15 mm up, fast, while extruding 5mm
G1 X200 ;
G1 X0
G92 E0 ; reset extruder
M117 Printing...;Put printing message on LCD screen
