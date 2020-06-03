use <syms.scad>

module atLeftWall(x) {
    translate();
}



WALL_THICK=70;          //*
WALL_H=1695+915;        //* w/o laminate
HW_H=1235;              //* w/o laminate
HW_WIDTH=2075-30;       //*
FWL_WIDTH=600;          //*
BACK_WALL_WIDTH=1915;   //*

LEFT_WALL_WIDTH=HW_WIDTH+FWL_WIDTH;

RIGHT_WALL_P1=135+1755+42+18; //*?
RIGHT_WALL_D1=0;
RIGHT_WALL_P2=605;
RIGHT_WALL_D2=330;
RIGHT_WALL_P3=660+480+420+40;
RIGHT_WALL_D3=50;


RIGHT_WALL_WIDTH=RIGHT_WALL_P1+RIGHT_WALL_P2+RIGHT_WALL_P3;



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
        
        mirror([1,0,0])
        fullWall(RIGHT_WALL_WIDTH);
        translate([RIGHT_WALL_P1,RIGHT_WALL_D2,0])
        mirror([1,0,0])
        fullWall(RIGHT_WALL_P2);
    }
    
    
}



function prop(k,v)=[k,v];
function sublist(l,start)=start<len(l) ? [for(i=[start:len(l)-1])  l[i]] : undef;
function getProp(props,k)= (props[0][0] == k) ? props[0][1] : (props == undef ? 
    undef : getProp(sublist(props,1), k)
    );

W=19;

INSET=10;
BACKSET=10;
BACKPLANE_W=1.6;
BACKPLANE_NUT_W=2;


module bBox(spec,e) {
    
    width=getProp(spec,"WIDTH");
    depth=getProp(spec,"DEPTH");;
    height=800+80+30;
    inner_w=width-2*W;
    
//    backplaneCenter=[0,depth-3,height/2+W-INSET]
    
    sidePos=-[width/2-W/2,-depth/2,-height/2];
    
    module element(piece) {
        
        difference() {
            union() {
                if(piece=="R" || piece=="A")
                translate(sidePos)
                cube([W,depth,height],center=true);
                if(piece=="L" || piece=="A")
                mirror([1,0,0])
                translate(sidePos)
                cube([W,depth,height],center=true);
                if(piece=="B" || piece=="A")
                translate([0,depth/2,W/2])
                cube([inner_w,depth,W],center=true);
            }
            translate([0,depth-BACKSET,height/2+W-INSET])
            cube([inner_w+INSET*2,3,height],center=true);
            translate([0,depth/2,300])
            rotate(90,[0,1,0])
            cylinder(d=depth/2,h=1000,center=true);
        }
    }
    
    if(e=="L") 
        rotate(90,[0,1,0])
        translate(sidePos)
        element(e);
    if(e=="R") 
        rotate(-90,[0,1,0])
        translate(-sidePos)
        element(e);
    if(e=="B")
        translate([0,0,-W/2])
        element(e);
    if(e=="A")
        translate([width/2,0*depth,0])
        element(e);
 //   element(e);
    
}


//echo(concat([[1,2]],[[3,4]]));

L1W=80;    L1X=0;
L2W=600;    L2X=L1X+L1W;
L3W=208;    L3X=L2X+L2W;
L4W=600;    L4X=L3X+L3W;
L5W=600;    L5X=L4X+L4W;
L6W=600;    L6X=L5X+L5W;

LEFT_PART_WIDTH=L1W+L2W+L3W+L4W+L5W+L6W;
echo(LEFT_PART_WIDTH);
echo(LEFT_WALL_WIDTH);
echo(LEFT_WALL_WIDTH-LEFT_PART_WIDTH);


//2670
R1W=150;    R1X=0;//-R1W;
R2W=600;    R2X=R1X+R1W;
R3W=600;    R3X=R2X+R2W;
R4W=600;    R4X=R3X+R3W;


R_P1_REMAIN=RIGHT_WALL_P1- (R1W+R2W+R3W+R4W);
echo ("P1_REMAIN",R_P1_REMAIN);
if(R_P1_REMAIN<0 ) {
    error();
}
module part(partName,partMode) {
    
    leftDefs=[prop("DEPTH",392)];
    if(partName == "L6") {
        bBox(concat(leftDefs,[prop("WIDTH",L6W)]),partMode);
    }
    if(partName == "L5") {
        bBox(concat(leftDefs,[prop("WIDTH",L5W)]),partMode);
    }
    if(partName == "L4") {
        bBox(concat(leftDefs,[prop("WIDTH",L4W)]),partMode);
    }
    if(partName == "L3") {
        bBox(concat(leftDefs,[prop("WIDTH",L3W)]),partMode);
    }
    if(partName == "L2") {
        bBox(concat([prop("DEPTH",600),prop("WIDTH",L2W)],leftDefs),partMode);
    }
    if(partName == "L1") {
        bBox(concat([prop("DEPTH",600),prop("WIDTH",L1W)],leftDefs),partMode);
    }
    
    rDefs=[prop("DEPTH",600)];
    
    if(partName == "R1") {
        bBox(concat([prop("DEPTH",600),prop("WIDTH",R1W)],leftDefs),partMode);
    }
    if(partName == "R2") {
        bBox(concat([prop("DEPTH",600),prop("WIDTH",R2W)],leftDefs),partMode);
    }
    if(partName == "R3") {
        bBox(concat([prop("DEPTH",600),prop("WIDTH",R3W)],leftDefs),partMode);
    }
    if(partName == "R4") {
        bBox(concat([prop("DEPTH",600),prop("WIDTH",R4W)],leftDefs),partMode);
    }
    
}

module previewL() {
    translate([L1X,0,0])
    part("L1","A");
    translate([L2X,0,0])
    part("L2","A");
    translate([L3X,0,0])
    part("L3","A");
    translate([L4X,0,0])
    part("L4","A");
    translate([L5X,0,0])
    part("L5","A");
    translate([L6X,0,0])
    part("L6","A");
}

module previewR() {
    
    atRightCorner() {
        translate([R1X,0,0])
        part("R1","A");
        translate([R2X,0,0])
        part("R2","A");
        translate([R3X,0,0])
        part("R3","A");
        translate([R4X,0,0])
        part("R4","A");
    }
}


mode="previewL";

if(mode=="preview") {
    walls("A");
    
    previewL();
    previewR();
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



