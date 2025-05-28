use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>
use <syms.scad>

// TODO
// polcok
// zartszelvenylab
// felso korlat
// osztott fiok?
// lekerekitetett bal felso hatlap?
// polcok az asztalra / diszites hatra
// hatso fiok v valami


$mode="print";
$close="";
$front=false;
$fronts=true;
$handle="normal";
$closeWFront=[1,1];
$closeWMain=[.4,2];
$defaultDrawer="smart";
$cornerProtect=false;

$jointsVisible=true;
$machines=true;
$openDoors=false;
$drawerState="CLOSED";
$drawerBoxes=true;

$defaultDrawer="smart";

$part=undef;

W=18;
$W=18;

MAT_L=1800;
MAT_W=810;
MAT_D=100;
MAT_SINK=80-$W;
BED_FRAME_SP_UNDER=50;
BED_FRAME_H=BED_FRAME_SP_UNDER+$W+MAT_SINK;

BED_H=1600;
DEPTH=MAT_W+W+W;
STEP_W=400;
STEP_CNT=4;

BACK_L_WIDTH=STEP_W+400;
BACK_R_WIDTH=400;

LDESK_WIDTH = 400;   
LCAB_DEPTH = STEP_W -W + LDESK_WIDTH -W-W;


FOOT_A=120;

DESK_H=700;

STEP_TOP=BED_H+BED_FRAME_H;

STEP_THETA=.7;

function step_depth(i) = (DEPTH-W-W)/(STEP_CNT+STEP_THETA)*(i+STEP_THETA);
function step_alt(i) = i>=3;
function step_w(i) = STEP_W-W + (step_alt(i)?400:0);
function step_height(step_i) = STEP_TOP-STEP_TOP/(STEP_CNT+1)*step_i;
function step_d() = step_depth(1);

CORNER_ROUND=50;

module lepcso() {
    
    translate([-W,W,0]) {
        for(step_i=[1:1:STEP_CNT]) {
            
            hs=concat([step_height(step_i)], (step_i==STEP_CNT)?[0]:[]);

            for(h=hs)
            translate([-step_w(step_i),0,h])
            {
                n=concat("step",h);
                if(step_alt(step_i)) {
                cutCornerShelf($close="FR", n, step_w(step_i),step_depth(step_i),     2*CORNER_ROUND,type="round");
                    
                } else {
                    eXY($close="F", n,step_w(step_i),step_depth(step_i));
                }
            }
        }
    }
    
    translate([-W,W,0])
    eYZp("stepLeft",[   [0,0],
                        [step_depth(STEP_CNT),0],
                        [step_depth(STEP_CNT),step_height(STEP_CNT)+W],
                        [step_depth(1),step_height(1)+W],
                        [0,step_height(1)+W]
    ] );
    
}

module builtinCabinet(name,w,h,d,side="L") {
    $name=name;
    $w=w;
    $h=h;
    $d=d;

    wi=side=="L" ?  ($w-$W) : 0;

    translate([wi,0,$W])
    eYZ($close="F",concat(name,"side"),$d,$h-$W);
    translate([0,0,$h])
    children();
}

module foot(){
    eXZ("footRA",FOOT_A,BED_H);
}


module desk() {

DESK_W=800;
DESK_D=900;
    DESK_RO=(DESK_W-FOOT_A)/2;
    
    translate([0,DEPTH-W,0])
    foot();
    
    translate([FOOT_A/2-DESK_W/2,0,DESK_H]) {
            cutCornerShelf($W=2*W,"desk", DESK_W,DESK_D, DESK_RO,DESK_RO,type="round");
//        eXY("desk", DESK_W,DESK_D);
    }
    
    DRAWER_W=300;
    DRAWER_D=370;
    translate([0,DRAWER_W,0])
    rotate(-90)
    builtinCabinet("c3",DRAWER_W,DESK_H,DRAWER_D,"R")
        shelf($front=true,160+$W,external=true)
        space($front=false,-$W)
        drawer(160)
        drawer(160)
        drawer(160)
        shelf(0,external=true)
    ;
    

}

RAIL_H=80;
RAIL_DECOR_H=80;
RAIL_DECOR_W=80;
RAIL_DECOR_DESIRED_SP=100;
RAIL_TOTAL_H=RAIL_DECOR_H+RAIL_H;


module rail(name, w, lEnd=false, rEnd=false,railClose="LFR") {
    h=RAIL_H;
    translate([0,W,RAIL_DECOR_H])
    rotate(90,[1,0,0]) 
    cutCornerShelf($close=railClose, name, w, h, cL=lEnd?h:0, cR=rEnd?h:0, type="round");

    iw = w + (!lEnd ? RAIL_DECOR_W/2 :0)+ (!rEnd ? RAIL_DECOR_W/2 :0);
    ix = !rEnd ? -RAIL_DECOR_W/2 : 0;

    d=(RAIL_DECOR_W + RAIL_DECOR_DESIRED_SP);
    n=floor((iw-RAIL_DECOR_W)/d);
    ad=(iw-RAIL_DECOR_W)/n;

    for(x=[ix:ad:iw]) {
    
        translate([x,0,0]) 
        if(x<0 || x+RAIL_DECOR_W>w) 
        translate([x<0?RAIL_DECOR_W/2:0,0,0]) 
        eXZ($front=true, $close="LR",concat(n,i),RAIL_DECOR_W/2,RAIL_DECOR_H);
        else
        eXZ($front=true, $close="LR",concat(n,i),RAIL_DECOR_W,RAIL_DECOR_H);
    }

//    eYZ("BARR-I",I_W,I_H);
  //  eYZ($front=true,$close="FBLRou","BARR-I",I_W,I_H);
  
}

module agy() {

    

    bedFrame("BED_U",MAT_L,MAT_W,BED_FRAME_H,MAT_SINK,backOversize=RAIL_TOTAL_H);
    translate([0,MAT_W+W,BED_FRAME_H])
    rail("railF", MAT_L+W+W );

    translate([W,W,BED_FRAME_H])
    rotate(90) 
    rail(railClose="F","railR", MAT_W );

    OFF=400;
    translate([MAT_L+W+W,W+OFF,BED_FRAME_H])
    rotate(90) 
    rail(railClose="FR","railL", MAT_W-OFF , rEnd=true);

}

module galeriaAgy() {
    
    lepcso();
    
    translate([-BACK_L_WIDTH,0,0])
    eXZ("bHatso",BACK_L_WIDTH,BED_H);
    
    translate([-MAT_L-2*$W-STEP_W,0,BED_H]) {
        translate([MAT_L-100,0,0])  jointI();
        translate([MAT_L-300,0,0])  jointI();
        agy();
    }


    translate([-STEP_W-W,W,0])
    eYZp("stepR",[   
                        [step_depth(2),step_height(3)],
                        [step_depth(3),step_height(3)+W],
                        [step_depth(1),step_height(1)+W],
                        [step_depth(0)+(STEP_TOP-BED_H)*(step_depth(1)-step_depth(0))/(STEP_TOP-(step_height(1)+W)),BED_H],
                        [0,BED_H],
                        [0,step_height(1)]
    ] );

    translate([-STEP_W-FOOT_A,DEPTH-W,0])
    foot($close="LRU");
    
    translate([-STEP_W-W,W+step_depth(STEP_CNT-1),step_height(STEP_CNT)+W])
        eYZ("footI",DEPTH-step_depth(STEP_CNT-1)-W-W,BED_H-(step_height(STEP_CNT)+W));

    


    translate([0,0,0])
    translate([-W,W,step_height(4)])
    rotate(90,[0,0,1])
    builtinCabinet("c1",
        step_depth(3)-CORNER_ROUND, step_height(STEP_CNT), LCAB_DEPTH )
        drawer(step_height(STEP_CNT)/2)
        drawer(step_height(STEP_CNT)/2);


    translate([-W,W,step_height(5)])
    rotate(90,[0,0,1])
    builtinCabinet("c2",
        step_depth(4)-CORNER_ROUND, step_height(STEP_CNT), LCAB_DEPTH )
        drawer(step_height(STEP_CNT)/2)
        drawer(step_height(STEP_CNT)/2);


    translate([-STEP_W-MAT_L-2*$W,0,0]) {
        
        eXZ("jHatso",BACK_R_WIDTH,BED_H);
        
        desk();
    }


    
//    cabinet(name = "agy", w = 1800, h = 1600, d = 900);
}


s=($mode == "print")?.05:1;
scale([1,1,1]*s)
posNeg() {
    galeriaAgy();
    
    translate([-1400,400,0])
    %cylinder(d=750,h=900);
}

