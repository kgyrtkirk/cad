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
    
    module walls() {
        H=3000;

    }
    
    module windowCut() {

        D=[D_W*3,770,1200];
        H=cut=="Z"?0:950; // FIXME
        translate([ROOM_X-D_W*1.5,420,H])
        cube(D);
    }
    
    module gasLine() {
        Y=55;
        H=2570;
        p=[ [870,Y,0],
            [870,Y,H],
            [ROOM_X,Y,H],
        ];
        
        color([1,0,0])
        hullPairs(p,false)
            sphere(d=25,$fn=6);
//        K=420+770+1160;
        K=2360;
        p2=[ [ROOM_X-Y,K,0],
             [ROOM_X-Y,K,800],
        ];
        color([1,0,0])
        hullPairs(p2,false)
            sphere(d=25,$fn=6);
    }
    
    difference() {
        union() {
            walls();
            gasLine();
        }
        windowCut();
    }
}



module cabinet1(name,D,heights) {
    Z=prefix(0,heights);
    H=Z[len(Z)-1]+W;
    eYZ(name,D,H);
    translate([M60W,0,0])
    eYZ(name,D,H);
    
    for(z=Z)
    translate([W,0,z])
    eXY(name,M60I,D);
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

posNeg()
partsA();

echo(X);
