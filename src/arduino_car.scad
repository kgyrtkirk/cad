// monitor battery
// switch
// servo + laser
//
// wheel step counter
// lights ws28?
// i2c display?

use <syms.scad>
use <tt-motor.scad>

SW=1.6;                       // small wall
W=4;                        // wall
STOMACH=[55+2*3,120,45];    // space available inside

TIGHT_M3HOLE=2.9;
M3HOLE=3.2;
M3NUT=6.2;

POST_W=8;
PLATE_WIDTH=STOMACH[0]+2*(ttMotorW()+POST_W);
PLATE_WIDTH2=STOMACH[0]+2*(POST_W);
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

module arduinoStand(stands) {
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
        translate([0,0,26])
        cube([ngWidth,dueDepth,1.6]);
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
        if(stands) {
            difference() {
                cylinder(d=M3NUT,h=H);
                cylinder(d=TIGHT_M3HOLE,h=3*H,center=true);
            }
        }else{
            // cut
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

module plateWedge(tight=true) {
    d=tight?TIGHT_M3HOLE:M3HOLE;
    translate([POST_W/2,ttMotorHoleO()+3,STOMACH[2]/2]){
            cylinder($fn=32,d=d,h=STOMACH[2]*1.5,center=true);
    }
}
    

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
           translate([-POST_W/2,0,-STOMACH[2]/2])
            plateWedge(true);

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


module bottomPlate() {

    difference() {
        translate([0,PLATE_DEPTH/4,-STOMACH[2]/2-SW/2]) {
            
            cube( [PLATE_WIDTH, PLATE_DEPTH/2, SW],center=true);
        }
        symX([STOMACH[0]/2,WHEEL_DIST_Y/2,-STOMACH[2]/2]) {
            plateWedge(false);
        }
    }
}
module topPlate(part=0) {
    H=500;
    intersection() {
        topPlate0();
        if(part>=0) 
            translate([0,H/2,0]*(part*2-1))
            cube(H,center=true);
    }
}


function    eP(a,b,alpha) = [
    a*cos(alpha),
    b*sin(alpha)
];


module m1(W00=PLATE_WIDTH2) {
    W0=W00/2;
    W1=PLATE_WIDTH/2;
    H=PLATE_DEPTH/2;
    K=W1/2;
    points = [ 
        [W0,-H],
        [W0,H],
        [W1,H],
        for(a=[0:180]) eP(W1,K,a)+[0,H],
        [-W1,H],
        [-W0,H],
        [-W0,-H],
        for(a=[180:360]) eP(W1,K,a)+[0,-H],
    ];
    polygon(points);
}


module topPlate0() {
        translate([0,0,-(STOMACH[2]/2+SW/2)]) {
        difference() {
            union() {
                //cube( [PLATE_WIDTH2, PLATE_DEPTH, SW],center=true);
                linear_extrude(height=SW)m1();
                translate([0,50,0])
                rotate(180)
                arduinoStand(true);
            }
            
            
/*            K=21;
            D=12;
            for(j=[-5:10])
                translate([j*sqrt(3)/2*K,j*K/2,0])
            for(i=[0:10])
                translate([0,-i*K,0])*/
            
            translate([0,-40,0])
            cylinder($fn=6,d=40,h=100,center=true);
            symX([20,-80,0])
            cylinder($fn=6,d=30,h=100,center=true);
        translate([0,-80,0])
            rotate(90)
            battery_holder();
            
            symY([0,0,0])
            symX([STOMACH[0]/2,WHEEL_DIST_Y/2,-STOMACH[2]/2]) {
            plateWedge(false);
        }

    }
        }
        
    
 }

//tt_motor_scad();
mode="topPlate0";

if(mode=="preview") {
    chassis();
    rotate(180,[1,0,0])
    topPlate(-1);
    if(false) {
        bottomPlate();
        translate([0,-10,-10])
        rotate(180)
        bottomPlate();
    }
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

if(mode=="topPlate0")
    topPlate(0);
if(mode=="topPlate1")
    topPlate(1);

//mounts();
//battery_holder();


