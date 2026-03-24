use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>
use <syms.scad>


// TODO
// ledcsik agy ala

// H3433-ST22-18
// H309-ST12-18

// lampa
// https://fali-es-mennyezeti-lampa-csillar.arukereso.hu/rabalux/karen-5564-p778014348/?utm_source=google&utm_medium=organic&utm_campaign=dma#

// beszelni:

// rendelni
// fiokok
// fogantyuk



// PK-L-H45-600

$connect=undef;
$mode="print";
$close="";
$front=false;
$fronts=true;
$handle="normal";
$closeWFront=[.4,2];
$closeWMain=[.4,2];
$defaultDrawer="std";
$cornerProtect=false;
$smartOverdrive=false;

$jointsVisible=false;
$machines=true;
$openDoors=true;
$drawerState="OPEN";
$drawerBoxes=true;

$part=undef;


$floorW=10;
$DRAWER_WALL_W=10;

W=18;
$W=18;

module builtinCabinet(name,w,h,d,side="L",sideUp=$W) {
    $name=name;
    $w=w;
    $h=h;
    $d=d;

    wi=side=="L" ?  ($w-$W) : 0;

    // if(false)
    translate([wi,0,sideUp])
    eYZ($close="F",str(name,"side"),$d,$h-sideUp);

    for(y=[120,$d-120]) {
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
    eXZ(str($name,"intSep"),$w-$W-$W,height-$W-$W,$connect=[["l","cTT"],["r","cTT"],["f","cTT"],["b","cTT"]]);
    space($front=false,height)
    children();
}


// 2620
REAL_MAX_H=2620;
FOOT=72;
MAX_H=REAL_MAX_H-FOOT-30; // foot not included!
DEPTH=630;
module actor() {
    HEIGHT=1700;
    H_SIZE=200;
    translate([0,0,HEIGHT-H_SIZE/2]) 
        sphere(d=H_SIZE);
    cylinder(HEIGHT, d = H_SIZE/2);
    children();
}

module air_filter() {
    translate([0,0,$W+1]) {
    translate([500,0,0]) 
    cube([240,240,540]);
    }
    children();
}
module fdm_printer() {
    translate([0,0,$W]) {
    cube([392,406,478]);
    translate([0,0,478]) 
    cube([372,280,226]);
    translate([0,0,478]) 
    cube([372,180,380]);
    cube([372,80,860]);
    }
    children();
}

module szekreny() {
    A1_H=1500;
    A2_H=MAX_H-A1_H;
    U_SIZE=A2_H;
    W_A=800;
    W_B=800;


    cabinet(name = "cAA", w = W_A, h = A1_H, d = DEPTH,foot=FOOT,back=["internal",8]){ 
        cTop()
        drawer(h = 250)
        drawer(h = 250)
        drawer(h = 100)
        drawer(h = 250)
        drawer(h = 250)
        drawer(h = 400, bottomDrawer=true);
    };

    translate([0,0,A1_H+FOOT])
    cabinet(name = "cAB", w = W_A, h = A2_H, d = DEPTH,back=["internal",8],sideClose="ouF"){ 
        cTop()
        shelf(U_SIZE*1/3)
        shelf(U_SIZE*2/3)
        shelf(U_SIZE)
        doors(name = "asd", h = U_SIZE);
    };

    /**
     21.5 filamentes doboz
     23 
     19 A4
     ruhas: 19cm
    */
    translate([W_A,0,0]) 
    {
        X_H=420;
        DEC_W=DEPTH;
        cabinet(name = "cB", w = W_B, h = 1000, d = DEPTH,foot=FOOT,back=["internal",8]) {
            fdm_printer()
            air_filter()
            cTop(outer=true)
            drawer(h = 100) // 155 - 112
            drawer(h = 100) // 155 - 112
            drawer(h = 200)
            drawer(h = 200)
            drawer(h = 200)
            drawer(h = 200, bottomDrawer=true)
            ;
        }
        for(i=[0:1])
        translate([0,$W,MAX_H+FOOT-$W-i*X_H]) 
        cutCornerShelf(name = "x1", w = DEC_W, d = DEPTH-$W,cL=DEPTH,type="round");
        translate([0,0,MAX_H+FOOT-$W-X_H]) 
        eXZ("xB",DEC_W,X_H+$W);

    }
}

module model() {
posNeg() {

    szekreny();
 if(!$positive) {        cube([1000,1000,4000],center=true);    }
//    if(!$positive) {        cube([10000,200,4000],center=true);    }

}
}

mode="print";
//mode="P-cB2H250BYZ";
//mode="P-cBOuterTopXY";

mode="P-cBlYZ";

//cBOuterTopXY
//x@OUTPUT:P-cBBotXY
//x@OUTPUT:P-cBlYZ
//x@OUTPUT:P-cBrYZ
//@OUTPUT:P-cBBotXY
//@OUTPUT:P-cBlYZ


if(mode == "print") {
s=($mode == "print")?.05:1;
scale([1,1,1]*s) {
    
    translate([1000,1000,0]) 
    %actor();
model();
    
}


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

 if(mode[0] == "A" && mode[1]=="-") {
    $fronts=false;
    $machines=false;
    $jointsVisible=false;
    
    $part=substr(mode,2);

        model();
}


function  isXYZ(a) = a =="X" || a=="Y" || a=="Z";

 if(mode[0] == "P" && isXYZ(mode[1]) && isXYZ(mode[2]) && mode[3]=="-") {
    $fronts=false;
    $machines=false;
    $jointsVisible=false;
    
    $part=substr(mode,4);
    
   projection(false)
   orient(substr(mode,1,2))
//    rotate(90,[0,1,0]) 
        model();
//        previewLU();
}

