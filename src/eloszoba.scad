use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>

$close="";
$front=false;
$fronts=true;
$handle="top";
$closeWFront=[1,1];
$closeWMain=[.4,2];

$machines=true;
$openDoors=true;
$drawerState="OPEN";
$drawerBoxes=true;

$part=undef;

W=18;
$W=18;

A=1880+665;
ROOM_D_L=290;
ROOM_D_R=670;

D_L=ROOM_D_L-$W;
D_R=ROOM_D_R-$W-$W;

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

D_X=[500,500,D_R-D_L+100+4*W,SHOE_CAB_W];
P_X=-prefix(90,D_X);

module partsU() {
    CAB_H=450;

    translate([0,0,DOOR_H]) {
        $close="F";

        translate([P_X[0],0,0])
            cabinet("U1",D_X[0],CAB_H,D_L)
            cTop()
            shelf(200)
            doors("D",CAB_H)
        ;
    translate([P_X[1],0,0])
        cabinet("U2",D_X[1],CAB_H,D_L)
            cTop()
            shelf(200)
            doors("D",CAB_H)
    ;
    translate([P_X[2],0,0])
        cabinet2("U3",1000,CAB_H,dims=[ [0,D_R], [D_X[2]-2*W,D_L] ]) {
            empty();
            cBeams2()
            doors("D",CAB_H,cnt=1);
            ;
        }
    translate([P_X[3],0,0])
        cabinet("U4",D_X[3],CAB_H,D_R)
            cTop()
            shelf(200)
            doors("D",CAB_H);
    ;
    SP_DEPTH=200;
    translate([P_X[3]-$W,D_R-SP_DEPTH,0])
        eYZ($close="foU","SpacerTopR",SP_DEPTH,CAB_H);
    }

}
module empty(){}

module partsL() {
    $close="F";
    L_H1=400;
    L_H2=L_H1+1200;
    L_H3=DOOR_H;


    translate([P_X[0],0,FOOT_H])
        cabinet("L1",D_X[0],L_H2,D_L)
//            cTop(outer=true)
            cBeams()
            shelf(500)
            shelf(300)
            shelf(700)
            shelf(900)
            shelf(1200+$W)
            doors("D1",1200)
            doors("D1",L_H1)
    ;

    translate([P_X[0],0,L_H2+FOOT_H])
        eYZ($close="Foub","SpacerLowLe",D_L,L_H3-L_H2-FOOT_H);
    translate([-100,0,L_H2+FOOT_H])
        eYZ($close="Foub","SpacerLowLe",D_L,L_H3-L_H2-FOOT_H);

    translate([P_X[1],0,FOOT_H])
        cabinet("L2",D_X[1],L_H1,D_L)
            cBeams()
            shelf(200)
            doors("D1",L_H1)
            skyFoot(FOOT_H,D_X[0]+D_X[1])
    ;
    translate([P_X[2],0,0])
        cabinet2("L3",1000,L_H1,dims=[ [0,D_R], [D_X[2]-2*W,D_L] ],foot=FOOT_H) {
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
        cabinet("L4",SHOE_CAB_W,SHOE_CAB_H-FOOT_H,D_R)
//            cTop(outer=true)
            cBeams()
            drawer(150,type="smart")
            drawer(300,type="smart")
            drawer(300,type="smart")
            drawer(300,type="smart")
            skyFoot(FOOT_H)
    ;
    translate([P_X[3]-$W,D_R-61,0])
        eYZ($close="fo","SpacerLowR",61,SHOE_CAB_H);

    translate([P_X[3]-$W,0,SHOE_CAB_H])
        eXY($close="LF","ShoeTop",SHOE_CAB_W+$W,D_R+$W);


    translate([0,0,L_H1+FOOT_H])
    {
        d1=D_L+$W;
        d2=D_R+$W;
        w=D_X[2];
        translate([P_X[1],0,0])
        eXY("SCover12",D_X[1],D_L+$W,rot=false);

        translate([P_X[2],0,0]) 
        eXYp("SCover3",[[0,0],[0,d2],[W+sin(45)*W,d2],[w,d1],[w,0] ]);
    }


}

module hangers(){

    dist=170;
    x0=P_X[0]-100;
    x1=x0-5*dist;
    translate([x1,$W,1900-100])
    eXZ($close="OULR","HangerStand",x0-x1,200);

    for(o=[x0-dist/2:-dist:x1])
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

echo("QQ",atan2(D_R-D_L,D_X[2]));


// hinge:
// https://publications.blum.com/2020/catalogue/hu/140/
// lap delta: 9.5
// 79B3451
// 173H7100
// 171A5500
