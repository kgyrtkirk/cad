use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>


$fronts=true;

$machines=true;
$openDoors=true;
$drawerState="CLOSED";
$drawerBoxes=true;

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



U_H=500;
SU_H=SYSTEM_H-U_H;

D_K=D_R-D_L;
L=3*820;
st=-A+L;
DELTA_WIDTH=D_K+2*$W;

UPPER_D_X=[820,820,820];
LOWER_D_X=[L-900-DELTA_WIDTH,DELTA_WIDTH,900];

UPPER_X=prefix(st,-UPPER_D_X);
LOWER_X=prefix(st,-LOWER_D_X);




DEPTH_A=560;

module partsU() {

    for(i=[0:2]) 
        translate([UPPER_X[i],0,DOOR_H])
        cabinet("C1",UPPER_D_X[i],U_H,D_R)
            cBeams()
            doors("U",U_H);
        ;        

    
}

module partsL() {
    
    
    if(false){
    
        translate([LOWER_X[0],0,0])
        cabinet("A",LOWER_D_X[0],U_H,D_L)
            cBeams()
//            doors("U",U_H)
    ;
    ;
        translate([LOWER_X[1],0,0])
        cabinet("B",LOWER_D_X[1],U_H,D_L)
            cBeams()
//            doors("U",U_H)
    ;
    ;
    }
        translate([LOWER_X[1],0,0])
    cabinet2( name = "M",
        h= U_H,
        dims=[ [0,D_R] , [ DELTA_WIDTH,D_L] , [LOWER_D_X[0],D_L]]) {
            
        doors("D1",300);
        doors("d2",200);
        doors("D3",300);
            
    }
    
    
    
        translate([LOWER_X[2],0,0])
        cabinet("C",LOWER_D_X[2],900,D_R)
            cBeams()
            drawer(300)
            drawer(300)
            drawer(300)
//            drawer(100)
//            doors("U",U_H)
    ;
    ;
}



room();

posNeg() {
    partsU();
    partsL();
}

echo(UPPER_X);
echo(A);
