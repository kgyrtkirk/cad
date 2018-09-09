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

module stepdown_mount() {
    W=1.6;
    S=60.4;
    D2=3.2;
    
    difference() {
        cube([4*HOLE_D+W,S+2*D2+2*W,3*W],center=true);
        
        M=200;
        translate([W/2,-M/2,0])
        cube([M,M,M]);
        
        translate([-M-W/2,-M/2,-M])
        cube([M,M,M]);
        
        symY([W/2+HOLE_D,(6+HOLE_D)/2,0]) {
            plexiHole();
        }
        
        symY([-W/2-HOLE_D,(S+D2)/2,0]) {
            $fn=16;cylinder(d=D2,center=true,h=32);
        }
    }
}

module board_mount() {
    W=1.6;
    S=60.4;
    D2=3.2;
    H1=4*W;
    H2=5*W;
    
    L=50;
    B_W=53;
    
    difference() {
        translate([0,0,H2/2])
        cube([L,B_W+2*W,H2],center=true);
        
        translate([0,0,H2/2+H1])
        cube([L+1,B_W,H2],center=true);
        
        translate([0,0,H2/2+W])
        cube([L+1,B_W-2*1.5,H2],center=true);

        translate([L/2,-B_W/2,0]) {
            // top left corner
            Y1=20+HOLE_D/2;
            Y2=Y1+22+HOLE_D;
            XX2=34+HOLE_D;
            
            X1=(L-XX2)/2;
            X2=X1+XX2;
            translate([-X1,Y1,0])    plexiHole();
            translate([-X1,Y2,0])    plexiHole();
            translate([-X2,Y2,0])    plexiHole();
       //     plexiHole();
            
        }
    }
}



mode="servo_mount";
if(mode=="servo_mount"){
    servo_mount();
}

mode="stepdown_mount";
if(mode=="stepdown_mount"){
    stepdown_mount();
}

mode="board_mount";
if(mode=="board_mount"){
    board_mount();
}