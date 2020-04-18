
use <syms.scad>
use <9g_servo.scad>

//MAOAM_DIMS=[27.7,8.6,15.8]+[1,1,1];
MAOAM_DIMS=[8.6,15.8,27.7]+[1,1,1];
W=1.6;
CL=.4;

EPS=3e-3;
CAPACITY=12;

OVERSCALE=1.1;

C_R1=CAPACITY*MAOAM_DIMS[0]*OVERSCALE/PI/2;
C_R2=C_R1+MAOAM_DIMS[1]*OVERSCALE;

WHEEL_H=MAOAM_DIMS[2]*OVERSCALE;

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

module wheel() {
    
    difference() {
        union() {
            cylinder(r=C_R2,h=W);
            cylinder(r=C_R1,h=WHEEL_H+W+CL);
        }
        cylinder(r=C_R1-W,h=WHEEL_H*3,center=true);
    }
    
    atCartridgeDirs() {
            hull() {
                translate([C_R1,0,0]) cylinder(d=W,h=WHEEL_H);
                translate([C_R2-W/2,0,WHEEL_H/2]) cube([W,W,WHEEL_H],center=true);
            }
%            translate([C_R1,0,0])
            rotate(-90)
            rotate(-360/2/CAPACITY)
            cube(MAOAM_DIMS);
    }

}


module cover() {
    PORT_W=C_R2*2*PI/CAPACITY;
    difference() {
        cylinder(r=C_R2+CL+W,h=WHEEL_H+CL+W);
        
        // main cut
        translate([0,0,-W])
        cylinder(r=C_R2+CL,h=WHEEL_H+CL+W);
        
        // center cut
        translate([0,0,-W])
        cylinder(r=C_R1+CL,h=2*WHEEL_H);
        
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
        
    }
}


module dispenserPart2() {
    
    difference() {
        union() {
            intersection() {
                rotate(-90,[1,0,0])
                cylinder(d=25,h=20,center=true);
                
            }
            rotate(-90,[1,0,0])
            cylinder(d=25,h=3.6+W);

            rotate(-90,[1,0,0])
            cylinder(d1=40,d2=35,h=3);

        }
            rotate(-90,[1,0,0])
            cylinder(d=23,h=50);
    }
}


mode="preview";
if(mode=="preview") {
    difference() {
        union() {
            wheel();
            cover();
        }
        translate([0,0,-W])
        cube(100);
    }
}

if(mode=="storage") {
    storage2();
}
if(mode=="dispenser") {
    dispenserPart();
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

