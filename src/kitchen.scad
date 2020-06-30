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


function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

RIGHT_WALL_DELTA=[
    [0,0],
    [135+1755+42+18,0], //*?
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


//2670
R1W=150-18;    R1X=0;//-R1W;
R2W=600;    R2X=R1X+R1W;
R3W=600;    R3X=R2X+R2W;
R4W=600;    R4X=R3X+R3W;

R_W=[0,150-18,600,600,600,RIGHT_WALL_DELTA[3][0]+W];
R_X=prefix(0,R_W);
R_Q=50;     // toloajto hely
//R_D=[]


Z_WIDTH=[0,600,600,400];
ZX=prefix(0,Z_WIDTH);
R_DEPTH=600;

FULL_H=2560;    // FIXME: critical value
SYSTEM_H=2500;  // FIXME: critical value
echo("SYS_H",SYSTEM_H);
echo("WALL_H",WALL_H);

module part(partName,partMode) {
    
    $drawerState="CLOSED";
    leftMaximera=[125,125,800-250];
    
    leftDefs=[prop("DEPTH",392),prop("HEIGHT",800),];
    if(true) {
        $depth=392;
        $height=800;
        if(partName == "L6") {
            $width=L6W;
            bBox(concat(leftDefs,[prop("WIDTH",L6W)]),partMode) {
                maximera(leftMaximera);
            }
        }
        if(partName == "L5") {
            bBox(concat(leftDefs,[prop("WIDTH",L5W)]),partMode) {
                maximera(leftMaximera);
            }
        }
        if(partName == "L4") {
            bBox(concat(leftDefs,[prop("WIDTH",L4W)]),partMode) {
                maximera(leftMaximera);
            }
        }
        if(partName == "L3") {
            bBox(concat(leftDefs,[prop("WIDTH",L3W)]),partMode);
        }
    }
    
    if(true) {
        $depth=R_DEPTH;
        $height=800;
        if(partName == "L2") {
            bBox($width=L2W,partMode);
        }
        if(partName == "L1") {
            bBox($width=L1W,partMode);
        }
    }
    
    rDefs=[prop("DEPTH",600)];
    
    if(true) {
        $depth=600;
        $height=800;
        
        if(partName == "R1") {
         //   bBox($width=R1W,partMode);
        }
        if(partName == "R2") {
            bBox($width=R2W,partMode) {
                maximera(leftMaximera);
            }
        }
        if(partName == "R3") {
            // mosogatogep bosch;
            // https://euronics.hu/termekek/bosch-smv46mx01e-beepitheto-mosogatogep/p/222189
            // * borderless
            // * magassag: 815~875
            // * front panel 655-675
            // also takaro?
            
            if(false)
            bBox($width=R3W,partMode) {
                maximera([800]);
            }
        }
        if(partName == "R4") {
            bBox($width=R4W,partMode) {
                maximera([125,800-125]);
            }   
        }

        
        if(partName == "R5") {
            $depth=R_DEPTH-RIGHT_WALL_DELTA[2][1]-W;
            bBox($width=R_W[5],partMode) {
                maximera([125,800-125]);
            }   
        }
    }
    
    if(partName == "R6") {
        $depth=R_DEPTH-RIGHT_WALL_PROFILE[2]-W;
        $width=RIGHT_WALL_DELTA[3][0]+W;
        bBox(concat([prop("DEPTH",600),prop("WIDTH",R4W)],leftDefs),partMode) {
            maximera([125,800-125]);
        }   
    }

    if(partName == "P_L") {
        echo(RIGHT_WALL_PROFILE[2]);
        $width=RIGHT_WALL_PROFILE[2][1];
        $height=SYSTEM_H;
        plain();
    }
    if(partName == "P_D") {
        $width=RIGHT_WALL_DELTA[3][0]+W;
        $height=SYSTEM_H;
        plain(); // FIXME more parts
    }
    if(partName == "P_R") {
        //R_Q;
        $width=R_DEPTH-R_Q;
        $height=SYSTEM_H;
        plain();
    }
    
    if(partName == "Z2") {
        $depth=R_DEPTH-R_Q;
        $width=Z_WIDTH[2];
        $height=SYSTEM_H;
        // 150+6cm max belathato
        bBox(partMode) {
            maximera([-1000,150,150,150,150,150,150,150,150,150,150]);
        }   
    }
    if(partName == "Z3") {
        $depth=R_DEPTH-R_Q;
        $width=Z_WIDTH[3];
        $height=SYSTEM_H;
        // 150+6cm max belathato
        bBox(partMode) {
            maximera([-1000,150,150,150,150,150,150,150,150,150,150]);
        }   
    }
}

module plain() {
        cube([$width,W,$height]);
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

function v3(v2) = [v2[0],v2[1],0];

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
        
        translate(v3(RIGHT_WALL_PROFILE[1]))
//        translate([R_X[4],0,0])
//        mirror([1,0,0])
        rotate(90)
        part("P_L","A");

        translate(v3(RIGHT_WALL_PROFILE[2]-[W,0]))
        part("P_D","A");

        translate([RIGHT_WALL_PROFILE[3][0],R_Q,0])
        rotate(-90)
        mirror([1,0,0])
        part("P_R","A");
        
        
        translate([RIGHT_WALL_PROFILE[3][0]+W,R_Q,0]) {
            translate([ZX[0],0,0])
            part("Z1","A");
            translate([ZX[1],0,0])
            part("Z2","A");
            translate([ZX[2],0,0])
            part("Z3","A");
        }
        
        translate([R_X[4],RIGHT_WALL_DELTA[2][1]+W,0])
        part("R5","A");
    }
}


mode="previewR";

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



