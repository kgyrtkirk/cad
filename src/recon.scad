include <syms.scad>
include <9g_servo.scad>

HOLE_D=4;


module plexiHole() {
    $fn=16;
    cylinder(d=HOLE_D,h=16,center=true);
}

module servo_mount() {
    SERVO_W=12.5;
    SERVO_H=15.5;
    W=1.6;
    L=30;
    
    $fn=16;
    
    difference() {
        union() {
            translate([L/2-2*HOLE_D,0,-W/2])
            cube([L,SERVO_W+3*W,W],center=true);
            
            hull() {
                hull() {
                    symY([0,(SERVO_W+W)/2,SERVO_H-W/2])
                    cube(W,center=true);
                }
            }
        }
    
        translate([-HOLE_D,0,0])
        symY([0,(6+HOLE_D)/2,0]) {
            plexiHole();
        }
    }
    translate([0,0,1/2])
    9g_motor();
}


mode="servo_mount";
if(mode=="servo_mount"){
    servo_mount();
}