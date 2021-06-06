

// + ~12 láb
// + also takaro vackok
// + also takarohoz pattintos



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


SYSTEM_H=2100;
SYSTEM_W=4370;
FOOT_H=0;

D_X=[400+$W,600-1400+1320-2*$W,400+$W];
D_Y=[0,650,1050];

X=prefix(0,D_X);
//Y=prefix(DEPTH_R+20+W-D_Y[0],D_Y);

U_H=700;
SU_H=SYSTEM_H-U_H;
SV_H=SU_H-150;

DEPTH=300;
DEPTH_A=560;
DEPTH_B=160;

K=500; // ~agy feletti kis ajto szelesseg

H1=400;
H2=1000;


g1=true;
g2=true;

module partsA() {
    
    DEPTH_A=485-$W-$W-5-3;
    echo(X);
    
    K=X[0];
    H=750;
    U_H=750;
    cabinet(str("J-"),X[2],H,DEPTH_A,foot=0)
            cBeams()
            partition2(K,U_H){
            shelf(U_H/2)
                doors("DR",U_H,cnt=1,spacing=-$W);
            partition2(X[2]-2*K+2*$W,U_H) {
                drawer(H/3)
                drawer(H/3)
                drawer(H/3);
                
                
            shelf(U_H/2)
                doors("DL",U_H,cnt=1,spacing=$W)
                ;
            }
            }
    
        
    ;
    
}

module partsA0() {

    for(x=[0,4])
    translate([X[x],0,0])
    cabinet(str("M",x),D_X[x],SYSTEM_H-FOOT_H,DEPTH_A,foot=FOOT_H)
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
        cabinet("C",D_X[2],U_H,DEPTH)
            cTop()
            partition2(K,U_H){
            shelf(U_H/2)
                doors("DR",U_H,cnt=1,spacing=0);
            partition2(D_X[2]-2*K+2*$W,U_H) {
            shelf(U_H/2);
            shelf(U_H/2)
                doors("DL",U_H,cnt=1,spacing=0);
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
        
        module ferdeLap2(d1,c=0) {
            d=DEPTH_A-DEPTH;
            z=d1-c;
            translate([W,c,0])
            eXY2(str("Wf",c,"i",d1), D_X[1]-W,z+d,z);
            echo(D_X[1]-W,z+d,z);
        }
        module ferdeAjto(h=U_H) {
            x=D_X[1]-$W;
            d=(DEPTH_A-DEPTH);
            a=atan2(d,x);
            l=sqrt(d*d+x*x);
            echo("dAngle",a,l,d,x);
            translate([$W,0,0])
            rotate(a)
            doors(
//                $openDoors=false,
                str("B",h),
                h,
                $w=l+2,
                $d=0,
                $name="SD",
                cnt=1);
        }

        
        eYZ("Q", DEPTH,SYSTEM_H);
        
//        eXZ("Q", D_X[1],SYSTEM_H);
        for(z=[0,SYSTEM_H-W])
            translate([0,0,z])
        ferdeLap2(DEPTH);
        for(z=[H1,H2])
            translate([0,0,z])
        ferdeLap2(DEPTH,3);
        
//        translate([0,0,SV_H])
  //      ferdeLap2(DEPTH_B);

        for(z=[H1/2,SU_H,SU_H+U_H/2])
        translate([0,0,z])
        ferdeLap2(DEPTH,10);
        
        translate([0,0,(H1+H2)/2])
        ferdeLap2(DEPTH/2,3);
        
        translate([0,W,SYSTEM_H])
        translate([0,DEPTH-W,0])
        ferdeAjto(SYSTEM_H-H2);

        translate([0,W,H1+W])
        translate([0,DEPTH-W,0])
        ferdeAjto(H1+W);

//        translate([0,W,SU_H])
  //      translate([0,DEPTH-W,0])
    //    ferdeAjto(U_H);

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

echo("SU_H",SU_H);
echo("SV_H",SV_H);
echo("SYSTEM_H",SYSTEM_H);
