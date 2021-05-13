
// osszeszereles nehez
// ajtok:
//  A827-PS11-18
//  A319-PS17-18
// korpusz:
//  A825-PS17-18



use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>


$fronts=true;
$machines=true;
$internal=true;
$openDoors=false;
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


SYSTEM_H=2100;
SYSTEM_W=4370;
FOOT_H=0;

D_X=[1000,425,1850,425,650];
D_Y=[0,650,1050];

X=prefix(0,-D_X);
//Y=prefix(DEPTH_R+20+W-D_Y[0],D_Y);

U_H=600;
SU_H=SYSTEM_H-U_H;
SV_H=SU_H-200;

DEPTH=400;
DEPTH_A=560;
DEPTH_B=160;

K=450; // ~agy feletti kis ajto szelesseg


g1=true;
g2=true;

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

    if(false)
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
    if(g1)
    translate([X[2],0,SU_H]) {
        cabinet("n",D_X[2],U_H,DEPTH)
            cTop()
            partition2(K,U_H){
            shelf(U_H/2)
                doors("DR",U_H,cnt=1,spacing=10);
            partition2(D_X[2]-2*K+2*$W,U_H) {
            shelf(U_H/2);
            shelf(U_H/2)
                doors("DL",U_H,cnt=1,spacing=-10);
            }
            }
    
        ;
    }
    if(g1)
    translate([X[2],0,SV_H]) {
        translate([0,W,0])
            eXY("H_U",D_X[2],DEPTH_B-W);
        eXZ("H_B",D_X[2],SU_H-SV_H);
    }
    
    
    
    module q(w) {
        
        module ferdeLap() {
            translate([0,W,0])
            eXY2("Q", D_X[1],DEPTH_A-W,DEPTH-W);
        }
        module ferdeLap2(d1) {
            d=DEPTH_A-DEPTH;
            z=d1-W;
            translate([0,W,0])
            eXY2("W", D_X[1],z+d,z);
        }
        module ferdeAjto() {
            d=(DEPTH_A-DEPTH);
            a=atan2(d,D_X[1]);
            l=sqrt(d*d+D_X[1]*D_X[1]);
            echo("dAngle",a);
            rotate(a)
            doors(
//                $openDoors=false,
                "B",
                U_H,
                $w=l,
                $d=0,
                $name="SD",
                cnt=1);
        }

        
        eXZ("Q", D_X[1],SYSTEM_H);
        for(z=[0,400,1000,SU_H,SYSTEM_H-W])
            translate([0,0,z])
        ferdeLap2(DEPTH);
        
        translate([0,0,SV_H])
        ferdeLap2(DEPTH_B);

        translate([0,0,SU_H+U_H/2])
        ferdeLap2(DEPTH-10);
        
        translate([0,W,SYSTEM_H])
        translate([0,DEPTH-W,0])
        ferdeAjto();
    }
    
    if(g2)
    translate([X[1],0,0])
        q(D_X[1]);
    if(g2)
    translate([X[3],0,0])
        mirror([1,0,0])
        translate([-D_X[1],0,0])
        q(D_X[1]);
    
}

posNeg()
partsA();

echo(X);
