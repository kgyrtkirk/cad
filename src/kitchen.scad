use <syms.scad>
//$fronts=true;
$machines=false;

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
//    at
//    9,34
//    11 117
        
        translate([90,340,0])
        cylinder(d=30,h=WALL_H);
        
        translate([110,50,1170])
        sphere(d=70);
        
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

M60I=564;
M60W=M60I+W;


D37=366;
D60=590; //?


MAXIMERA_D60_MIN_DEPTH=590-30;

SLIDE_LOSS=50;
R_D=MAXIMERA_D60_MIN_DEPTH+SLIDE_LOSS; // right under depth

L_W=[80+W,M60W,W,D60-D37,W,M60W,W,M60W,W,M60W];

L_X=prefix(0,L_W);


//2670
R1W=150-18;    R1X=0;//-R1W;
R2W=600;    R2X=R1X+R1W;
R3W=600;    R3X=R2X+R2W;
R4W=600;    R4X=R3X+R3W;

R_W=[0,150-W-W/2-5,M60W,600+W+5,M60W,W,RIGHT_WALL_DELTA[3][0],W,W,M60W,W,M60W];
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

module baseX(name,x,w) {
    ppp(name)
        positiveAt([x,0,0]) {
        $width=100;
        $height=100;
            color([.5,.5,1]) {
                hull() {
                    cube([.01,D60,W]);
                    translate([w,0,0])
                    cube([.01,D37,W]);
                }
            }
        }

}

module ppp(name) {
    echo(name);
    if($positive)
    if($part==undef || $part==name) 
        children();
}

module baseL2(name, x,w,$depth=D37) {
    ppp(name) 
        baseL(x,w,$depth);
}
module baseL(x,w,$depth=D37) {
    positiveAt([x,0,0]) {
        $width=100;
        $height=100;
//        rotate(-90,[1,0,0])
        color([.5,.5,1])
        cube([w,$depth,W]);
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

module IbeamX(name, x, depth, height=800) {
    ppp(str("YZ_",name))
        baseI(x,depth,height);
}


module hbeam(name,width,depth) {
    ppp(name)
        translate([W,0,0])
        cube([width,depth,W]);
}

module Ibeam(x,depth){
    $width=depth;
    $height=800;
    translate([x,0,0])
    cube([W,$width,$height]);
}

module baseI(x,depth,height){
    $width=depth;
    $height=height;
    translate([x,0,0])
    cube([W,$width,$height]);
}



use <kitchen_box.scad>

module vent() {
    if($positive) {
        
    }else{
        roundedCutShape(520,280,2*W+1,5);
//        cube([520,280,2*W+1],center=true);
    }
}

module doors(w,h,d) {
    FRONT_SP=2;
    
    cL=[w/4,W/2,h/2];
    cR=cL+[w/2,0,0];
    translate([0,d,0])
    if($positive) {
        color([0,1,1]){
        translate(cL)
        cube([w/2-FRONT_SP,W,h-FRONT_SP],center=true);
        translate(cR)
        cube([w/2-FRONT_SP,W,h-FRONT_SP],center=true);
        }
    }else{
        
    }
}

module doors2(w,h,d) {
    
    translate([0,0,-h])
        doors(w,h,d);
    
    translate([0,0,-h])
        children();
    
}

module previewLU() {
    
    POS_Y=1650;
    
    WIDTH=L_X[1];
    D45=450;
    SH=SYSTEM_H-POS_Y;
    posNeg() {
        translate([0,0,POS_Y]) {
            
            baseL(W,WIDTH,D45);
            translate([0,0,SH-W])
            baseL(W,WIDTH,D45);

            baseI(0,D45,SH);
            baseI(L_X[1]+W,D45,SH);

            translate([(L_X[0]+L_X[1])/2,D45/2,0])
            vent();
            
            doors(WIDTH+2*W,SH,D45);
        }
    }
    
}
module previewL() {
    translate(IBEAM_Z)
    posNeg() {
        baseL2("U1",L_X[4]+W,M60I);
        baseL2("U2",L_X[6]+W,M60I);
        baseL2("U3",L_X[8]+W,M60I);
        for(i=[3:len(L_X)-1])
        IbeamX(str("LI",i),L_X[i],D37);
        IbeamX("LA0",L_X[0],D60);
        IbeamX("LA1",L_X[1],D60);
        IbeamX("LA2",L_X[2],D60);
        
        translate([L_X[8],0,800])
            m60a(125)
            m60a(125)
            m60a(550)
        ;
        
        translate([L_X[6],0,800])
            m60a(125)
            m60a(125)
            m60a(550)
        ;

        translate([L_X[4],0,800])
            microWave()
            m60a(800-460)
        ;

        translate([L_X[0],0,800])
            oven()
            m60b(200)
        ;
        

        if(false) // FIXME: 45 deg door?
        translate([L_X[2],D60,0])
        rotate(-45)
        cube([(D60-D37)*sqrt(2),W,800]);

        baseX("X1",L_X[2]+W,D60-D37-W);
        translate([0,0,400])
        baseX("X2",L_X[2]+W,D60-D37-W);

        baseL2("U0",L_X[0]+W,M60I,$depth=D60);

        
//        m60([L_X[4],0,860],[125,125,550]);
  //      m60([L_X[6],0,860],[125]);
        
    }
}

module dishwasher() {
//  SMS46KI04E 
    W=600;
    D=600;
    H=845;
    if($positive) {
        if($machines) {
            color([1,0,0])
            cube([W,D,H]);
        }
    }
}

module fridge() {
    //AEG S63300KDX0
    W=595;
    D=658;
    H=1540;
    if($positive) {
        if($machines) {
            translate([2.5,0,0])
            color([1,0,0])
            cube([W,D,H]);
        }
    }
}

module previewR() {
    
    // a kozepso oszlopos szar netto melysege
    WALL_IX=330;
    atRightCorner()
    translate(IBEAM_Z)
    posNeg() {
        for(i=[1:4]) 
            IbeamX(str("RC",i),R_X[i], R_D);
        
        // IX box
        translate([0,WALL_IX+W,0]) {
            for(i=[5:6]) 
                IbeamX(str("RD",i),R_X[i], R_D-WALL_IX-W);
            baseL(R_X[5]+W, R_X[6]-R_X[5]-W,R_D-WALL_IX-W);
        }
        baseL(R_X[1]+W,M60I,R_D);
        baseL(R_X[3]+W,M60I,R_D);
        
        
        translate(-IBEAM_Z) {
            baseI(R_X[5],WALL_IX,SYSTEM_H+IBEAM_Z[2]);
            baseI(R_X[7],R_D,SYSTEM_H+IBEAM_Z[2]);
            
            
            translate([R_X[2]+W,0,0])
            dishwasher();
            translate([R_X[7]+W,0,0])
            fridge();
        }
        
            {
                    $depth=R_D; 
            translate([R_X[1],0,800])
                m60b(200)
                m60b(200)
                m60b(400)
            ;
            translate([R_X[3],0,800])
                m60b(800)
            ;

            }
        R_D2=R_D-SLIDE_LOSS;
        translate([0,SLIDE_LOSS,0]) {
            baseI(R_X[10],R_D2,SYSTEM_H);
            baseI(R_X[11],R_D2,SYSTEM_H);
            
            OVER_FRIDGE_Z=1600-IBEAM_Z[2];
            OVER_FRIDGE_H=SYSTEM_H-OVER_FRIDGE_Z;
            translate([0,0,OVER_FRIDGE_Z]) {
                baseI(R_X[8],R_D2,OVER_FRIDGE_H);
                baseI(R_X[9],R_D2,OVER_FRIDGE_H);
                
                baseL(R_X[8]+W,M60I,R_D2);
                translate([0,0,OVER_FRIDGE_H-W])
                baseL(R_X[8]+W,M60I,R_D2);
                translate([0,0,OVER_FRIDGE_H/2-W/2])
                baseL(R_X[8]+W,M60I,R_D2);
            }
            baseL(R_X[10]+W,M60I,R_D2);

                    $depth=R_D2; 
            
            translate([R_X[5],0,0])
                doors(R_X[6]-R_X[5]+W,800,R_D2);
            ;
            translate([R_X[7]+W,0,SYSTEM_H])
                doors2(600,SYSTEM_H-OVER_FRIDGE_Z,R_D2);
            ;

            
            PEEK_H=1400;
            translate([R_X[9]+W,0,SYSTEM_H])
                doors2(600,SYSTEM_H-PEEK_H,R_D2)
                m60b(150)
                m60b(150)
                m60b(150)
                m60b(150)
                m60b(150)
                m60b(150)
                m60b(200)
                m60b(300)
            ;
        }
        
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
                translate([38,0,0])
            sphere(10);
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


module oven() {
    F_H=600;
    SP_BACK=50;
    translate([0,SP_BACK,-F_H-W+3])
    hbeam("OVEN_H",M60I,D60-SP_BACK);
    translate([0,0,-F_H])
    children();
}

module microWave() {
    // heinner microwave
    // HMW-23BIXBK
    F_H=443; //brut:458
    F_W=560;// brut:595
    
    E_H=460;
    SP_BACK=50;
    
    
    translate([0,SP_BACK,-E_H])
    hbeam("MICRO_H",M60I,D37-SP_BACK);
    
    translate([0,0,-E_H])
    children();
    
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


module cornerCutOut() {
    C_W=R_X[1]+W;
    
    if($positive) {
    }else{
        
    roundedCutShape(2*C_W,450*2,M_H*3,5);
    }
}

module mAssembly() {
    translate([0,0,860])
    posNeg() {
        mPiece();

        atRightCorner()
        cornerCutOut();

        atRightCorner()
        translate([R_X[4]+0,R_D/2,0])
        blancoSona6s();

        translate([(L_X[1]+L_X[0]+W)/2,600/2,0])
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
    OVERHANG=35;
    L_D37=D37+OVERHANG;
    L_D60=D60+OVERHANG;
    B_D=200;
    color([0,0,1])
    if($positive) {
        
        atRightCorner() {
           mPiece1(R_X[6]+W,R_D+OVERHANG); 
        }
        mPiece1(L_X[9]+OVERHANG,L_D37); 
        mPiece1(L_X[2],L_D60); 
        
/*        translate([L_X[1],L_D60,0])
        rotate(-45)
        mPiece2();*/
        R=60;
        hull() {
        translate([L_X[2],L_D60-R,0])
        cylinder(r=R,h=M_H);
        translate([L_X[3],L_D37-R,0])
        cylinder(r=R,h=M_H);
        translate([L_X[2],L_D37-R,0])
        cylinder(r=R,h=M_H);
        }
        

        ID=50;
        translate([-ID,0,0])
        mirror([1,0,0])
        rotate(90)
        mPiece1(BACK_WALL_WIDTH,ID+L_X[0]); 
        
    } else {
        atRightCorner() {
//            symX([-W-3,+W+3,0]) // FIXME: remove this
            for(p=[ [0,0,0], /*[-W-3,+W+3,0]*/ ])
                translate(p)
            linear_extrude(WALL_H,center=true)
            polygon(RIGHT_WALL_PROFILE);
            
        }
        
        window_p=460; // FIXME: dup
        window_w=960;
        
        WINDOW_PROFILE=prefix([0,-400],[[0,0],[0,400],[window_p,0],[0,-200],[   window_w,0],[0,200],
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

//mode="previewL";
mode="part-YZ_LI9";

if(mode=="preview") {
    walls("A");
    
    previewL();
    previewR();
    previewM();
}

$part=undef;
function defined(a) = a != undef;

if(mode == "part-YZ_LI9"){
    $part="YZ_LI9";
    
    projection(false)
    rotate(90,[0,1,0])
    previewL();
}

if(mode=="previewL") {
    walls("L");
    walls("B");
    previewL();
    previewM();
    previewLU();
    

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

if(mode=="test") {
    
}