
use <syms.scad>
use <tt-motor.scad>

W=4;                  // wall
STOMACH=[55+2*3,120,45];    // space available inside

WHEEL_DIST_Y=115;
    MOTOR_Z_OFF=-STOMACH[2]/2+ttMotorH()/2;

// 2x18650 ~ 6.4 ~ 7.2 ~ 8.4
module battery_holder(mount_holes_only=false) {
    H_DIST=19;//(22.6+16.2)/2;
    W=2;
    DIM=[41,77,20];
    %translate([0,0,DIM[2]/2])
//    color([1,0,0])
    difference() {
        cube(DIM,center=true);
        translate([0,0,W])
        cube(DIM-[W,W,0],center=true);
    }
    $fn=16;
    symX([H_DIST/2,0,0])
    cylinder(d=3,h=20,center=true);
}
// with W wall in XYZ in mind
function    chassisPos(p) = 
    [   STOMACH[0]*p[0],
        STOMACH[1]*p[1],
        STOMACH[2]*p[2]]-STOMACH/2
;

module chassisPiece(p) {
    translate(chassisPos(p))
    cube(W,center=true);
}

module arduinoStand() {
    SCREW_L=12;
    PCB_W=2;
    H=SCREW_L-PCB_W;
    $fn=32;
        ngWidth = 53.34;
leonardoDepth = 68.58 + 1.1;           //PCB depth plus offset of USB jack (1.1)
ngDepth = 68.58 + 6.5;
megaDepth = 101.6 + 6.5;               //Coding is my business and business is good!
dueDepth = 101.6 + 1.1;
    
    translate([-ngWidth/2,0,0]) {
%    translate([0,0,H]) {
        cube([ngWidth,dueDepth,1.6]);
        translate([5,0,1.6])
        cube(14);
    }

    //Due and Mega 2560
dueHoles = [
  [  2.54, 15.24 ],
  [  17.78, 66.04 ],
  [  45.72, 66.04 ],
  [  50.8, 13.97 ],
  [  2.54, 90.17 ],
  [  50.8, 96.52 ]
  ];

    for(x = dueHoles) {
        translate(x)
        difference() {
            cylinder(d=6,h=H);
            cylinder(d=3.2,h=3*H,center=true);
        }
    }
    
}
}
//!arduinoStand();
POST_W=8;
    module base() {
        hull() {
            symY([0,STOMACH[1]/2,-STOMACH[2]/2])
            symX([STOMACH[0]/2,0,0])
            cube([POST_W*2,W,W],center=true);
        }
        symX([STOMACH[0]/2,0,0])
        hull() {
//            symZ([0,0,STOMACH[2]/2])
  //          symY([0,STOMACH[1]/2,0])
    //        cube(W,center=true);
        }
    }

module chassis() {
    /*
    difference() {
        cube(STOMACH+[2*W,2*W,0],center=true);
        cube(STOMACH+[0,0,W],center=true);
        
    }
    */
    module motor_mount_post(h) {
        difference() {
            hull() {
                translate([0,ttMotorHoleO(),0])
                cube([POST_W,POST_W,STOMACH[2]],center=true);
                translate([POST_W/4,ttMotorNippleO(),0])
                cube([POST_W/2,POST_W,STOMACH[2]],center=true);
            }
            motor();
        translate([POST_W/2,0,MOTOR_Z_OFF])
        rotate(90)
            at_tt_motor_mount_holes() {
                translate([0,0,POST_W])
                cylinder($fn=6,d=6,h=4,center=true);
            }
        }
    }
    module motor() {
        translate([POST_W/2,0,MOTOR_Z_OFF])
        rotate(90)
        tt_motor_scad();
    }
    
    module     allHull(p) {
        for(i = [0:len(p)-2]) {
        for(j = [i+1:len(p)-1]) {
            hull(){
                translate(p[i])
                children();
                translate(p[j])
                children();
            }
        }}
    }

    
    symX([STOMACH[0]/2+POST_W/2,0,0]) {
        symY([0,WHEEL_DIST_Y/2,0]) {
            motor_mount_post(STOMACH[2]);
    %        motor();
        }
    }
    // right next to motor post
    q=[STOMACH[0]/2+W/2,WHEEL_DIST_Y/2+ttMotorHoleO()-POST_W/2-W/2,-STOMACH[2]/2+W/2];
    p=[ for (x=[0:3]) [ (x>=2 ? 1 : -1 ) *q[0],((x==1||x==3) ? 1 : -1 ) *q[1] ,q[2] ]];
    for(pp = p) translate(pp) 
        cube([W,W,W],center=true);
    allHull(p)
        cylinder(d=W,h=W,center=true);
    symX([0,0,0])
    for(i=[0,1])
    allHull( [ p[i],(p[1]+p[0])/2,p[i]+[0,0,STOMACH[2]/2]])
        cube([W,W,W],center=true);
//    for(p0 = p) {
//        translate(p0)   cube([POST_W,W,W],center=true);
//    }
//   translate([STOMACH[0]/2+POST_W/2,WHEEL_DIST_Y/2+ttMotorHoleO()-POST_W/2-W/2,-STOMACH[2]/2+W/2])
    
}

module mounts() {
        difference() {
%        base();
    }
    translate([0,0,-STOMACH[2]/2]) {
    translate([0,70,0])
        rotate(180)
        arduinoStand();
    translate([0,-80,0])
        battery_holder();
    }


}


//tt_motor_scad();
mode="motor_mount";


if(mode == "motor_mount") {
    intersection() {
        chassis();
    translate([STOMACH[0]/2,WHEEL_DIST_Y/2,MOTOR_Z_OFF])
    cube([20,WHEEL_DIST_Y,30],center=true);
        
    }
}

if(mode=="chassis")
    chassis();
//mounts();
//battery_holder();


