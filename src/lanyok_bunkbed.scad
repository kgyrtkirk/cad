use <hulls.scad>
use <syms.scad>
use <furniture.scad>

$fronts=true;
$machines=true;
$internal=false;
$openDoors=open;
$drawerState="CLOSED";
$drawerBoxes=true;
$cheat=false;


$part=undef;

$W=18;

mode="real";


module bedFrame(name,l,w,h,sink,xh2=-1,leftOversize=0,backOversize=0) {
    $close=str($close,"LROU");
    h2=(xh2<0)?h:xh2;
    q=h2-h;
    
    translate([0,$W,-q])
    eYZ( str(name,"-FR"),w,h2);
    
    translate([0,$W,-q])
    translate([l+$W,0,0])
    eYZ(str(name,"-FL"),w,h2+leftOversize);
    
    if(xh2>0) {
        translate([0,0,-q])
        translate([(l+$W)/2,$W,0])
        eYZ(str(name,"-C"),w,q+h-sink-$W);
    }
    

    translate([0,0,0])
    eXZ(str(name,"-SB"),l+2*$W,h+backOversize);
    translate([0,w+$W,0])
    eXZ(str(name,"-SF"),l+2*$W,h);
    
    translate([$W,$W,h-$W-sink])
    eXY($close="",str(name,"-BOT"),l,w);
    
    
}

module mat() {
    if($machines && $positive) {
        color([1,1,1,.3])
        cube([1800,800,100]);
    }
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
    
    
    
//    color([1,0,0])
    translate([FRONT_SP/2,depth,FRONT_Z+FRONT_SP/2])
    eXZ($front=true,$close="OULR","BD-front",width-FRONT_SP,height-FRONT_SP-FRONT_Z);
    
    
    
    
    inner_w=width-WIDTH_SPACING;
    translate([WIDTH_SPACING/2,0,GEAR_H]) {

        translate([0,0,height])
        eXY($close="lrfb","BD_COVER",inner_w+$W,depth-$W,rot=true);
        
        translate([$W,$W,-BOTTOM_W])
//        color([0,0,1])
        eXY("BD-bottom",inner_w-2*$W,depth-2*$W,rot=true);
        
        frame($close="Oufb","BD-F",depth-2*$W,inner_w-2*$W,height-GEAR_H-GEAR_H);
        
    }
    
}

module bunkBed() {
    C_W=500;
    C_H=1450;
    
    MAT_L=1800;
    MAT_W=810;
    MAT_D=100;

    D=MAT_W+2*$W;
    
    MAT_SINK=40;
    MAT_BOTTOM_SPACE=20;
    MAT_BOTTOM_SPACE_U=100;
    
    LADDER_WIDTH=500;
//    MAT_BOTTOM_SPACE=MAT_D-MAT_SINK-$W;
    
//    BL_TOP=50+$W+$W+100+200;
    BL_DRAWER=150;
    BL_TOP=BL_DRAWER+MAT_BOTTOM_SPACE+$W+MAT_D+$W+MAT_SINK;

    BH_TOP=C_H+MAT_BOTTOM_SPACE_U+$W+MAT_SINK;

    echo("sit-inh",C_H-BL_TOP);
    MAT_Z2=C_H+MAT_BOTTOM_SPACE_U+$W+MAT_D;
    echo("sit-inh2",2626-MAT_Z2);
    echo("MAT_Z2",MAT_Z2);
    
    
    if(true) {
        OFF_Y=$cheat?0:$W;
        BEDDRAWER_W=MAT_W+$W-OFF_Y;
        
    translate([0,($openDoors?D:0)+OFF_Y,0]) {
        bedDrawer(MAT_L/2+$W,BEDDRAWER_W,BL_DRAWER);
    }
    translate([MAT_L/2+$W,($openDoors?D:0)+OFF_Y,0]) {
        bedDrawer(MAT_L/2+$W,BEDDRAWER_W,BL_DRAWER);
    }
}

    FOOT=10;
    translate([MAT_L+$W+$W,0,-0])
    cabinet("Cab",C_W,C_H-FOOT,D-$W,foot=FOOT,extraHR=MAT_BOTTOM_SPACE_U,fullBack=true)
        cTop()
//        shelf(400,external=false,alignTop=true)
  //      doors("DOOR",cnt=1,400)
        drawer(150)
        drawer(200)
        drawer(200,true)
        drawer(200,true)
        drawer(200,true)
        drawer(200,true)
        drawer(290)
    ;
    translate([C_W,0,C_H])
    bedFrame("BED_U",MAT_L,MAT_W,MAT_BOTTOM_SPACE_U+$W+MAT_SINK,MAT_SINK,
        leftOversize=300,backOversize=300);


//    translate([0,0,200])
    translate([0,0,BL_DRAWER])
    bedFrame($close="fb","BED_L",MAT_L,MAT_W,BL_TOP-BL_DRAWER,$W+MAT_D+MAT_SINK,BL_TOP);
    
    
    translate([C_W,0,BL_TOP])
    eXZ($close="LRou","Iback",LADDER_WIDTH,C_H-BL_TOP);
    
    module ladder(w,h,n) {
        step_w=w/2;
        step_x=w/4;
        step_h=h/(2*n-1);
        step_dz=(h-step_h)/(n-1);
        
        echo("step_DZ",step_dz);
        echo("step_H",step_h);
        
        
        eXZ("L_SIDE",step_x,h,$close="lRou");
        translate([w-step_x,0,0])
        eXZ("L_SIDE",step_x,h,$close="Lrou");

        for(i=[1:n-1])
        translate([step_x,0,step_dz*i-step_h])
        eXZ($front=true,$close="lroU",
            "L_CENT",step_w,step_h,rot=true);

        for(i=[0:n-1]) {
            $close="FBLR";
            translate([step_x,-$W,step_dz*i])
            eXY($front=true,"ladder-step",step_w,3*$W,rot=true);
        }
        
    }
    
    
    translate([C_W,D-$W,BL_TOP])
    ladder(LADDER_WIDTH,C_H-BL_TOP,4);
    
    module bottomShelves(l,depth) {
        translate([-depth,0,0])
        eXY($close="FR","botShelve1",l+depth,depth);
    }

    translate([C_W+LADDER_WIDTH,$W,BL_TOP]) {
        OVERLAP=100;
        L0=MAT_L+$W+$W-C_W-LADDER_WIDTH+OVERLAP;
        
        translate([-OVERLAP,0,600])
        bottomShelves(L0,100);
        translate([-OVERLAP,0,800])
        bottomShelves(L0,150);
        translate([-OVERLAP,0,1000])
        bottomShelves(L0,200);
    }
    
    module topRails() {
        I_W=120;
        I_H=200;
        B_H=100;

        //neessenekki
        w=MAT_W+2*$W;
        l=MAT_L+2*$W;
        lw=LADDER_WIDTH;
        X=MAT_L+$W;
        Y=MAT_W+$W;


        for(y=[w/3,w*2/3,w])
        translate([0,y-I_W,0]) {
            if(false)
            translate([X,0,0])
            eYZ("BARR-I",I_W,I_H);
            eYZ($front=true,$close="FBLRou","BARR-I",I_W,I_H);
        }

        if(false)
        for(x=[0:(l-I_W)/5:l-I_W]) 
        translate([x,0,0]) {
            color([1,0,0])
            eXZ("BARR-I",I_W,I_H);
        }

        for(x=[0:(l-I_W-lw)/4:l-I_W-lw]) 
        translate([x+lw,Y,0]) {
            $close="LRou";
            eXZ($front=true,"BARR-I",I_W,I_H);
        }

        translate([0,0,I_H]){
            if(false)
            eXZ("BARR-B",l,B_H);

            $close="FBLROU";

            translate([lw,Y,0])
            eXZ("BARR-F",l-lw,B_H);

            translate([0,$W,0])
            eYZ("BARR-SR",MAT_W+$W,B_H);

            if(false)
            translate([X,$W,0])
            eYZ("BARR-SL",MAT_W,B_H);

        }
        
//        translate([lw,y,0])
  //      eXZ("a",1000,1000);

        
    }
    translate([C_W,0,BH_TOP])
    topRails();

/*    
    translate([2450,0,0])
    rotate(-90,[0,1,0])
        mat();
    */
    translate([$W,$W,BL_TOP-MAT_SINK])
        mat();
    translate([$W,$W,BL_TOP-MAT_SINK-$W-MAT_D])
        mat();
    translate([$W+C_W,$W,C_H+MAT_BOTTOM_SPACE_U+$W])
        mat();
    
    

}

if(mode=="real") {
    difference() {
        posNeg()
        bunkBed();
      
      translate([14500,0,0])  
        cube([5000,800,5000],center=true);
    }
}


if(mode=="proj") {
$fronts=false;
$machines=true;
$internal=false;
$openDoors=false;
$drawerState="CLOSED";
$drawerBoxes=true;
$cheat=false;
    
    projection(cut=true)
    posNeg()
    translate([0,0,-810-$W-$W/2])
    rotate(90,[1,0,0])
    bunkBed();
}

if(mode=="s30") {
    $machines=false;
    $cheat=true;
    rotate(90,[1,0,0])
    scale(1/30)
    posNeg()
    bunkBed();
}
