use <syms.scad>

MUNKALAP_SP=6;
MAIN_H=800;
IBEAM_Z=[0,0,60];

$fronts=true;
$machines=true;

M_H=30;

M_H_TOP=MAIN_H+IBEAM_Z[2]+M_H;

module atLeftWall(x) {
    translate();
}

WALL_THICK=70;          //*
WALL_H=2610;//; 1695+915;        //* w/o laminate
HW_H=1235;              //* w/o laminate
HW_WIDTH=2075-30+12+20;       //*
FWL_WIDTH=600+110;          //*
BACK_WALL_WIDTH=1940;   //* 

// a kozepso oszlopos szar netto melysege
WALL_IX=335;            // FIXME ez jo?

LEFT_WALL_WIDTH=HW_WIDTH+FWL_WIDTH;

FUGGO_KIMARAS=10;

function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

RIGHT_WALL_DELTA=[
    [0,0],
//    [1925+18,0], //*?
    [1925+18+FUGGO_KIMARAS,0], // right now there is +11
//    [135+1755+42+18,0], //*?
    [0,WALL_IX],
    [625-18-FUGGO_KIMARAS,0],
    [0,-WALL_IX+50],
    [660+480+420+40,0],
    [0,-10],
    [-(660+480+420+40),0],
    [0,-50],
];

RIGHT_WALL_PROFILE=prefix([0,0],RIGHT_WALL_DELTA);

GAZELZARO_POS=[50,255,700];

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
        D=85;
        if(false)
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
    translate(GAZELZARO_POS)
    sphere(d=70);

    translate([15,800,0])
    rotate(90)
    radiator();
    
    window_pos=[0,460,885];
    window_w=985;
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


DRU=400;
D37=366;
D60=590; //?


MAXIMERA_D60_MIN_DEPTH=590-30;

SLIDE_LOSS=50;
R_D=MAXIMERA_D60_MIN_DEPTH+SLIDE_LOSS; // right under depth

L_W=[110,M60W,W,D60-D37+W,W,M60W,W,M60W,W,M60W];

L_X=prefix(0,L_W);

echo("L_X",L_X);


//2670
R1W=150-18;    R1X=0;//-R1W;
R2W=600;    R2X=R1X+R1W;
R3W=600;    R3X=R2X+R2W;
R4W=600;    R4X=R3X+R3W;

R_W=[0,150-W-W/2-5-8,M60W,600+W+5,M60W,W+2,W,RIGHT_WALL_DELTA[3][0],W,W,M60W,W,M60W];
echo("RW1",R_W[1]);

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
    ppp(str("P-XY_",name))
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



module positiveAt(p) {
    if($positive) {
        translate(p)
            children();
    }
}

module IbeamX(name, x, depth, height=MAIN_H) {
    ppp(str("P-YZ_",name))
        baseI(x,depth,height);
}
module IbeamY(name, x, depth, height=MAIN_H) {
    ppp(str("P-YZ_",name))
        translate([x,0,0])
        cube([depth,W,height]);
}


module hbeam(name,width,depth) {
    ppp(str("P-XY",name))
        translate([W,0,0])
        cube([width,depth,W]);
}

module Ibeam(x,depth){
    $width=depth;
    $height=MAIN_H;
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

module doors(w,h,d,cnt=2) {
    FRONT_SP=3;
    
    
    cL=[w/4,W/2,h/2];
    cR=cL+[w/2,0,0];
    translate([0,d,0])
    if($positive) {
        if($fronts)
            
        color([0,1,1]){
            if(cnt==2) {
                ww=w/2-FRONT_SP;
                hh=h-FRONT_SP;
                translate(cL)
                cube([ww,W,hh],center=true);
                translate(cR)
                cube([ww,W,hh],center=true);
                echo("__DOOR: ",ww,hh);
                echo("__DOOR: ",ww,hh);
            }else{
                ww=w-FRONT_SP;
                hh=h-FRONT_SP;
                translate((cL+cR)/2)
                cube([ww,W,hh],center=true);
                echo("__DOOR: ",ww,hh);
            }
        }
    }else{
        
    }
}

module doors2(w,h,d,cnt=2) {
    
    translate([0,0,-h])
        doors(w,h,d,cnt);
    
    translate([0,0,-h])
        children();
    
}

module previewLU() {
    
    POS_Y=1650;
    
    WIDTH=L_X[1]-W;
    D45=450;
    SH=SYSTEM_H-POS_Y;
    posNeg() {
        translate([0,0,POS_Y]) {
            
            baseL(W,WIDTH,D45);
            translate([0,0,SH-W])
            baseL(W,WIDTH,D45);

            baseI(0,D45,SH);
            baseI(WIDTH+W,D45,SH);

            translate([(L_X[0]+L_X[1])/2,D45/2,0])
            vent();
            
            doors(WIDTH+2*W,SH,D45);
        }
    }
    
}
module previewL() {
    translate(IBEAM_Z)
    posNeg() {
        
        if(!$positive) {
            translate(GAZELZARO_POS-IBEAM_Z)
            rotate(90,[0,1,0])
            cylinder(d=102,h=1000,center=true);
        }
        
        baseL2("U1",L_X[4]+W,M60I);
        baseL2("U2",L_X[6]+W,M60I);
        baseL2("U3",L_X[8]+W,M60I);
        for(i=[3:len(L_X)-1])
        IbeamX(str("LI",i),L_X[i],D37);
        IbeamX("LJ0",L_X[0],D60);
        IbeamX("LJ1",L_X[1],D60);
        IbeamX("LJ2",L_X[2],D60);
        
        translate([L_X[8],0,MAIN_H])
            m60i(125)
            m60a(250)
            m60i(250)
            m60a(550)
        ;
        
        translate([L_X[6],0,MAIN_H])
            m60i(125)
            m60a(250)
            m60i(200)
                m60a(550)
        ;

        translate([L_X[4],0,MAIN_H])
            microWave()
            m60a(MAIN_H-460)
        ;
        if($machines && $positive) {
            // kestarto
            KESTARTO_DIM=[400,5,40];
            translate([(L_X[0]+L_X[1])/2,KESTARTO_DIM[1]/2,1200])
            cube(KESTARTO_DIM,center=true);
        }

        translate([L_X[0],0,MAIN_H])
            oven()
            m60b(200)
        ;
        
        baseX("X1",L_X[2]+W,D60-D37);
        translate([0,0,400])
        baseX("X2",L_X[2]+W,D60-D37);
        
        
        translate([L_X[2],D60,0])
        rotate(-45,[0,0,1])
        translate([W/4,0,0])
        doors((D60-D37)*sqrt(2),800,W,cnt=1);

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


F_DELTA=[ R_X[1]+W,M60W+5,W,M60W,W,M60W,W ];

F_X=prefix(0,F_DELTA);

//F_X=[R_X[1]+W];

FUSZER_Q=200;      //  fuszerpolc mag
FUSZER_P=D37-FUSZER_Q;    //  fuszerpolc melyseg
//FUSZER_L=F_X[3]-F_X[0]-W;
FUSZER_L=1150;


module fuszerPolc(){
//        translate([0,250,0])
        if($positive) {
                intersection() {
                    cube([FUSZER_L,FUSZER_P,M_H]);
                    hull() {
                        R=FUSZER_P/2;
                        cube([FUSZER_L/2,FUSZER_P*3,M_H*3],center=true);
                        translate([FUSZER_L-R,FUSZER_P-R,0])
                        cylinder(r=R,h=M_H*3,center=true);
                        translate([FUSZER_L-R,0,0])
                        cube([R,FUSZER_P-R,M_H]);
                    }
                }
        }
}

module previewRU() {
    
    module cBeam(name,xarr) {
        ppp(name) {
            positiveAt([W,0,0]) {
            color([.5,.5,1]) {
                hull() {
                    for(x=xarr) {
                        translate([x[0],0,0])
                        cube([.01,x[1],W]);
                    }
                }
            }
        }

        }
    }

    module cupBoard(depth,height,width,loss) {
        IbeamX("CB_LEFT",0,loss,height);
        IbeamX("CB_RIGHT",width-W,depth,height);
        IbeamY("CB_BACK",W,width-2*W,height);
        
        for(z=[0:3])
            translate([0,W,z*(height-W)/3])
        cBeam("CB_P",[[0,loss-W],[depth-loss,depth-W],[width-W-W,depth-W]]);
        translate([depth-loss+W,0,0])
        doors(width-(depth-loss)-W,height,depth,cnt=1);

        rotate(45,[0,0,1])
        translate([loss-6,0,0])
        doors((depth-loss)*sqrt(2),height,loss/2,cnt=1);
    }
    
    OO_H=100;   //  IX box cover
    
    Z0=IBEAM_Z[2] + MAIN_H + M_H;
    Z1=Z0+400;
    Z2=Z1+FUSZER_Q;
    Z3=Z0+OO_H;
    
    
    atRightCorner()
    posNeg() {
        translate([0,0,Z0]) {
            HH=SYSTEM_H-Z0+IBEAM_Z[2]; // FIXME: system_h misalignment
            IbeamX("K1",F_X[0], DRU,HH);
        }
        if(false)
        translate([0,0,Z1]) {
            HH=SYSTEM_H-Z1;
            IbeamX("K3",F_X[3], DRU,HH);
            if(!$positive) {
                translate([F_X[3]-.5,FUSZER_P,0])
                rotate(-45,[1,0,0])
                cube([W+1,1000,1000]);
            }
        }
        translate([0,0,Z2]) {
            HH=SYSTEM_H-Z2+IBEAM_Z[2];
            IbeamX("K3",F_X[3], DRU,HH);
            IbeamX("K2",F_X[1], DRU,HH);
            IbeamX("K2",F_X[2], DRU,HH);
            IbeamX("K3",F_X[4], DRU,HH);
            IbeamX("K3",F_X[5], DRU,HH);

            translate([F_X[0],0,0])
            doors(F_X[1]+W-F_X[0],HH,DRU);
            translate([F_X[2],0,0])
            doors(F_X[3]+W-F_X[2],HH,DRU);
            translate([F_X[4],0,0])
            doors(F_X[5]+W-F_X[4],HH,DRU);

        }
        translate([F_X[0]+W,0,Z1]) {
            fuszerPolc();
        }
        
        translate([0,0,Z0])
        IbeamX("IY-6",R_X[6],WALL_IX,SYSTEM_H-M_H_TOP+IBEAM_Z[2]);
        
        translate([0,WALL_IX,Z0])
        IbeamY("IY-6",R_X[6],R_X[7]-R_X[5],OO_H);

        translate([1.5,WALL_IX,Z3+1.5])
        IbeamY("IY-6",R_X[6],R_X[7]-R_X[5]-3,Z2-Z3-3);
        
        
        
        translate([R_X[6],WALL_IX,Z2])
        cupBoard(depth=R_D-WALL_IX,height=SYSTEM_H-Z2+IBEAM_Z[2],width=R_X[7]-R_X[5],loss=DRU-WALL_IX);
        
        
    }
}
module previewR() {
    
    atRightCorner() {
    translate(IBEAM_Z)
    posNeg() {
        for(i=[1:4]) 
            IbeamX(str("RC",i),R_X[i], R_D);
        
        // IX box
        translate([0,WALL_IX+W,0]) {
            for(i=[5]) 
                IbeamX(str("RD",i),R_X[i], R_D-WALL_IX-W);
            baseL(R_X[5]+W, R_X[6]-R_X[5]-W,R_D-WALL_IX-W);
        }
        baseL(R_X[1]+W,M60I,R_D);
        baseL(R_X[3]+W,M60I,R_D);
        

        
        translate(-IBEAM_Z) {

            IbeamX("IX-5",R_X[5],WALL_IX,853);
            IbeamX("IX-6",R_X[6],WALL_IX,853);

//            baseI(R_X[6],WALL_IX,SYSTEM_H+IBEAM_Z[2]);
            baseI(R_X[8],R_D,SYSTEM_H+IBEAM_Z[2]);
            
            
            translate([R_X[2]+W,0,0])
            dishwasher();
        }
        
            {
            $boxDepth=R_D; 
            translate([R_X[1],0,MAIN_H])
                m60c(250)
                m60i(250)
                m60c(550)
            ;
            translate([R_X[3],0,MAIN_H])
                m60c(MAIN_H)
            ;

            }
            
            translate([R_X[5],0,0])
                doors(R_X[8]-R_X[5],MAIN_H,R_D);
            ;
            
            echo("DDDDDDDDDDDDDD",R_X[8]-R_X[5]);
            
        R_D2=R_D-SLIDE_LOSS;
        translate([0,SLIDE_LOSS,0]) {
            translate(-IBEAM_Z) 
            translate([R_X[8]+W,0,0])
            fridge();
            baseI(R_X[11],R_D2,SYSTEM_H);
            baseI(R_X[12],R_D2,SYSTEM_H);
            
            OVER_FRIDGE_Z=1600-IBEAM_Z[2];
            OVER_FRIDGE_H=SYSTEM_H-OVER_FRIDGE_Z;
            translate([0,0,OVER_FRIDGE_Z]) {
                baseI(R_X[9],R_D2,OVER_FRIDGE_H);
                baseI(R_X[10],R_D2,OVER_FRIDGE_H);
                
                baseL(R_X[9]+W,M60I,R_D2);
                translate([0,0,OVER_FRIDGE_H-W])
                baseL(R_X[9]+W,M60I,R_D2);
                translate([0,0,OVER_FRIDGE_H/2-W/2])
                baseL(R_X[9]+W,M60I,R_D2);
            }
            baseL(R_X[11]+W,M60I,R_D2);

            $depth=R_D2; 
            $boxDepth=R_D2;
            
            translate([R_X[8]+W,0,SYSTEM_H])
                doors2(600,SYSTEM_H-OVER_FRIDGE_Z,R_D2);
            ;

            
//            PEEK_H=1400;
            PEEK_H=SYSTEM_H-OVER_FRIDGE_H;
            echo("PEEK_H",PEEK_H);
            translate([R_X[10]+W,0,SYSTEM_H])
                doors2(600,SYSTEM_H-PEEK_H,R_D2)
//                m60b(140)
                m60c(150+140)
                m60c(150)
                m60c(150)
                m60c(150)
                m60c(150)
                m60c(150)
                m60c(200)
                m60c(300)
            ;
            
            translate([R_X[10]+W,1,PEEK_H])
                doors2(600,PEEK_H,R_D2,cnt=1);
            
        }
        
    }
    }
}


module roundedCutShape(w,h,d,r) {
        hull()
        symX([(w-2*r)/2,0,0])
        symY([0,(h-2*r)/2,0])
        cylinder(r=r,h=d,center=true);
}




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

    mainBowlPos=[-M2_X,0,-190/2+5];
    secBowlPos=[-M1_X,0,-100/2+5];
    
    
    // bowl dist: around 545 use 550
    q=(M1_X-M2_X)+(M1_W+M2_W)/2;
//    assert(q==550,str("q is ",q))    ;

    if($positive){
        if($machines) {
            translate([0,0,M_H]) 
            { 
                translate([38,0,0])
                sphere(10);
                difference() {
                    union() {
                        translate([-A_W/2,0,0])
                        roundedCutShape(A_W,A_H,11,15);
                        translate(mainBowlPos)
                        roundedCutShape(M2_W,M2_H,190,15);
                        translate(secBowlPos)
                        roundedCutShape(M1_W+10,M1_H,100,15);
                        translate(secBowlPos-[0,0,M1_H/2])
                        cylinder(d=159,h=318,center=true);
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

        translate(secBowlPos)
            roundedCutShape(M1_W,M1_H,100,15);

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
    S_W=590;
    S_D=520;
    if($positive) {
        if($machines) {
            translate([0,0,M_H])
            roundedCutShape(S_W,S_D,M_H+1,5);
            roundedCutShape(S_W,S_D,M_H+1,5);
            color([.5,.5,1])
            roundedCutShape(20,480+2*60,M_H*3,5);
        }
    }else{
        translate([0,0,M_H/2])
        roundedCutShape(560,490,M_H+1,M_H);
    }
}


module cornerCutOut() {
    C_W=R_X[1];
    
    if($positive) {
    }else{
        roundedCutShape(2*C_W,D37*2,M_H*3,5);
    }
}

module mAssembly() {
    translate([0,0,860])
    posNeg() {
        mPiece();

        atRightCorner()
        cornerCutOut();

        atRightCorner()
        translate([R_X[4]+W,R_D60/2+15,0])
        blancoSona6s();

        translate([(L_X[1]+L_X[0]+W)/2,600/2+10+10,0])
        fozoLap();
        
    }
}

    OVERHANG=35;
    L_D37=D37+OVERHANG;
    L_D60=D60+OVERHANG;
    R_D60=R_D+OVERHANG;


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
    B_D=200;
    color([0,0,1])
    if($positive) {
        
        atRightCorner() {
           mPiece1(R_X[7]+W,R_D60); 
        }
        mPiece1(L_X[9]+OVERHANG,L_D37); 
        mPiece1(L_X[2],L_D60); 
        
/*        translate([L_X[1],L_D60,0])
        rotate(-45)
        mPiece2();*/
        R=60;
        hull() {
        translate([L_X[2]+W/2,L_D60-R,0])
        cylinder(r=R,h=M_H);
        translate([L_X[3]-W/2,L_D37-R,0])
        cylinder(r=R,h=M_H);
        translate([L_X[2],L_D37-R,0])
        cylinder(r=R,h=M_H);
        }
        

        ID=90;
        translate([-ID,0,0])
        mirror([1,0,0])
        rotate(90)
        mPiece1(BACK_WALL_WIDTH,ID+L_X[0]); 
        
    } else {
       atRightCorner() {
            if(false)
            for(p=[ [0,0,0], /*[-W-3,+W+3,0]*/ ])
                translate(p)
            linear_extrude(WALL_H,center=true)
            polygon(RIGHT_WALL_PROFILE);
            
            translate([R_X[6]+W/2,-W/2,-100])
            cube([W+660,WALL_IX+W,200]);
            
        }
        
        window_p=460; // FIXME: dup
        window_w=950;
        window_g1=80;
        window_g2=90;
        window_s=(985-950)/2;
        
        WINDOW_PROFILE=prefix([0,-400],
        [
            [0,0],[0,400],
            [window_p,0],
            [window_s,-window_g1],
  //          [0,-200],
            [   window_w,-(window_g2-window_g1)],
//          [0,200],
            [window_s,window_g2],
            [2000,0],[0,-400]]
        );
        echo(WINDOW_PROFILE);

        for(x=[MUNKALAP_SP/2,-MUNKALAP_SP/2])
        translate([MUNKALAP_SP,x,0])
        rotate(-90)
        mirror([1,0,0])
        linear_extrude(WALL_H,center=true)
        polygon(WINDOW_PROFILE);
        
        
    }
    

}

module previewM() {
    mAssembly();
}

module previewLT() {
//    HW_WIDTH=2075-30+12;       //*
//  FWL_WIDTH=600+100;          //*
    X1=FWL_WIDTH;
    X2=X1+HW_WIDTH;
    
    echo(X1);
    echo(X2);
    echo("x",X2-(X1+Q/2));

    Q=350;
    S=100;
    if($positive) {
    translate([0,0,HW_H]) {
            hull() {
                translate([X2,-WALL_THICK/2,0])
                cylinder(h=M_H,d=Q);
                translate([X1+Q/2,-WALL_THICK/2,0])
                cylinder(h=M_H,d=Q);
            }
//            translate([0,-WALL_THICK-S,0])
  //          cube([1000,S,M_H]);
                
    //            translate([0,-WALL_THICK-Q,0])
      //          roundedCutShape(3*FWL_WIDTH,Q-S,2*M_H+1,200);
        }
    }else {
        hull()
            for(x=[X1+Q/2,X2])
            translate([x,-WALL_THICK/2+Q/2-60,0])
            cube([.1,13.1,2000]);
    }
}


mode="preview";
//mode="P-YZ_LI9";
//mode="F-A_125";
//mode="P-XY_U3";


if(mode=="preview") {
    walls("A");
    
    previewL();
    previewR();
    previewM();
    previewLU();
    posNeg()
    previewLT();
    previewRU();
}

$part=undef;
function defined(a) = a != undef;

module orient(mode) {
    if(mode[2]=="X" && mode[3] =="Y") {
        children();
    } else if(mode[2]=="X" && mode[3] =="Z") {
        rotate(99,[0,1,0])
        children();
    } else if(mode[2]=="Y" && mode[3] =="Z") {
        rotate(180,[0,0,1])
        rotate(90,[0,1,0])
        children();
    } else {
        error("x");
    }

}


function substr(data, i, length=0) = (length == 0) ? _substr(data, i, len(data)) : _substr(data, i, length+i);
function _substr(str, i, j, out="") = (i==j) ? out : str(str[i], _substr(str, i+1, j, out));


if(mode[0] == "F" && mode[1]=="-") {
    $fronts=true;
    $machines=false;
    echo(mode);
    size=toInt(substr(mode,4));
    projection()
    rotate(90,[1,0,0])
    posNeg()
    m60a(size);
}

if(mode[0] == "P" && mode[1]=="-") {
    $fronts=false;
    $machines=false;
    
    $part=mode;//substr(mode,2);
    
    projection(false)
    orient(mode)
//    rotate(90,[0,1,0])
    previewL();
}

if(mode=="previewL") {
    walls("L");
    walls("B");
    previewL();
    previewM();
    previewLU();
    posNeg()
    previewLT();
    

}
if(mode=="previewR") {
    walls("R");
    walls("B");
    previewR();
    previewRU();
    previewM();
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
    $machines=false;
    projection()
    mAssembly();
}

if(mode=="mFuszer") {
    projection()
    atRightCorner()
    posNeg()
    fuszerPolc();
}
if(mode=="mFelso") {
    projection()
    posNeg()
    previewLT();
}

echo("rx0",R_X[1]);
echo("lx0",L_X[0]);
echo("lx0",FUSZER_P);

