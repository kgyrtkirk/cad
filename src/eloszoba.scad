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

module room(cut) {
    A=3000;
    D_L=290;
    D_R=670;
    DOOR_H=2100;
    DOOR_W=1000;
    
    ROOM_H=1600+1020;
    WALL_THICK=100;
    
    module wall(WIDTH,HEIGHT) {
        color([.3,.7,.7])
        translate([-WIDTH,-WALL_THICK,0])
        cube([WIDTH,WALL_THICK,HEIGHT]);
    }
    module wall2(WIDTH,HEIGHT) {
        translate([0,WALL_THICK,0])
        wall(WIDTH,HEIGHT);
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
//            gasLine();
        }
  //      windowCut();
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


DEPTH_A=560;

module partsA() {

    for(x=[0,4])
    translate([X[x],0,0])
    cabinet("n",D_X[x],SYSTEM_H-FOOT_H,DEPTH_A,foot=FOOT_H)
        cTop()
        shelf(300)
        hanger(500)
        doors("B",SYSTEM_H-FOOT_H-2*200)
        shelf($W/2)
        drawer(200)
        drawer(200)
        
    ;

    for(x=[1,3]) {
        translate([X[x],0,0])
        cabinet("n",D_X[x],SYSTEM_H-FOOT_H,DEPTH,foot=FOOT_H)
            cTop()
                shelf(600)
                doors("a",600)
                doors("a",1000)
            shelf($W/2,SHELF_INSET=0)
            //maximera1(150)
            //maximera1(150)
            shelf(0,SHELF_INSET=0)
            shelf(300,SHELF_INSET=0)
        ;
    }
    translate([X[2],0,SU_H])
        cabinet("n",D_X[2],U_H,DEPTH)
            cTop()
        ;
    
    
    
}

room();

posNeg()
partsA();

echo(X);
