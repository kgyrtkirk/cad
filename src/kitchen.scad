use <syms.scad>
$machines=true;

module atLeftWall(x) {
    translate();
}

WALL_THICK=70;          //*
WALL_H=1695+915;        //* w/o laminate
HW_H=1235;              //* w/o laminate
HW_WIDTH=2075-30;       //*
FWL_WIDTH=600;          //*
BACK_WALL_WIDTH=1915;   //* FIXME: csempe benne van?

LEFT_WALL_WIDTH=HW_WIDTH+FWL_WIDTH;


function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

RIGHT_WALL_DELTA=[
    [0,0],
    [1925+18,0], //*?
//    [135+1755+42+18,0], //*?
    [0,330],
    [605,0],
    [0,-330+50],
    [660+480+420+40,0],
    [0,-10],
    [-(660+480+420+40),0],
    [0,-50],
];

RIGHT_WALL_PROFILE=prefix([0,0],RIGHT_WALL_DELTA);

echo(RIGHT_WALL_PROFILE);

//atRightCorner() 
//polygon(RIGHT_WALL_PROFILE);

module atRightCorner() {
    translate([0,BACK_WALL_WIDTH,0])

    mirror([1,0,0])
    rotate(180)
        children();
}

module walls(part="A") {
    
    module wall(WIDTH,HEIGHT) {
        color([.3,.7,.7])
        translate([-WIDTH,-WALL_THICK,0])
        cube([WIDTH,WALL_THICK,HEIGHT]);
    }

    module fullWall(WIDTH) {
        wall(WIDTH,WALL_H);
    }
    module halfWall(WIDTH) {
        wall(WIDTH,HW_H);
    }
    module radiator() {
        // FIXME: romatic-width?
        D=30;
        for(i=[0:5])
        translate([50*i,-D/2,200])
            cylinder($fn=4,d=D,h=600);
    }

    if(part=="L" || part=="A")
    rotate(0) {
        translate([HW_WIDTH+FWL_WIDTH,0,0])
        halfWall(HW_WIDTH);
        translate([FWL_WIDTH,0,0])
        fullWall(FWL_WIDTH);
    }

    // gazcso
    translate([50,0,700])
    rotate(-90,[1,0,0])
    cylinder(d=25,h=BACK_WALL_WIDTH);
    // gazelzaro
    translate([50,255,700])
    sphere(d=70);
    
    
    translate([60,800,0])
    rotate(90)
    radiator();
    
    window_pos=[0,460,885];
    window_w=970;
    window_h=1510;
    window_b=40;
    if(part=="B" || part=="A")
    difference() {
        rotate(-90)
        fullWall(BACK_WALL_WIDTH);
        translate(window_pos-[100,0,0]) {
            cube([200,window_w,window_h]);
        }
    }
    
%    translate([0,460+window_w,920]){
        cube([window_w,40,1]);
    }
    
    translate(window_pos) {
        color([1,0,0])
        mirror([0,0,1])
        cube([window_b,window_w,45]);
    }
    
    translate([50,1800,0])
        cylinder(d=50,h=WALL_H);
    
    if(part=="R" || part=="A")
    atRightCorner() {
        
//        atRightCorner() 
        
        color([.3,.7,.7])
        linear_extrude(WALL_H)
        polygon(RIGHT_WALL_PROFILE);
    }
}

use <kitchen_box.scad>

W=18;

INSET=10;
BACKSET=10;
BACKPLANE_W=1.6;
BACKPLANE_NUT_W=2;

L1W=80;     L1X=0;
L2W=600;    L2X=L1X+L1W;
L3W=208;    L3X=L2X+L2W;
L4W=600;    L4X=L3X+L3W;
L5W=600;    L5X=L4X+L4W;
L6W=600;    L6X=L5X+L5W;

LEFT_PART_WIDTH=L1W+L2W+L3W+L4W+L5W+L6W;
echo(LEFT_PART_WIDTH);
echo(LEFT_WALL_WIDTH);
echo(LEFT_WALL_WIDTH-LEFT_PART_WIDTH);

M60W=564+W;

D37=366;
D60=590; //?


MAXIMERA_D60_MIN_DEPTH=590-30;

SLIDE_LOSS=50;
R_D=MAXIMERA_D60_MIN_DEPTH+SLIDE_LOSS; // right under depth

L_W=[80+W,M60W,D60-D37,M60W,W,M60W,W,M60W];

L_X=prefix(0,L_W);


//2670
R1W=150-18;    R1X=0;//-R1W;
R2W=600;    R2X=R1X+R1W;
R3W=600;    R3X=R2X+R2W;
R4W=600;    R4X=R3X+R3W;

R_W=[0,150-18,M60W,600+W,M60W,W,RIGHT_WALL_DELTA[3][0]+W];
R_X=prefix(0,R_W);
echo("R_X",R_X);
R_Q=50;     // toloajto hely
//R_D=[]

Z_WIDTH=[0,600,600,400];
ZX=prefix(0,Z_WIDTH);
R_DEPTH=600;

FULL_H=2560;    // FIXME: critical value
SYSTEM_H=2500;  // FIXME: critical value
echo("SYS_H",SYSTEM_H);
echo("WALL_H",WALL_H);

function v3(v2) = [v2[0],v2[1],0];

module plain() {
        cube([$width,W,$height]);
}

MICRO_H=380;
module microwave() {
    
        
}


module baseL(x,w) {
    positiveAt([x,0,0]+IBEAM_Z) {
        $width=100;
        $height=100;
//        rotate(-90,[1,0,0])
        cube([w,D37,W]);
//        plain();
    }
}

module posNeg() {
    difference() {
        union(){
        $positive=true;
        children();
        }
        union(){
        $positive=false;
        children();
        }
    }
}
IBEAM_Z=[0,0,60];

module positiveAt(p) {
    if($positive) {
        translate(p)
            children();
    }
}

module smallI(x) {
    // FIXME: move to separate bottom
    positiveAt([x,0,0]+IBEAM_Z+[0,0,W]) {
        $width=D37;
        $height=800-W;
        cube([W,$width,$height]);
    }
}

module Ibeam(x,depth){
    $width=depth;
    $height=800;
    translate([x,0,0]+IBEAM_Z)
    cube([W,$width,$height]);
}
module bigI(x) {
    Ibeam(x,D60);
}

use <kitchen_box.scad>

module previewL() {
    posNeg() {
        baseL(L_X[2],L_X[5]-L_X[2]+W);
        for(i=[2:len(L_X)-1])
        smallI(L_X[i]);
        bigI(L_X[1]);
        bigI(L_X[0]);
        
        m60([L_X[4],0,860],[125],$thinL=1,$thinR=0);
        m60([L_X[6],0,860],[125],$thinL=1,$thinR=0);
        
    }
}

module previewR() {
    atRightCorner()
    posNeg() {
        for(i=[1:len(R_X)-1]) 
            Ibeam(R_X[i], R_D);
//        bigI(R_X[i]);
    }
}


module roundedCutShape(w,h,d,r) {
        hull()
        symX([(w-2*r)/2,0,0])
        symY([0,(h-2*r)/2,0])
        cylinder(r=r,h=d,center=true);
}



M_H=30;

module blancoSona6s() {
    
    A_W=1000;
    A_H=500;
    
    M1_W=165;
    M1_H=255;
    M2_W=350;
    M2_H=420;
    
    EDGE_X=40;
    EDGE_Y=40;
    
    M1_X=40+540-M1_W/2;
    M2_X=40+350-M2_W/2;
    
    if($positive){
        if($machines) {
            translate([0,0,M_H]) 
            { 
                difference() {
                    mainBowlPos=[-M2_X,0,-190/2+5];
                    secBowlPos=[-M1_X,0,-100/2+5];
                    union() {
                        translate([-A_W/2,0,0])
                        roundedCutShape(A_W,A_H,11,15);
                        translate(mainBowlPos)
                        roundedCutShape(M2_W,M2_H,190,15);
                        translate(secBowlPos)
                        roundedCutShape(M1_W,M1_H,100,15);
                    }
                    translate([-A_W/2,0,0])
                    translate([0,0,6])
                    roundedCutShape(A_W-2*EDGE_X,A_H-2*EDGE_Y,11,15);
    //                roundedCutShape(860-2*15,500-2*25,10,15);
                    translate(mainBowlPos)
                    roundedCutShape(M2_W-5,M2_H-5,190-5,15);
                    translate(secBowlPos)
                    roundedCutShape(M1_W-5,M1_H-5,100-5,15);
                }
            }
        }
    }else{
        // there is a +2,-1 tolerance
        translate([-A_W/2,0,M_H/2]) 
//        translate([-860/2,0,M_H/2])
        roundedCutShape(980,480,M_H+1,15);
    }
}

module fozoLap() {
    // amica hga6220
    if($positive) {
        if($machines) {
            translate([0,0,M_H])
            roundedCutShape(595,510,M_H+1,5);
            roundedCutShape(595,510,M_H+1,5);
            roundedCutShape(20,480+2*55,M_H*3,5);
        }
    }else{
        translate([0,0,M_H/2])
        roundedCutShape(560,480,M_H+1,M_H*2);
    }
        

}


module mAssembly() {
    translate([0,0,860])
    posNeg() {
        mPiece();
        atRightCorner()
        translate([R_X[4]+0,R_D/2,0])
        blancoSona6s();

        translate([(L_X[1]+L_X[0])/2,600/2,0])
        fozoLap();

    }
}


module mPiece() {
    
    module mPiece1(L,W) {
        if(false) {
            hull() {
                cube([L,10,M_H]);
                translate([0,W-M_H/2,M_H/2])
                rotate(90,[0,1,0])
                cylinder(d=M_H,h=L);
            }
        }else{
            cube([L,W,M_H]);
        }
    }
    module mPiece2() {
        K=500;
        S=300;
        translate([0,-S,0])
        mPiece1(K,S);
    }
    M_H=30;
    L_D37=370+35;
    L_D60=600+35;
    B_D=200;
    color([0,0,1])
    if($positive) {
        atRightCorner() {
           mPiece1(R_X[6],R_D); 
        }
        mPiece1(L_X[7],L_D37); 
        mPiece1(L_X[1],L_D60); 
        
        
        translate([L_X[1],L_D60,0])
        rotate(-45)
        mPiece2();

        ID=50;
        translate([-ID,0,0])
        mirror([1,0,0])
        rotate(90)
        mPiece1(BACK_WALL_WIDTH,200); 
        
    } else {
        atRightCorner() {
            translate([1,0,0]) // FIXME: remove this
            linear_extrude(WALL_H,center=true)
            polygon(RIGHT_WALL_PROFILE);
            
        }
        
        
        
        window_p=460; // FIXME: dup
        window_w=960;
        
        WINDOW_PROFILE=prefix([0,-400],[[0,0],[0,400],[window_p,0],[0,-200],[window_w,0],[0,200],
            [2000,0],[0,-400]]
        );
        echo(WINDOW_PROFILE);

        rotate(-90)
        mirror([1,0,0])
        linear_extrude(WALL_H,center=true)
        polygon(WINDOW_PROFILE);
        
        
    }
    

}

module previewM() {
    mAssembly();
}

mode="previewR";

if(mode=="preview") {
    walls("A");
    
    previewL();
    previewR();
    previewM();
}

if(mode=="previewL") {
    walls("L");
    walls("B");
    previewL();
}
if(mode=="previewR") {
    walls("R");
    walls("B");
    previewR();
    previewM();
}

//mode="pB";
if(mode=="pB") {
    projection(cut=true)
        bBox([
            prop("WIDTH",598),
        ],"B");
}


if(mode=="projtest") {
    projection() {
        difference() {
            cube([20,20,10],center=true);
            cylinder(d=10,h=20,center=true);
        }
    }
}


if(mode=="mPiece") {
    projection()
    posNeg()
    mPiece();
}