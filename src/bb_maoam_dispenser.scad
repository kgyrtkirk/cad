
use <syms.scad>
use <9g_servo.scad>
use <../libraries/gears/gears.scad>
use <../libraries/cycloid_gear/cycloid_gear.scad>
use <../libraries/stepper.scad>



//MAOAM_DIMS=[27.7,8.6,15.8]+[1,1,1];
MAOAM_DIMS=[8.6,15.8,27.7]+[1,1,1];
W=.9;
CL=.8;

EPS=3e-3;
CAPACITY=16;

OVERSCALE=1.1;

C_R1=CAPACITY*MAOAM_DIMS[0]*OVERSCALE/PI/2;
C_R2=C_R1+MAOAM_DIMS[1]*OVERSCALE;
C_R3=12;

GEAR_W=5;
WHEEL_H=MAOAM_DIMS[2]*OVERSCALE+W;

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
            atCartridgeDirs() {
                    hull() {
                        translate([0,0,W])
                        cube([W,W,2*W],center=true);
                        translate([C_R1,0,WHEEL_H*5/6])
                        cube([W,W,WHEEL_H/3],center=true);
                    }
                }
                cylinder(r=5,h=4);
            }
            
            scale([1,1,3])
            translate([0,0,4])
            mirror([0,0,1])
            stepper_28byj48_shaft(.1) ;
    }
    difference() {
        union() {
            cylinder(r=C_R2,h=W);
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
                H=WHEEL_H;
                translate([C_R1,0,0]) cylinder(d=W,h=H);
                translate([C_R2-W/2,0,H/2+0]) cube([W,W,H],center=true);
            }
            for(h=[.25,.5,.75]*WHEEL_H) {
                $fn=16;
                translate([(C_R1+C_R2)/2,0,h])
                rotate(90,[1,0,0])
                cylinder(d=MAOAM_DIMS[0]/2,h=10,center=true);
            }
        }
%            translate([C_R1,0,W])
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
    
    module coverMounts() {
        N=4;
        DD=7+W/2;
        for(i=[0:N]) {
            rotate(360*(i+.5)/N)
                difference() {
                    hull() {
                        translate([C_R2,0,0])
                        cylinder(d=DD*1.5,h=W);
                        translate([C_R2+DD/2+W,0,0])
                        cylinder(d=DD,h=W);
                    }
                    translate([C_R2+DD/2+W,0,0])
                    cylinder(d=3.4,h=30,center=true);
                }
        }
    }


    PORT_W=C_R2*2*PI/CAPACITY;
    difference() {
        union() {
            ccylinder(r=C_R2+CL+W,h=CL+WHEEL_H+CL+W);
            coverMounts();
        }
        
        // main cut
        translate([0,0,-W])
        cylinder(r=C_R2+CL,h=WHEEL_H+CL+W);
        
        // center cut
        translate([0,0,-W])
        cylinder(r=C_R1+CL/2,h=2*WHEEL_H);
        
        // cut ports
        translate([0,500,0])
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




BOARD_W=4;
mode="wheel";
if(mode=="preview") {
    difference() {
        union() {
            wheel();
            cover();
        }
        translate([0,0,-W])        cube(100);
    }
//    translate([0,0,-1])
    STEPPER_POS=[0,0,-BOARD_W];
    translate(STEPPER_POS)
    rotate(180,[1,0,0])
//    rotate(90)
    stepper_28byj48();
}

if(mode=="wheel") {
    wheel();
}

if(mode=="cover") {
    rotate(180,[1,0,0])
    cover();
}


