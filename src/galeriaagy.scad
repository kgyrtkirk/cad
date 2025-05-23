use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>
use <syms.scad>

$close="";
$front=false;
$fronts=true;
$closeWFront=[1,1];
$closeWMain=[.4,2];
$defaultDrawer="smart";

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
MAT_SINK=40;
BED_FRAME_SP_UNDER=50;
BED_FRAME_H=BED_FRAME_SP_UNDER+MAT_SINK+$W;

BED_H=1600;
DEPTH=MAT_W+W+W;
STEP_W=400;
STEP_CNT=4;

BACK_L_WIDTH=STEP_W+400;



FOOT_A=120;

function step_depth(i) = (DEPTH-W)/STEP_CNT*i;
function step_w(i) = STEP_W-W;
function step_height(step_i) = BED_H-BED_H/(STEP_CNT+1)*step_i;


module lepcso() {
    
    translate([-STEP_W,W,0]) {
        for(step_i=[0:1:STEP_CNT]) {
            translate([0,0,step_height(step_i)])
            eXY(concat("step",step_i),step_w(step_i),step_depth(step_i));
            if(step_i==STEP_CNT) {
                eXY(concat("step",0),step_w(step_i),step_depth(step_i));
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

module builtinCabinet(name,w,h,d) {
    $name=name;
    $w=w;
    $h=h;
    $d=d;

    translate([$w-$W,0,$W])
    eYZ(concat(name,"side"),$d,$h-$W);
    translate([0,0,$h])
    children();
}

module galeriaAgy() {
    
    lepcso();
    
    translate([-BACK_L_WIDTH,0,0])
    eXZ("bHatso",BACK_L_WIDTH,BED_H);
    
    translate([-MAT_L-2*$W-STEP_W,0,BED_H]) {
        translate([MAT_L-100,0,0])  jointI();
        translate([MAT_L-300,0,0])  jointI();
        bedFrame("BED_U",MAT_L,MAT_W,BED_FRAME_H,MAT_SINK);
    }
    
    translate([-STEP_W-FOOT_A,DEPTH-W,0])
    eXZ("footLA",FOOT_A,BED_H);
    
    
    translate([-STEP_W-W,W,0])
    eYZp("stepR",[   
                        [step_depth(STEP_CNT),0],
                        [step_depth(STEP_CNT),step_height(STEP_CNT)+W],
                        [step_depth(1),step_height(1)+W],
                        [0,BED_H],
                        [0,step_height(1)]
    ] );


    translate([-W,W,step_height(4)])
    rotate(90,[0,0,1])
    builtinCabinet("c1",
        step_depth(2), step_height(STEP_CNT), step_w(2) )
        drawer(step_height(STEP_CNT)/2)
        drawer(step_height(STEP_CNT)/2);


    translate([-W,W,step_height(5)])
    rotate(90,[0,0,1])
    builtinCabinet("c2",
        step_depth(3), step_height(STEP_CNT), step_w(2) )
        drawer(step_height(STEP_CNT)/2)
        drawer(step_height(STEP_CNT)/2);

    
//    cabinet(name = "agy", w = 1800, h = 1600, d = 900);
}

posNeg() {
    galeriaAgy();
}

