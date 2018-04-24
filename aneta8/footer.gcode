M106 S255                    ;fan on
M140 S0                      ;heated bed heater off (if you have it)
G91                          ;relative positioning
G1 E-1 F300                  ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z+0.5 E-8 F{travel_speed} ;move Z up a bit and retract filament even more
G28 X0 Y0                              ;move X/Y to min endstops, so the head is out of the way
G90                         ; absolute positioning
M84                         ; steppers off
G0 Y200 F9000               ; send tray forward

M109 R150                   ; wait extruder 150C
M107                        ; turn off fan
M104 S0                     ; extruder heater off
