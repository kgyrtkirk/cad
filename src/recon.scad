include <syms.scad>
//include <9g_servo.scad>

HOLE_D=4;


module plexiHole() {
    $fn=16;
    cylinder(d=HOLE_D,h=16,center=true);
}

module servo_mount() {
    SERVO_W=12.5;
    SERVO_H=15.5;
    W=1.6;
    L=40;
    
    $fn=16;
    
    difference() {
        translate([L/2-2.5*HOLE_D,0,(SERVO_H+W)/2])
        cube([L,SERVO_W+2*W,SERVO_H+W],center=true);
    
        translate([L/2,0,SERVO_H/2+W])
        cube([L,SERVO_W+.1,SERVO_H+.1],center=true);
    
        translate([-L/2-W,0,(SERVO_H-W)/2+W])
        cube([L,L,SERVO_H-W],center=true);
    
        translate([-1.3-1.1,0,SERVO_H+W])
        cylinder(d=2.2,h=SERVO_H*2,center=true);
    
        
        translate([L/2,0,SERVO_H])
    rotate(40,[0,1,0])
        cube([2*L,L,L/2],center=true);

        translate([-HOLE_D-W-L/2,0,L/2+W])
        cube([L,L,L],center=true);
    
    
        translate([-1.5*HOLE_D,0,0])
        symY([0,(6+HOLE_D)/2,0]) {
            plexiHole();
        }
    }
    
    
//    translate([0,0,1/2])
  //  9g_motor();
}


mode="servo_mount";
if(mode=="servo_mount"){
    servo_mount();
}