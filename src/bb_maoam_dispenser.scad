
use <syms.scad>
use <9g_servo.scad>
use <../libraries/gears/gears.scad>
use <../libraries/cycloid_gear/cycloid_gear.scad>
use <../libraries/stepper.scad>



//MAOAM_DIMS=[27.7,8.6,15.8]+[1,1,1];
MAOAM_DIMS=[8.6,15.8,27.7]+[1,1,1];
W=1.6;
CL=.4;

EPS=3e-3;
CAPACITY=12;

OVERSCALE=1.1;

C_R1=CAPACITY*MAOAM_DIMS[0]*OVERSCALE/PI/2;
C_R2=C_R1+MAOAM_DIMS[1]*OVERSCALE;
C_R3=12;

GEAR_W=5;
WHEEL_H=MAOAM_DIMS[2]*OVERSCALE+GEAR_W;

module hullPairs(pos){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
    
}
$fn=64;


module atCartridgeDirs(middle) {
    off=middle?0:360/CAPACITY/2;
    for(i=[0:360/CAPACITY:360-EPS]) {
        rotate(i+off) {
            children();
        }
    }
    
}

function rToTeeth(i) = floor(i-2);

module gear(n,d) {
    
    spur_gear(
        modul=2,
        tooth_number=n,
        width=d,
        bore=0,
        pressure_angle=20,
        helix_angle=0,
        optimized=false);

}

NTEETH_3=rToTeeth(C_R3);
NTEETH_2=rToTeeth(C_R2);
GEAR2_W=GEAR_W*2/3;

module driveGear(){
    union() {
        translate([NTEETH_2+NTEETH_3,0,(GEAR_W-GEAR2_W)/2])
        rotate(360/NTEETH_3/2)
        gear(NTEETH_3,GEAR2_W);
        translate([NTEETH_2+NTEETH_3,0,0])
        cylinder(d=10,h=3,center=true);
    }

}


module wheel() {
    
    difference() {
        union() {
            gear(NTEETH_2,GEAR_W);
//            CycloidGear(60,3,5);
//            translate([0,0,GEAR_W])            cylinder(r=C_R2,h=W);
            cylinder(r=C_R1,h=WHEEL_H+W+CL);
        }
        cylinder(r=C_R1-W,h=WHEEL_H*3,center=true);
    }
    
    atCartridgeDirs() {
            hull() {
                H=WHEEL_H-GEAR_W;
                translate([C_R1,0,GEAR_W]) cylinder(d=W,h=H);
                translate([C_R2-W/2,0,H/2+GEAR_W]) cube([W,W,H],center=true);
            }
%            translate([C_R1,0,0])
            rotate(-90)
            rotate(-360/2/CAPACITY)
            cube(MAOAM_DIMS);
    }

}


module ccylinder(r,h) {
    C=W;
    cylinder(r=r,h=h-C);
    translate([0,0,h-C])
    cylinder(r1=r,r2=r-C,h=C);
}

module cover() {
    PORT_W=C_R2*2*PI/CAPACITY;
    difference() {
        union() {
            ccylinder(r=C_R2+CL+W,h=CL+WHEEL_H+CL+W);
            translate([NTEETH_2+NTEETH_3,0,0])
            ccylinder(r=C_R3+W+W,h=GEAR_W+CL+W);
        }
        
        // main cut
        translate([0,0,-W])
        cylinder(r=C_R2+CL,h=WHEEL_H+CL+W);
        
        // center cut
        translate([0,0,-W])
        cylinder(r=C_R1+CL/2,h=2*WHEEL_H);
        
        // cut ports
        cube([PORT_W,1000,2*WHEEL_H],center=true);
        
        // decor
        atCartridgeDirs(true) {
            DD=MAOAM_DIMS[0]*2/3;
            translate([0,0,WHEEL_H/2])
            rotate(90,[1,0,0])
            cylinder(d=DD,h=100);
            translate([(C_R2+C_R1)/2,0,0])
            cylinder(d=DD,h=100);
        }
        translate([NTEETH_2+NTEETH_3,0,0])
        cylinder(r=C_R3+W,h=2*(GEAR_W+CL+CL),center=true);
    }
}




BOARD_W=4;
mode="preview";
if(mode=="preview") {
    difference() {
        union() {
            wheel();
            cover();
            driveGear();
        }
//        translate([0,0,-W])        cube(100);
    }
    stepper_28byj48_shaft(1) ;
    STEPPER_POS=[NTEETH_2+NTEETH_3,0,-BOARD_W];
    translate(STEPPER_POS)
    rotate(180,[1,0,0])
    rotate(90)
    stepper_28byj48();
}

if(mode=="wheel") {
    wheel();
}
if(mode=="driveGear") {
    driveGear();
}
if(mode=="hole") {
    rotate(-90,[1,0,0])
    dispenserPart2();
}
if(mode=="arm") {
    arm();
}
if(mode=="top"){
    cube([MAOAM_DIMS[0],MAOAM_DIMS[1],0]+[W,W,W]);
}



