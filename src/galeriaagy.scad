use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>
use <syms.scad>


// TODO
// ledcsik agy ala
// spotlampa valami
// kabel lejarat
// konnektor balra
// konnektor jobbra
// fiok overdrive vs lepcso


// H3433-ST22-18
// H309-ST12-18

// lampa
// https://fali-es-mennyezeti-lampa-csillar.arukereso.hu/rabalux/karen-5564-p778014348/?utm_source=google&utm_medium=organic&utm_campaign=dma#

// beszelni:

// rendelni
// zartszelveny
// fiokok
// fogantyuk



$connect=undef;
$mode="print";
$close="";
$front=false;
$fronts=true;
$handle="normal";
$closeWFront=[.4,2];
$closeWMain=[.4,2];
$defaultDrawer="smart";
$cornerProtect=false;
$smartOverdrive=false;

$jointsVisible=true;
$machines=true;
$openDoors=false;
$drawerState="CLOSED";
$drawerBoxes=false;

$part=undef;

W=18;
$W=18;

MAT_L=1800;
MAT_W=910;
MAT_D=100;
MAT_SINK=80-$W;
BED_FRAME_SP_UNDER=50;
BED_FRAME_H=BED_FRAME_SP_UNDER+$W+MAT_SINK;

BED_H=1500;
DEPTH=MAT_W+W+W;
STEP_W=500;
STEP_CNT=4;


LDESK_WIDTH = 400;   
LCAB_DEPTH = STEP_W -W + LDESK_WIDTH -W-W;


MAT_TOP_H= BED_H + BED_FRAME_SP_UNDER + $W + MAT_D;

FOOT_A=40;
FOOT_B=120;

DESK_H=700;
DESK_WW=2*$W;

STEP_TOP=BED_H+BED_FRAME_H;

STEP_THETA=.7;

DESK_W=890;
DESK_D=MAT_W+100;
DESK_RO=(DESK_W-FOOT_A)/2;

// right drawers
DRAWERS=[140,140,140,140];
T_DRAWERS=sum(DRAWERS)+$W;
DRAWER_W=250+82; //300
DRAWER_D=2*403+$W;//DESK_W-99;


function step_depth(i) = (DEPTH-W-W)/(STEP_CNT+STEP_THETA)*(i+STEP_THETA);
function step_alt(i) = i>=3;
function step_w(i) = STEP_W-W + (step_alt(i)?400:0);
function step_height(step_i) = STEP_TOP-STEP_TOP/(STEP_CNT+1)*step_i;
function step_d() = step_depth(1);

function sum(values) = values[0]==undef?0:values[0] + sum(sublist(values,1));


BACK_L_WIDTH=STEP_W+400 -2*W;
BACK_R_WIDTH=DRAWER_D/2+FOOT_A/2;

CORNER_ROUND=50;

module lepcso() {
    
    translate([-W,W,0]) {
        for(step_i=[1:1:STEP_CNT]) {
            hs=concat([step_height(step_i)], (step_i==STEP_CNT)?[0]:[]);

            for(h=hs)
            translate([-step_w(step_i),0,h])
            {
                n=str("step",h);
                if(step_alt(step_i)) {
                    $connect=[[ "l","TET"],["b","TET"]];
                    cutCornerShelf($close="FR", n, step_w(step_i),step_depth(step_i),     2*CORNER_ROUND,type="round");
                    
                } else {
                    $connect=[[ "l","TET"],["b","TET"],["r","TET"]];
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

module builtinCabinet(name,w,h,d,side="L",sideUp=$W) {
    $name=name;
    $w=w;
    $h=h;
    $d=d;

    wi=side=="L" ?  ($w-$W) : 0;

    // if(false)
    translate([wi,0,sideUp])
    eYZ($close="F",str(name,"side"),$d,$h-sideUp);

    for(y=[100,$d-100]) {
        translate([wi,y,0]) {
        joint("XZ",center=true);

        translate([0,0,$W+$h])
        rotate(180,[1,0,0]) 
        joint("XZ",center=true);
        }

    }

    translate([0,0,$h])
    children();
}

module foot(){
    eXZ("footRB",FOOT_B,BED_H);
}

module mirrorC() {

}

module doubleSided(a) {
    d0=$d;
    d1=$d*a;
    d2=$d*(1-a);

    translate($d=d1,[0,d0-d1,0]) 
    children(0);
    translate($d=d2, [$w,d2,0]) 
    rotate(180) 
    children(1);
    children(2);
}

module internalSeparator(ratio, height) {
    translate([$W,($d-$W)*ratio,-height+$W]) 
    eXZ(str($name,"intSep"),$w-$W-$W,height-$W-$W,$connect=[["l","TT"],["r","TT"],["f","TT"],["b","TT"]]);
    space($front=false,height)
    children();
}

module desk() {

    
    translate([0,DEPTH-FOOT_A,0])
    eXZ($W=FOOT_A,"ZARTSZELVENY", FOOT_A,BED_H);
    
    translate([FOOT_A/2-DESK_W/2,$W,DESK_H]) {
            cutCornerShelf($W=DESK_WW,"desk", DESK_W,DESK_D, DESK_RO,DESK_RO,type="round",$close="LRF");

        if(!$positive) {
            translate([DESK_W/2,40+20,0]) 
            cylinder(h=200,d=80,center=true);
        }
//        eXY("desk", DESK_W,DESK_D);
    }
    
    echo("t_drawers",T_DRAWERS);
    translate([-DRAWER_D/2+FOOT_A/2,DRAWER_W,0])
    rotate(-90)
    builtinCabinet("c3",DRAWER_W,DESK_H,DRAWER_D,"R",sideUp=0,$smartOverdrive=undef)
        fullBottom($front=true,DESK_H-T_DRAWERS+$W,external=true,$close="FB")
        space($front=false,-$W)
        doubleSided(.5,$DRAWER_WALL_W=10) {
            drawer(DRAWERS[0])
            drawer(DRAWERS[1])
            drawer(DRAWERS[2])
            drawer(DRAWERS[3]);
            drawer(DRAWERS[0])
            drawer(DRAWERS[1])
            drawer(DRAWERS[2])
            drawer(DRAWERS[3]);
            internalSeparator(.5,T_DRAWERS)
            fullBottom(0,external=true,$close="FB");
        }
    ;
    

}

RAIL_H=100;
RAIL_DECOR_H=160;
RAIL_DECOR_W=120;
RAIL_DECOR_DESIRED_SP=140;
RAIL_TOTAL_H=RAIL_DECOR_H+RAIL_H;


module rail(name, w, lEnd=false, rEnd=false,railClose="LFBR", railConnect="", RAIL_DECOR_DESIRED_SP=RAIL_DECOR_DESIRED_SP) {
    h=RAIL_H;
    translate([0,W,RAIL_DECOR_H])
    rotate(90,[1,0,0])

    cutCornerShelf($close=railClose, name, w, h, cL=lEnd?h:0, cR=rEnd?h:0, type="round", $connect=railConnect);

    iw = w + (!lEnd ? RAIL_DECOR_W/2 :0)+ (!rEnd ? RAIL_DECOR_W/2 :0);
    ix = !rEnd ? -RAIL_DECOR_W/2 : 0;

    d=(RAIL_DECOR_W + RAIL_DECOR_DESIRED_SP);
    n=floor((iw-RAIL_DECOR_W)/d);
    ad=(iw-RAIL_DECOR_W)/n;

    for(x=[ix:ad:iw]) {
    
        translate([x,0,0]) 
        if(x<0 || x+RAIL_DECOR_W>w) 
        translate([x<0?RAIL_DECOR_W/2:0,0,0]) 
        eXZ($front=true, $close="LRou",str("railDecHalf"),RAIL_DECOR_W/2,RAIL_DECOR_H, $connect=[]);
        else
        eXZ($front=true, $close="LRou",str("railDecFull"),RAIL_DECOR_W,RAIL_DECOR_H, $connect=[["f","cTT"],["b","cTT"]]);
    }

//    eYZ("BARR-I",I_W,I_H);
  //  eYZ($front=true,$close="FBLRou","BARR-I",I_W,I_H);
  
}

module agy() {

    bedFrame("Bed",MAT_L,MAT_W,BED_FRAME_H,MAT_SINK,backOversize=RAIL_TOTAL_H);
    translate([0,MAT_W+W,BED_FRAME_H])
    rail("railFront", MAT_L+W+W );

    translate([W,W,BED_FRAME_H])
    rotate(90) 
    rail(railClose="FB","railR", MAT_W ,railConnect=[["l","TET"],["r","TET"]]);

    OFF=400;
    translate([MAT_L+W+W,W+OFF,BED_FRAME_H])
    rotate(90) 
    rail(RAIL_DECOR_DESIRED_SP=RAIL_DECOR_DESIRED_SP/2, railClose="FBR","railL", MAT_W-OFF , rEnd=true,railConnect=[["l","TET"]]);

}

JOINT_LEN=80;
module polc(inter,over,depth) {

        if(over>0)
            eXZ("shelfBack",inter,100,$close="Ou");

        translate([-over,$W,0]) 
        cutCornerShelf("shelfXY",inter+2*over,depth,depth,depth,type="round",$close="LRF");
}

module polcok() {

    INTER=MAT_L+2*$W-(BACK_L_WIDTH+BACK_R_WIDTH-STEP_W);

    OVER=100;

    X0=-BACK_L_WIDTH-INTER;
    translate([X0,0,1050])
        polc(INTER,100,150);
    translate([X0,0,1300])
        polc(INTER,200,200);

    translate([X0,0,2000])
        polc(INTER,0,160);

    S1L=1000;
    S1D=150;
    S2L=1000;
    S2D=150;
    
    if(false)
    translate([-S1L,0,2300])
        cutCornerShelf("shelfS1",S1L,S1D,S1D,0,type="round",$close="LRF");

    if(false)
    translate([0,0,2000])
        rotate(90,[0,0,1]) 
        cutCornerShelf("shelfS2",S2L,S2D,0,S2D,type="round",$close="LRF");
}

module galeriaAgy() {
    
    lepcso();
    
    translate([-BACK_L_WIDTH,0,0])

    if(true)
        rotate(90, [1,0,0]) 
        translate([0,0,-$W]) 
        cutCornerShelf("bHatso", BACK_L_WIDTH,BED_H, cL=BED_H-step_height(1)-W, $close="FR");
    else
        eXZ("bHatso",BACK_L_WIDTH,BED_H);
    
    translate([-MAT_L-2*$W-STEP_W,0,BED_H]) {
        translate([MAT_L-100,0,0])  jointI();
        translate([MAT_L-300,0,0])  jointI();
        agy();
    }

//    slope=(step_depth(1)-step_depth(0))/(STEP_TOP-(step_height(1)+W));
    slope=(step_depth(3)-step_depth(1))/(step_height(3)-step_height(1));
    step_top_wi=step_depth(1)-W+(STEP_TOP-BED_H+W)*slope;
    
    slope2=1/slope;
    xw=step_top_wi*(slope2/(sqrt(1+slope2*slope2)));
    yw=(sqrt(1+slope2*slope2))*step_height(3);
    if($positive && false){
        // show stepR bounding box
    translate([-STEP_W-W,step_depth(0)+W,step_height(0)+W])
%    rotate(180+atan(-slope),[1,0,0]) 
        cube([30,-xw,yw]);
    }


    translate([-STEP_W-W,W,0])
    eYZp(str("stepRs"),[   
                        [step_depth(3)-step_top_wi,step_height(3)+W],
                        [step_depth(3),step_height(3)+W],
//                        [step_depth(1),step_height(1)+W],
                        [step_top_wi,BED_H],
                        [0,BED_H]
    ] );
    
    translate([-STEP_W-W,W,0])
    translate([0,step_depth(3)-JOINT_LEN,step_height(3)]) 
    jointsZY(100,center=true);

    translate([-STEP_W-W,W,0])
    translate([0,step_top_wi,BED_H])

    rotate(-90,[0,0,1])
    jointI();

    translate([-STEP_W-FOOT_B,DEPTH-W,0])
    foot($close="LRUo",$connect=[["b","bTIT"]]);
    
    translate([-STEP_W-W,W+step_depth(STEP_CNT-1),step_height(STEP_CNT)+W])
        eYZ("footI",DEPTH-step_depth(STEP_CNT-1)-W-W,BED_H-(step_height(STEP_CNT)+W), $close="Bou",$connect=[["f","eTIT"]]);

    UV=CORNER_ROUND+W;
    translate([-STEP_W-W,W+step_depth(STEP_CNT)-UV,W]) {
        eYZ("footJ",UV,step_height(STEP_CNT)-W, $close="f",$connect=[[ "l","TT"],["r","TT"]]);
    }


    translate([-STEP_W-W,W+step_depth(STEP_CNT-1)-UV,W+step_height(STEP_CNT)])
        eYZ("footJ",UV,step_height(STEP_CNT)-W, $close="f",$connect=[[ "l","TT"],["r","TT"]]);

        $floorW=10;
    
    translate([0,0,0])
    translate([-W,0,step_height(4)])
    rotate(90,[0,0,1]) {
        c1w=step_depth(3)-CORNER_ROUND;
        c1wa=c1w/2;
        c1wb=c1w-c1wa;
        $floorW=10;
    builtinCabinet("c1",
        c1w, step_height(STEP_CNT), LCAB_DEPTH,$smartOverdrive=true)
        drawer(step_height(STEP_CNT)/2)
        drawer(step_height(STEP_CNT)/2);
    }


    translate([-W,0,step_height(5)])
    rotate(90,[0,0,1]) {

        c2w=step_depth(4)-CORNER_ROUND+$W;
        c2wa=c2w/2;
        c2wb=c2w-c2wa;
        c2space=step_height(STEP_CNT)-$W;
        $floorW=10;

    builtinCabinet("c2a",
        c2wa, step_height(STEP_CNT), LCAB_DEPTH ,$smartOverdrive=true)
        drawer(c2space/2)
        drawer(c2space/2);
        translate([c2wa-$W,0,0]) 
    builtinCabinet("c2b",
        c2wb, step_height(STEP_CNT), LCAB_DEPTH ,$smartOverdrive=true)
        drawer(c2space/2)
        drawer(c2space/2);
    }


    translate([-STEP_W-MAT_L-2*$W,0,0]) {
        echo("DRAWER_D",DRAWER_D);
        
        translate([-DRAWER_D+BACK_R_WIDTH,0,0]) 
        eXZp("jHatso",
            [
                [0,-(DESK_H+DESK_WW)],
                [0,0],
                [DRAWER_D,0],
                [DRAWER_D,-BED_H],
                [DRAWER_D-BACK_R_WIDTH,-BED_H]
            ]);
        
//        BACK_R_WIDTH,BED_H,$close="LR");
//        eXZ("jHatso",BACK_R_WIDTH,BED_H,$close="LR");

        // d2= DRAWER_D - BACK_R_WIDTH;
        // translate([-d2,0,0]) 
        // rotate(90,[1,0,0]) 
        // translate([0,0,-$W]) 
        // cutCornerShelf(name = "jHatsoAsztal", w = d2, d = DESK_H+DESK_WW+d2, cR=d2);
//        eXZ("jHatsoAsztal",d2,DESK_H+DESK_WW+d2);
        
        desk();
    }


    polcok();

    translate([-MAT_L-STEP_W,0,1300]) 
    lampa();

    translate([-STEP_W-200,0,1300]) 
    lampa();

    translate([-MAT_L-STEP_W,0,2200]) 
    lampa();

    
//    cabinet(name = "agy", w = 1800, h = 1600, d = 900);
}


module lampa() {
    if($positive)
        echo(str("custom PART-lampa"));

    if($positive && $machines)
    cube(160);
}

module model() {
posNeg() {
    galeriaAgy();

}
}

mode="P-step0R100XY";
mode="P-stepLeftYZ";
mode="P-stepRsYZ";
mode="P-step1304XY";
mode="P-step978XY";
mode="P-step652R100XY";
mode="P-step326R100XY";
mode="P-c1sideYZ";
mode="P-c2asideYZ";
mode="P-c2bsideYZ";
mode="P-c3sideYZ";
mode="PXZ-railFrontXY";
//mode="P-c3intSepXZ";
mode="print";
if(mode == "print") {

s=($mode == "print")?.05:1;
scale([1,1,1]*s) {
    
model();
    
    translate([-1400,400,0])
    %cylinder(d=750,h=900);
}

//    if(!$positive) {        cube([1000,1000,4000],center=true);    }
//    if(!$positive) {        cube([10000,200,4000],center=true);    }
    



} else 
//lse 
 if(mode[0] == "P" && mode[1]=="-") {
    $fronts=false;
    $machines=false;
    $jointsVisible=false;
    
    $part=substr(mode,2);
    
    projection(false)
   orient(mode)
//    rotate(90,[0,1,0]) 
        model();
//        previewLU();
}

 if(mode[0] == "P" && mode[1]=="X"&& mode[2]=="Z"&& mode[3]=="-") {
    $fronts=false;
    $machines=false;
    $jointsVisible=false;
    
    $part=substr(mode,4);
    
    projection(false)
   orient("XZ")
//    rotate(90,[0,1,0]) 
        model();
//        previewLU();
}



echo ("matTopH",MAT_TOP_H);
echo ("ss",step_height(4));
