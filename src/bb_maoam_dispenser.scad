use <syms.scad>
use <9g_servo.scad>

//MAOAM_DIMS=[27.7,8.6,15.8]+[1,1,1];
MAOAM_DIMS=[15.8,27.7,8.6]+[1,1,1];
W=1.6;
EPS=3e-3;
CAPACITY=13;

ARM_LENGTH=90;
module maoam() {
    cube(MAOAM_DIMS);
}

// maoam cartridge postion[i]
function cPos(i) = [ 0, 0, MAOAM_DIMS[2]*(i+.5) ];

P_TOP=cPos(CAPACITY);
P_BOTTOM=cPos(0);

module servo_mount() {
    SERVO_W=12.5;
    SERVO_H=15.5;
    SERVO_L=23+1;
    SERVO_HOLE_X=(27.4-SERVO_L)/2;
    L=39;
    PW=3;
    
    $fn=16;
    
    HOLE_D=3;
    XO=-[servo_9g_pin_off()[0],-servo_9g_pin_off()[1],-W];
    translate([0,0,-SERVO_H-14])
    translate(XO) {
    difference() {
        translate([L/2-2.5*HOLE_D,0,(SERVO_H)-W/2])
        cube([L,SERVO_W+2*W,W],center=true);
    
        translate([SERVO_L/2,0,SERVO_H/2+W])
        cube([SERVO_L,SERVO_W+.1,SERVO_H+.1],center=true);
        
    
        translate([-SERVO_HOLE_X,0,SERVO_H+W])
        cylinder(d=1.8,h=SERVO_H*2,center=true);
        translate([SERVO_L+SERVO_HOLE_X,0,SERVO_H+W])
        cylinder(d=1.8,h=SERVO_H*2,center=true);
    }
%    9g_motor();
    }
}

module hullPairs(pos){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
    
}

SERVO_X=12.5/2+W+W+W/2;

module arm() {
    
    
    E=MAOAM_DIMS[0]+SERVO_X;
/*    translate([0,0,-ARM_LENGTH/2])
    cube([5,W,ARM_LENGTH],center=true);
    translate([E/2,0,-ARM_LENGTH])
    cube([E,W,5],center=true);
*/
//    p=[ for(a=[0:5:90]) ([-(cos(a)*E-E),0,-sin(a)*ARM_LENGTH]) ];
    p=[ [0,0,0],[0,0,ARM_LENGTH],[E,0,ARM_LENGTH] ];
    rotate(180,[1,0,0])
    hullPairs(p)
        rotate(90,[1,0,0])
        cylinder(d=5,h=W);

}

servoPos=[-MAOAM_DIMS[0]/2-SERVO_X,0,MAOAM_DIMS[2]*.7+ARM_LENGTH];

module storage2() {
    difference() {
        union() {
        hull()  {
            translate(P_TOP)    cube(MAOAM_DIMS+2*[W,W,-EPS],center=true);
            translate(P_BOTTOM) cube(MAOAM_DIMS+2*[W,W,W],center=true);
        }
    translate([-MAOAM_DIMS[0]/2-W,-5,servoPos[2]])
    cube([2*W,20,50],center=true);
    translate(servoPos)
    rotate(-90,[1,0,0])
    rotate(90)
    servo_mount();
    }
        
        //channel
        hull()  {
            translate(P_TOP)    cube(MAOAM_DIMS,center=true);
            translate(P_BOTTOM) cube(MAOAM_DIMS,center=true);
        }
        
        // loader cut
        translate(P_TOP+[0,W,0])    cube(MAOAM_DIMS+[0,W,0],center=true);
        
        // ejector cut
        translate(P_BOTTOM)    cube(MAOAM_DIMS+[3*W,0,0],center=true);
        
        for(i=[0:CAPACITY]) {
            translate(cPos(i)) {
                symY([0,MAOAM_DIMS[0]/2,0])
                rotate(90,[0,1,0])
                cylinder($fn=4,d=5,h=50,center=true);
                rotate(90)
                rotate(90,[0,1,0])
                cylinder($fn=4,d=5,h=50,center=true);
            }
        }
    }
    
    
%    translate(servoPos)
    rotate(10,[0,1,0])
    arm();
}


module dispenserPart() {
    MWW=MAOAM_DIMS+2*[W,W,W];
    difference() {
        hull() {
            translate(cPos(0))  cube(MAOAM_DIMS+2*[W,W,-EPS],center=true);
            translate(cPos(-3)) cube(MAOAM_DIMS+2*[W,W,W],center=true);
        }
        //sidecut
        
        translate(cPos(0)+[-W,0,0])  cube(MAOAM_DIMS+2*[W,0,0],center=true);
        hull() {
        translate(cPos(0)+[0,0,0])  cube(MAOAM_DIMS+2*[0,0,0],center=true);
        translate(cPos(-2)+[0,0,0])  cube(MAOAM_DIMS+2*[0,0,0],center=true);
        }
        hull() {
            translate(cPos(-2)+[0,0,0])  cube(MAOAM_DIMS+2*[0,0,0],center=true);
            translate(cPos(-3)+[0,MAOAM_DIMS[1],0])  cube(MAOAM_DIMS+2*[0,W,0],center=true);
        }
//            translate(cPos(-1)) cube(MAOAM_DIMS+2*[W,W,W],center=true);
        
    }
    
//  cylinder(d=22);  
}
module dispenserPart2() {
    
    difference() {
        union() {
            intersection() {
                hull() {
                    translate(cPos(0))  cube(MAOAM_DIMS+4*[W,0,W],center=true);
                    translate(cPos(-2)) cube(MAOAM_DIMS+4*[W,0,W],center=true);
                }
                translate([0,MAOAM_DIMS[1]/2-W,0])
                translate(cPos(-2))
                rotate(-90,[1,0,0])
                cylinder(d=25,h=20,center=true);
                
            }
            translate([0,MAOAM_DIMS[1]/2-W,0])
            translate(cPos(-2))
            rotate(-90,[1,0,0])
            cylinder(d=25,h=3.6+W);

            translate([0,MAOAM_DIMS[1]/2+3.6,0])
            translate(cPos(-2))
            rotate(-90,[1,0,0])
            cylinder(d1=40,d2=35,h=3);

        }
            translate([0,MAOAM_DIMS[1]/2,0])
            translate(cPos(-2))
            rotate(-90,[1,0,0])
            cylinder(d=23,h=50);


        hull() {
            translate(cPos(1))  cube(MAOAM_DIMS+2*[W,W,W],center=true);
            translate(cPos(-2)) cube(MAOAM_DIMS+2*[W,W,W],center=true);
        }
        
    }
        

    
}


mode="preview";
if(mode=="preview") {
    stOff=[-MAOAM_DIMS[0]-W-W-W,0,0];
    translate(stOff)
    storage2();
    dispenserPart();
    translate(cPos(-1.5))
    dispenserPart2();
    translate(cPos(CAPACITY-1.5)+stOff)
    rotate(180,[0,1,0])
    dispenserPart2();
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

