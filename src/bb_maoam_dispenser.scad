
use <syms.scad>
use <9g_servo.scad>
use <../libraries/gears/gears.scad>
use <../libraries/cycloid_gear/cycloid_gear.scad>
use <../libraries/stepper.scad>



//MAOAM_DIMS=[27.7,8.6,15.8]+[1,1,1];
MAOAM_DIMS=[8.6,15.8,27.7]+[1,1,1];
W=1.6;
CL=.8;

EPS=3e-3;
CAPACITY=12;

OVERSCALE=1.1;

C_R1=CAPACITY*MAOAM_DIMS[0]*OVERSCALE/PI/2;
C_R2=C_R1+MAOAM_DIMS[1]*OVERSCALE;
C_R3=10;



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

echo("powerRatio",NTEETH_2/NTEETH_3);

module driveGear(){
    translate([NTEETH_2+NTEETH_3,0,0])
    difference() {
        union() {
            translate([0,0,(GEAR_W-GEAR2_W)/2])
            rotate(360/NTEETH_3/2)
            gear(NTEETH_3,GEAR2_W);
            cylinder(d=10,h=3,center=true);
        }
        stepperShaft1();
    }

}

module driveGearCoverPart(outside=true) {
    if(outside) {
        translate([NTEETH_2+NTEETH_3,0,0])
        ccylinder(C_R3+CL+W,(GEAR_W+CL+CL));
//        cylinder(r=C_R3+CL+W,h=(GEAR_W+CL+CL));
    }else{
        translate([NTEETH_2+NTEETH_3,0,-W])
        cylinder(r=C_R3+CL,h=2*(GEAR_W+CL+CL),center=true);
    }
}


module driveGearCover() {

    difference() {
        union() {
            driveGearCoverPart(true);
            translate([NTEETH_2+NTEETH_3+C_R3,0,0])
            coverMountEar();
        }
        translate([NTEETH_2+NTEETH_3,0,0]) {
            N=7;
            for(i=[5:9]) {
                rotate(i*360/N)
                translate([C_R3*2/3,0,0])
                cylinder(r=C_R3/4,h=WHEEL_H,center=true);
            }
        }
        driveGearCoverPart(false);
        coverMainCut();
    }
}

module stepperShaft1() {
    scale([1,1,3])
    translate([0,0,4])
    mirror([0,0,1])
    stepper_28byj48_shaft(.15) ;
}

module wheel() {
    
    difference() {
        union() {
            gear(NTEETH_2,GEAR_W);
            cylinder(r=C_R1,h=CL+WHEEL_H+CL+W);
        }
//        translate([0,0,W])
        cylinder(r=C_R1-W,h=WHEEL_H*3,center=true);
        atCartridgeDirs(true) {
            for(h=[.25,.5,.75]*WHEEL_H) {
                $fn=16;
                translate([C_R1,0,h])
                rotate(90,[0,1,0])
                cylinder(d=MAOAM_DIMS[0]/2,h=10,center=true);
            }
        }
    }
    
    
    atCartridgeDirs() {
        difference() {
            hull() {
                H=WHEEL_H-GEAR_W;
                Q=3*W;
                translate([C_R1,0,GEAR_W]) cylinder(d=W,h=H);
                translate([C_R2-W/2-Q,0,H/2+GEAR_W]) cube([W,W,H],center=true);
                translate([C_R2-W/2,0,H/2+GEAR_W+Q/2]) cube([W,W,H-Q],center=true);
            }
            for(h=[.25,.5,.75]*WHEEL_H) {
                $fn=16;
                translate([(C_R1+C_R2)/2,0,h])
                rotate(90,[1,0,0])
                cylinder(d=MAOAM_DIMS[0]/2,h=10,center=true);
            }
        }
%            translate([C_R1,0,GEAR_W])
            rotate(-90)
            rotate(-360/2/CAPACITY)
            cube(MAOAM_DIMS);
    }

}


module ccylinder(r,h) {
    $fn=128;
    C=W;
    cylinder(r=r,h=h-C);
    translate([0,0,h-C])
    cylinder(r1=r,r2=r-C,h=C);
}

module coverMainCut() {
    translate([0,0,-W])
    cylinder(r=C_R2+CL,h=CL+WHEEL_H+CL+W);
}

module coverMountEar() {
    DD=7+W/2;
    difference() {
        hull() {
            translate([0,0,0])
            cylinder(d=DD*1.5,h=W);
            translate([0+DD/2+W,0,0])
            cylinder(d=DD,h=W);
        }
        translate([DD/2+W,0,0])
        cylinder(d=3.4,h=30,center=true);
    }
}

module cover() {
    
    module coverMounts() {
        N=4;
        for(i=[0:N]) {
            rotate(360*(i+.5)/N)
                translate([C_R2,0,0])
                    coverMountEar();
        }
    }


    PORT_W=C_R2*2*PI/CAPACITY;
    difference() {
        union() {
            ccylinder(r=C_R2+CL+W,h=CL+WHEEL_H+CL+W);
            coverMounts();
        }
        
        // main cut
        coverMainCut();
        
        // center cut
        translate([0,0,-W])
        cylinder(r=C_R1+CL/2,h=2*WHEEL_H);
        
        // cut ports
        translate([0,-500,0])
        cube([PORT_W,1000,2*WHEEL_H],center=true);
        
        // decor
        atCartridgeDirs(true) {
            DD=MAOAM_DIMS[0]*2/3;
            for(h=[.25,.5,.75]*(WHEEL_H+2*CL+W)) {
                $fn=16;
                translate([C_R2,0,h])
                rotate(90,[0,1,0])
                cylinder(d=DD,h=10,center=true);
            }
            translate([(C_R2+C_R1)/2,0,0])
            cylinder(d=DD,h=100);
        }
        
        // driveGearCut
        driveGearCoverPart();
    }
}




BOARD_W=4;
mode="wheel";
socialDistancing=8;
if(mode=="preview") {
    difference() {
        union() {
            wheel();
            translate([0,0,socialDistancing*2])
            cover();
            driveGear();
            translate([0,0,socialDistancing])
            driveGearCover();
        }
//        translate([0,0,-W])        cube(100);
    }
    STEPPER_POS=[NTEETH_2+NTEETH_3,0,-BOARD_W];
    translate([0,0,-socialDistancing])
    translate(STEPPER_POS)
    rotate(-90)
    rotate(180,[1,0,0])
    stepper_28byj48();
}

//@OUTPUT:wheel
//@OUTPUT:cover
//@OUTPUT:driveGear
//@OUTPUT:driveGearCover
if(mode=="wheel") {
    wheel();
}

if(mode=="cover") {
    rotate(180,[1,0,0])
    cover();
}
if(mode=="driveGear") {
    rotate(180,[1,0,0])
    driveGear();
}
if(mode=="driveGearCover") {
    rotate(180,[1,0,0])
    driveGearCover();
}


