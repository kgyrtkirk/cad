use <hulls.scad>
use <syms.scad>
use <furniture.scad>

$fronts=true;
$machines=true;
$internal=true;
$openDoors=false;
$drawerState="CLOSED";

$part=undef;

$W=18;

mode="real";


module bedFrame(name,l,w,h,sink,xh2=-1) {
    h2=(xh2<0)?h:xh2;
    q=h2-h;
    
    translate([0,0,-q])
    eYZ(str(name,"-F"),w+2*$W,h2);
    
    translate([0,0,-q])
    translate([l+$W,0,0])
    eYZ(str(name,"-F"),w+2*$W,h2);
    
    if(xh2>0) {
        translate([0,0,-q])
        translate([(l+$W)/2,$W,0])
        eYZ(str(name,"-C"),w,q+h-sink-$W);
    }
    

    translate([$W,0,0])
    eXZ(str(name,"-S"),l,h);
    translate([$W,w+$W,0])
    eXZ(str(name,"-S"),l,h);
    
    translate([$W,$W,h-$W-sink])
    eXY(str(name,"-BOT"),l,w);
    
    
}

module mat() {
    color([1,1,1,.3])
    cube([1800,800,100]);
}

module bedDrawer(width,depth,height) {
    // Blickle 303/40 
    //  https://falcodepoudvar.hu/kepek/Blickle-gorgo-303-40-agynemutartohoz-gumis-60kg_26753.jpg
    //  https://falcodepoudvar.hu/webshop/show/Blickle-gorgo-303-40-agynemutartohoz-gumis-60kg_42630
    
    FRONT_SP=5;
    FRONT_Z=10;
    BOTTOM_W=3;
    WIDTH_SPACING=50;
    GEAR_H=20;  //  
    
    
    
    color([1,0,0])
    translate([FRONT_SP/2,depth,FRONT_Z+FRONT_SP/2])
    eXZ("BD-front",width-FRONT_SP,height-FRONT_SP-FRONT_Z);
    
    
    
    
    inner_w=width-WIDTH_SPACING;
    
    translate([WIDTH_SPACING/2,0,GEAR_H]) {
        translate([0,0,-BOTTOM_W])
        color([0,0,1])
        eXY("BD-bottom",inner_w,depth,$W=BOTTOM_W);
        
        frame("BD-F",depth-2*$W,inner_w-2*$W,height-GEAR_H-GEAR_H);
        
    }
    
}

module bunkBed() {
    C_W=500;
    C_H=1300;
    D=800+2*$W;
    
    MAT_L=1800;
    MAT_W=800;
    MAT_D=100;
    
    MAT_SINK=40;
    MAT_BOTTOM_SPACE=20;
//    MAT_BOTTOM_SPACE=MAT_D-MAT_SINK-$W;
    
//    BL_TOP=50+$W+$W+100+200;
    BL_DRAWER=150;
    BL_TOP=BL_DRAWER+MAT_BOTTOM_SPACE+$W+MAT_D+$W+MAT_SINK;

    echo("sit-inh",BL_TOP);

    
    translate([$W,($openDoors?D:0)+$W,0]) {
        bedDrawer(MAT_L/2,MAT_W,BL_DRAWER);
    }
    translate([MAT_L/2+$W,($openDoors?D:0)+$W,0]) {
        bedDrawer(MAT_L/2,MAT_W,BL_DRAWER);
    }

    
    translate([2450,0,0])
    rotate(-90,[0,1,0])
    mat();
    
    
    translate([MAT_L+$W+$W,0,-0])
    cabinet("CAB",C_W,C_H,D-$W,foot=0,extraHR=MAT_BOTTOM_SPACE,fullBack=true)
        cBeams()
        shelf(400,external=false,alignTop=true)
        doors("DOOR",cnt=1,400)
        drawer(200)
        drawer(200)
        drawer(200)
        drawer(300)
    ;
    translate([C_W,0,C_H])
    bedFrame("BED_U",MAT_L,MAT_W,MAT_BOTTOM_SPACE+$W+MAT_SINK,MAT_SINK);


//    translate([0,0,200])
    translate([0,0,BL_DRAWER])
    bedFrame("BED_L",MAT_L,MAT_W,BL_TOP-BL_DRAWER,$W+MAT_D+MAT_SINK,BL_TOP);
    
    translate([$W,0,BL_TOP-MAT_SINK])
        mat();
    translate([$W,0,BL_TOP-MAT_SINK-$W-MAT_D])
        mat();
   
    
    translate([C_W,0,BL_TOP])
    eXZ("Iback",400,C_H-BL_TOP);

    translate([C_W,D-$W,BL_TOP])
    eXZ("Iback",400,C_H-BL_TOP);

}

if(mode=="real") {
    difference() {
        posNeg()
        bunkBed();
      
      translate([14500,0,0])  
        cube([5000,800,5000],center=true);
    }
}

if(mode=="s30") {
    rotate(90,[1,0,0])
    scale(1/30)
    posNeg()
    bunkBed();
}
