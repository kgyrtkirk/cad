
use <syms.scad>
use <tt-motor.scad>

SW=1.6;                       // small wall
W=4;                        // wall
STOMACH=[55+2*3,120,45];    // space available inside
M3HOLE=3.2;
M3NUT=6.2;

POST_W=8;
PLATE_WIDTH=STOMACH[0]+2*(ttMotorW()+POST_W);
PLATE_DEPTH=200;

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
    cylinder(d=M3HOLE,h=20,center=true);
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
            cylinder(d=M3NUT,h=H);
            cylinder(d=M3HOLE,h=3*H,center=true);
        }
    }
    
}
}
//!arduinoStand();
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


// right next to motor post
qPoint=[STOMACH[0]/2+W/2,WHEEL_DIST_Y/2+ttMotorHoleO()-POST_W/2-W/2,-STOMACH[2]/2+W/2];
pPositions=[ for (x=[0:3]) 
            [ (x>=2 ? 1 : -1 ) *qPoint[0],((x==1||x==3) ? 1 : -1 ) *qPoint[1] ,qPoint[2] ]];


module chassis() {
    /*
    difference() {
        cube(STOMACH+[2*W,2*W,0],center=true);
        cube(STOMACH+[0,0,W],center=true);
        
    }
    */
    // actual position is the axle pos
    module motor_mount_post(h) {
        difference() {
            hull() {
                translate([0,ttMotorHoleO(),0])
                cube([POST_W,POST_W,STOMACH[2]],center=true);
                translate([POST_W/4,ttMotorNippleO(),0])
                cube([POST_W/2,POST_W,STOMACH[2]],center=true);
            }
            motor();

        translate([POST_W/2,0,MOTOR_Z_OFF]) {

            rotate(90)
                at_tt_motor_mount_holes() {
                    translate([0,0,POST_W])
                    cylinder($fn=6,d=M3NUT,h=4,center=true);
                    cylinder($fn=32,d=M3HOLE,h=40,center=true);
                }
            }
        }
    }
    module motor() {
        translate([POST_W/2,0,MOTOR_Z_OFF])
        rotate(90)
        tt_motor_scad();
    }
    
    module atMotorPoints() {
        symY([0,WHEEL_DIST_Y/2,0]) 
            symX([STOMACH[0]/2+POST_W/2,0,0])
                children();
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

    
    atMotorPoints() {
            motor_mount_post(STOMACH[2]);
    %        motor();
    }
    for(p = pPositions) translate(p) 
        cube([W,W,W],center=true);
    allHull(pPositions)
        cylinder(d=W,h=W,center=true);
    p=pPositions;
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



module bottomPlate() {
//        rotate(45,[0,1,0])
//        cube([POST_W/2,2*POST_W,POST_W],center=true);
//    }
    K=8;
    L=3*W;
    translate((pPositions[1]+pPositions[3])/2)
    translate([0,0,-W/2+K/2])
    translate([0,W/2+3+L/2,0])
    difference() {
        hull() {
            translate([0,0,K/2])  cube([W,L,.1],center=true);
            translate([0,0,-K/2])  cube([3*W,L,.1],center=true);
        }
        rotate(270,[1,0,0]) {
            translate([0,0,-L/2-.1]) {
                cylinder($fn=32,d=3.5,h=30);
                cylinder($fn=32,d2=3.5,d1=5,h=2);
            }
        }
    }
    color([.6,.6,.9])
    translate([0,PLATE_DEPTH/4,-STOMACH[2]/2-SW/2]) {
        cube( [PLATE_WIDTH, PLATE_DEPTH/2, SW],center=true);
        
    }
}

//tt_motor_scad();
mode="preview";

if(mode=="preview") {
    chassis();
    bottomPlate();
    translate([0,-10,-10])
    rotate(180)
    bottomPlate();
}

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

