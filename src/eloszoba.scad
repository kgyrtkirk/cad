use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>

$close="";
$front=false;
$fronts=true;
$handle="top";

$machines=true;
$openDoors=false;
$drawerState="CLOSED";
$drawerBoxes=true;

$part=undef;

W=18;
$W=18;

A=1880+665;
ROOM_D_L=290;
ROOM_D_R=670;

D_L=ROOM_D_L-$W;
D_R=ROOM_D_R-$W;

DOOR_H=2100;
DOOR_W=1000;
ROOM_H=1600+1020;
WALL_THICK=100;

// ---

SYSTEM_H=2200;
DEPTH=400;
FOOT_H=61;

U_H=470;
SU_H=SYSTEM_H-U_H;

D_K=D_R-D_L;

SHOE_CAB_W=900;

DEPTH_A=560;


// https://www.remab.sk/content/images/thumbs/0008615_zaves-45iii-blum-cliptop-blumotion-79b3450.jpeg
// blum -45 ; width: +11.2

module room(cut) {
    D_L=undef;
    D_R=undef;
    
    
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
        translate([-WALL_THICK,640,2300]) 
        cube([100,300,300]);
    }


    module door() {
//        color([.3,.7,.3])
  %      cube([DOOR_W,20,DOOR_H]);
        
    }
    module walls() {
        wall(A,ROOM_H);
        rotate(-90)
        wall2(ROOM_D_L,ROOM_H);
        translate([-A,0,0])
        rotate(-90)
        wall(ROOM_D_R,ROOM_H);

        translate([0,ROOM_D_L+30,0])
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

D_X=[500,500,D_R-D_L+90+3*W,SHOE_CAB_W];
P_X=-prefix(100,D_X);

module partsU() {
    CAB_H=450;

    translate([0,0,DOOR_H]) {

        translate([P_X[0],0,0])
            cabinet("U1",D_X[0],CAB_H,D_L)
            cTop()
            doors("D1",CAB_H)
        ;
    translate([P_X[1],0,0])
        cabinet("U2",D_X[1],CAB_H,D_L)
            cTop()
            doors("D1",CAB_H)
    ;
    translate([P_X[2],0,0])
        cabinet2("U3",1000,CAB_H,dims=[ [0,D_R], [D_X[2]-2*W,D_L] ]) {
            empty();
            cBeams2()
            doors("D1",CAB_H,cnt=1);
            ;
        }
    translate([P_X[3],0,0])
        cabinet("C",D_X[3],CAB_H,D_R)
            cTop()
            doors("U",CAB_H);
    ;
    }
}
module empty(){}

module partsL() {
    L_H1=400;

    translate([P_X[0],0,FOOT_H])
        cabinet("L1",D_X[0],L_H1+1200,D_L)
//            cTop(outer=true)
            cBeams()
            shelf(L_H1)
            shelf(800)
            shelf(1200)
            doors("D1",1200)
            doors("D1",L_H1)
    ;
    translate([P_X[1],0,FOOT_H])
        cabinet("L2",D_X[1],L_H1,D_L)
            cBeams()
            doors("D1",L_H1)
            skyFoot(FOOT_H,D_X[0]+D_X[1])
    ;
    translate([P_X[2],0,0])
        cabinet2("L3",1000,L_H1,dims=[ [0,D_R], [D_X[2]-2*W,D_L] ],foot=61) {
            empty();
//            cBeams()
//space(100)
            cBeams2()
//empty();
            doors("D1",L_H1,cnt=1);
    ;
            doors("D1",L_H1);
        }
    

    SHOE_CAB_H=1050+FOOT_H;

    translate([P_X[3],0,FOOT_H])
        cabinet("C",SHOE_CAB_W,SHOE_CAB_H-FOOT_H,D_R)
//            cTop(outer=true)
            cBeams()
            drawer(150)
            drawer(300)
            drawer(300)
            drawer(300)
            skyFoot(FOOT_H)
    ;
    translate([P_X[3]-$W,D_R-61,0])
        eYZ($close="fo","SpaceR",61,SHOE_CAB_H);

    translate([P_X[3]-$W,0,SHOE_CAB_H])
        eXY($close="LF","SpaceR",SHOE_CAB_W+$W,D_R+$W);


    translate([0,0,L_H1+FOOT_H])
    {
        d1=D_L+$W;
        d2=D_R+$W;
        w=D_X[2];
//        translate([P_X[1],0,0])
  //      eXY("Cover12",D_X[0]+D_X[1],D_L+$W,rot=false);

//        translate([P_X[2],0,0]) 
  //      eXYp("Cover3",[[0,0],[0,d2],[W+sin(45)*W,d2],[w,d1],[w,0] ]);
    }


}

module hangers(){

    for(o=[P_X[0]-100:-200:P_X[2]])
    translate([o,0,1900])
        if($positive) {
            cube(100,center=true);
            translate([0,0,-1000]){
                cube([10,10,1000]);
            }
        }
}


room();

posNeg() {
    partsU();
    partsL();
    hangers();
}


echo(A);

echo("remain", A+P_X[3]);
echo("seat_w", D_X[2]+D_X[1]);

