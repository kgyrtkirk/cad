use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>
use <syms.scad>
use <galeriaagy.scad>
//room=true;
agy=true;
//storage=true;

$close="";
$front=false;
$fronts=true;
$closeWFront=[1,1];
$closeWMain=[.4,2];

$machines=true;
$openDoors=true;
$drawerState="OPEN";
$drawerBoxes=true;
$defaultDrawer="smart";

$part=undef;

W=18;
$W=18;

ROOM_H=1600+1020;
ROOM_H=1500;//1600+1020;
WALL_THICK=100;

A=1880+665;

D_L=ROOM_D_L-$W;
D_R=ROOM_D_R-$W-$W;


ROOM_A=4060;    // recheck
ROOM_B=2630;    // recheck

// ---

SYSTEM_H=2200;
DEPTH=400;
FOOT_H=61;

U_H=470;
SU_H=SYSTEM_H-U_H;

D_K=D_R-D_L;

SHOE_CAB_W=900;

DEPTH_A=560;


module onCorner1() {
    mirror([1,0,0]) 
    children();
}
module onCorner2() {
    translate([-ROOM_A,0,0])
    rotate(-90)
    mirror([1,0,0]) 
    children();
}

module onCorner3() {
    translate([-ROOM_A,ROOM_B,0])
    rotate(-180)
    mirror([1,0,0]) 
    children();
}
module onCorner4() {
    translate([0,ROOM_B,0])
    rotate(-270)
    mirror([1,0,0]) 
    children();
}

module room(cut) {
    D_L=undef;
    D_R=undef;
    
    module wall(WIDTH,HEIGHT) {
        color([.3,.7,.7])
        translate([0,-WALL_THICK,0])
        cube([WIDTH,WALL_THICK,HEIGHT]);
    }
    module walls() {
        onCorner1()
            wall(ROOM_A,ROOM_H);
        onCorner2()
            wall(ROOM_B,ROOM_H);
        onCorner3()
            wall(ROOM_A,ROOM_H);
        onCorner4()
            wall(ROOM_B,ROOM_H);
    }
    module machine(d) {
        color([.1,.7,.1])
        cube(d);
    }

    module climate() {
            // 20,105,220
        WALL_TO_L=200;
        WALL_TO_R=1050;
        FLOOR_TO_B=2200;
        onCorner1() {
            translate([200,0,FLOOR_TO_B])
            machine([WALL_TO_R-WALL_TO_L,200,300]);
        }
    }
    module window() {
        SL=500;
        SR=600;
        W_H0=900;
        W_H=1500;
        W_W=ROOM_B-SL-SR;
        onCorner4() {
            translate([SL+W_W/2,0,W_H0+W_H/2]) 
            cube([W_W,400,W_H],center=true);
        }
    }
    module door() {
        SL=650;
        SR=1120;
        W_H0=0;
        W_H=2080;
        W_W=ROOM_B-SL-SR;
        onCorner2() {
            translate([SL+W_W/2,0,W_H0+W_H/2]) 
            cube([W_W,400,W_H],center=true);
        }
    }

    difference() {
        union() {
            walls();
            climate();
        }
        union() {
            window();
            door();
        }
    }
}



module storage1(width) {
    cabinet(name = "storage", w = width, h = 2200, d = 600);
}

if(room) room();

posNeg() {
    if(agy)
    onCorner3()
    galeriaAgy();
    if(storage)
    onCorner1() 
    translate([ROOM_A,0,0]) { // go backwards
        ST_W=1000;
        translate([-ST_W,0,0]) 
        storage1(ST_W);



    }
    

}

