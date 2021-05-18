use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>


$fronts=true;

$machines=true;
$internal=true;
$openDoors=true;
$drawerState="CLOSED";

$part=undef;

W=18;
$W=18;

A=1880+665;
D_L=290;
D_R=670;
DOOR_H=2100;
DOOR_W=1000;
ROOM_H=1600+1020;
WALL_THICK=100;


module room(cut) {
    
    
    module wall(WIDTH,HEIGHT) {
        color([.3,.7,.7])
        translate([-WIDTH,-WALL_THICK,0])
        cube([WIDTH,WALL_THICK,HEIGHT]);
    }
    module wall2(WIDTH,HEIGHT) {
        translate([0,WALL_THICK,0])
        wall(WIDTH,HEIGHT);
    }

    module electric() {
        color([1,0,0])
        translate([-WALL_THICK,800,2300]) 
        cube([100,300,300]);
    }


    module door() {
//        color([.3,.7,.3])
  %      cube([DOOR_W,20,DOOR_H]);
        
    }
    module walls() {
        wall(A,ROOM_H);
        rotate(-90)
        wall2(D_L,ROOM_H);
        translate([-A,0,0])
        rotate(-90)
        wall(D_R,ROOM_H);

        translate([0,D_L+30,0])
        rotate(180)
        door();
    }
    
    difference() {
        union() {
            walls();
            electric();
        }
    }
}





SYSTEM_H=2200;
SYSTEM_W=4370;
DEPTH=400;
FOOT_H=60;

D_X=[1000,425,1850,425,650];
D_Y=[0,650,1050];

X=prefix(0,-D_X);
//Y=prefix(DEPTH_R+20+W-D_Y[0],D_Y);

U_H=600;
SU_H=SYSTEM_H-U_H;

UPPER_D_X=[800,800,800];

UPPER_X=prefix(-100,-UPPER_D_X);




DEPTH_A=560;

module partsA() {

    for(i=[0:2]) 
        translate([UPPER_X[i],0,DOOR_H])
        cabinet("C1",UPPER_D_X[i],U_H,D_R)
            cBeams()
            doors("U",U_H);
    
        ;        

    
}

room();

posNeg()
partsA();

echo(UPPER_X);
echo(A);
