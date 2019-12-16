// notes:
//	* all plexi holes: fill up the remaining part of the 4mm hole somehow; there is too much play
//	* servo_mount: add hook into plexi to prevent pitch
//	* arduino mount: add more holes for board - it can came out...
//	* stepdown: remove overhang; probably change orientation
//


include <syms.scad>
//include <9g_servo.scad>

HOLE_D=4;


module plexiHole() {
    //HOLE_D in plexi; but use M3
    $fn=16;
    cylinder(d=3.2,h=16,center=true);
}
module plexiHole0() {
    //HOLE_D in plexi; but use M3
    $fn=16;
    cylinder(d=4,h=16,center=true);
}

module servo_mount() {
    SERVO_W=12.5;
    SERVO_H=15.5;
    SERVO_L=23+1;
    SERVO_HOLE_X=(27.4-SERVO_L)/2;
    W=1.6;
    L=39;
    PW=3;
    
    $fn=16;
    
    difference() {
        translate([L/2-2.5*HOLE_D,0,(SERVO_H+W)/2-(PW+W)/2])
        cube([L,SERVO_W+2*W,SERVO_H+W+PW+W],center=true);
    
        translate([SERVO_L/2,0,SERVO_H/2+W])
        cube([SERVO_L,SERVO_W+.1,SERVO_H+.1],center=true);
        
        translate([L/2,0,(SERVO_H-W)/2+W])
        cube([L,SERVO_W+.1,SERVO_H-W],center=true);
    
        translate([-L/2-W,0,(SERVO_H-W)/2+W])
        cube([L,L,SERVO_H-W],center=true);
    
        translate([-SERVO_HOLE_X,0,SERVO_H+W])
        cylinder(d=1.8,h=SERVO_H*2,center=true);
        translate([SERVO_L+SERVO_HOLE_X,0,SERVO_H+W])
        cylinder(d=1.8,h=SERVO_H*2,center=true);
    
        
//        translate([L/2,0,SERVO_H])
  //  rotate(40,[0,1,0])
    //    cube([2*L,L,L/2],center=true);

        translate([-HOLE_D-W-L/2,0,L/2+W])
        cube([L,L,L],center=true);
    
    
    H_X=-1.5*HOLE_D;
        translate([H_X,0,0])
        symY([0,(6+HOLE_D)/2,0]) {
            plexiHole();
        }
        
        difference() {
            union() {
            translate([0,0,-PW/2])
            cube([100,100,PW],center=true);
            translate([-3,0,-10])
            cube(20,center=true);
            }
            translate([H_X+HOLE_D/2+2.7+4+9.7+30/2+1,0,0])
            cylinder($fn=32,d=30,h=100,center=true);
            
      //      translate([H_X,0,0])
    //        symY([0,(6+HOLE_D)/2,0]) {
  //              plexiHole0();
//            }

        }
        
        translate([H_X+HOLE_D/2+2.7+4+9.7+30/2+1+W,0,0])
        cylinder($fn=32,d=30-W,h=10,center=true);
        
        
    }
    
    
//    translate([0,0,1/2])
    9g_motor();
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
    H1=5*W;
    H2=6*W;
    
    L=60;
    B_W=53;
    
    
    Y1=20+HOLE_D/2;
    Y2=Y1+22+HOLE_D;
    XX2=34+HOLE_D;

    X1=(L-XX2)/2;
    X2=X1+XX2;

    
    difference() {
        translate([0,0,H2/2])
        cube([L,B_W+2*W,H2],center=true);
        
        translate([0,0,H2/2+H1])
        cube([L+1,B_W,H2],center=true);
        
        translate([0,0,H2/2+W])
        cube([L+1,B_W-2*1.5,H2],center=true);

        translate([L/2,-B_W/2,0]) {
            // top left corner
            translate([-X1,Y1,0])    plexiHole();
            translate([-X1,Y2,0])    plexiHole();
            translate([-X2,Y2,0])    plexiHole();
       //     plexiHole();
            
        }
    }
        translate([+50/2,-B_W/2,0]) {
            // top left corner
            DF=3.2;
            C1=[0,5.8+DF/2,0];
            C2=[0,33.7+DF/2,0];
            C3=[-50.8,33.7+15.2+DF/2,0];
            C4=[-50.8-1.3,5.8-5.1+DF/2,0];
            for(x=[C1,C2,C3,C4]) 
            translate(x) {
                $fn=16;
                difference() {
                cylinder(d=6,h=H1);
                cylinder(d=2.6,h=H1*2);
                }
            }
        }
    
}



mode="stepdown_mount";
mode="board_mount";
mode="servo_mount";
if(mode=="servo_mount"){
    servo_mount();
}

if(mode=="stepdown_mount"){
    stepdown_mount();
}

if(mode=="board_mount"){
    board_mount();
}
