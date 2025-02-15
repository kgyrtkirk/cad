use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>


$fronts=true;
$machines=true;
$internal=true;
$openDoors=true;
$drawerState="CLOSED";

W=18;
$W=18;
M60I=564;
M60W=M60I+W;

D_TOP=400;
D_L=340;

ROOM_X=3990;
//ROOM_X=870+3110;
ROOM_Y1=2500;
ROOM_Y2=870;

SYSTEM_H=1450+1000;

D_W=100;
ROOM_WALL=D_W;

D37=300;
    
FOOT_H=60;

ROOM_Y2A=1840;
ROOM_Y2B=ROOM_Y2A+1600;

ROOM_Y3A=ROOM_Y2B+800;
ROOM_Y3B=ROOM_Y3A+2000;
ROOM_X3B=330;

module room(cut) {
    
    module walls() {
        H=3000;
        Q=D_W/2;
        p=[ [ROOM_X,ROOM_Y1,0]+[1,-1,0]*Q,
            [ROOM_X,0,0]+[1,-1,0]*Q,
            [0,0,0]+[-1,-1,0]*Q,
            [0,ROOM_Y2,0]+[-1,-1,0]*Q,];
        hullPairs(p,false)
        translate([0,0,H/2])
            cube([D_W,D_W,H],center=true);
        
        hull()
        for(y=[ROOM_Y2A,ROOM_Y2B-D_W])
        translate([0,y,0]+[-1,1,0]*Q)
        translate([0,0,H/2])
        cube([D_W,D_W,H],center=true);

        hull()
        for(y=[ROOM_Y3A,ROOM_Y3B-D_W])
        translate([0,y,0]+[-1,1,0]*Q)
        translate([0,0,H/2])
        cube([D_W,D_W,H],center=true);

    }
    
    module windowCut() {

        D=[D_W*3,770,1200];
        H=cut=="Z"?0:950; // FIXME
        translate([ROOM_X-D_W*1.5,420,H])
        cube(D);
    }
    module gasLine() {
        Y=55;
        H=2570;
        p=[ [870,Y,0],
            [870,Y,H],
            [ROOM_X,Y,H],
        ];
        
        color([1,0,0])
        hullPairs(p,false)
            sphere(d=25,$fn=6);
//        K=420+770+1160;
        K=2360;
        p2=[ [ROOM_X-Y,K,0],
             [ROOM_X-Y,K,800],
        ];
        color([1,0,0])
        hullPairs(p2,false)
            sphere(d=25,$fn=6);
    }
    module oven() {
//        translate([890,0,0])
        translate([X[4],0,0])
        color([1,1,0])
        cube([590,600,850]);
    }
    module fridge() {
        translate([0,0,0])
        color([1,0,1])
        cube([595,620,1550]);
        
    }
    module micro() {
        translate([X[3],0,860])
        color([1,0,1])
        cube([490,340,270]);
    }
    module dishwasher() {
//        translate([890,0,0])
        translate([X[2],0,0])
        color([1,0,1])
        cube([600,600,850]);
    }
    
    difference() {
        union() {
            walls();
            gasLine();
            if($machines) {
                oven();
                dishwasher();
                fridge();
                micro();
            }
        }
        windowCut();
        

        if(cut=="Z") {
            R=2*ROOM_X;
            Q=300;
        translate([0,0,300])
            translate([-300,-300,0])
            cube(R+4*Q);
        }
    }
}



module cabinet1(name,D,heights) {
    Z=prefix(0,heights);
    H=Z[len(Z)-1]+W;
    eYZ(name,D,H);
    translate([M60W,0,0])
    eYZ(name,D,H);
    
    for(z=Z)
    translate([W,0,z])
    eXY(name,M60I,D);
}


DEPTH_R=560;

D_X=[360,600,605,800,600,350,600];
D_Y=[0,650,1050];

X=prefix(ROOM_X,-D_X);
Y=prefix(DEPTH_R+20+W-D_Y[0],D_Y);

module partsR() {
    
    translate([X[1],0,FOOT_H])
    cabinet("C1",D_X[0]+D_X[1],800,DEPTH_R)
        cBeams()
        partitionBeams(600,100) {
            maximera1(800);
            cube(1);
        }
    
    translate([X[3],0,FOOT_H])
    cabinet("C3",D_X[3],800,DEPTH_R)
        cBeams()
        maximera1(150)
        shelf(300)
        doors("S1",650,cnt=2)
    
    ;
    translate([X[5],0,FOOT_H])
    cabinet("C5",D_X[5],800,DEPTH_R)
        cBeams()
        shelf(300)
        shelf(700)
        doors("S1",800,cnt=1)
    ;

}


module onLeftWall() {
    
    translate([ROOM_X,0,0])
    rotate(90)
        children();
}

module onRightWall(off=ROOM_Y2A) {
    
    translate([0,off,0])
    rotate(-90)
    mirror([1,0,0])
        children();
}

module partsL() {
    onLeftWall() {
        translate([Y[0],0,FOOT_H])
        cabinet("L1",D_Y[1],800,D_L)
            cBeams()
            shelf(300)
            shelf(500)
            doors("l1",800)
            ;
        translate([Y[1],0,FOOT_H])
                cabinet("L2",D_Y[2],SYSTEM_H,D_L)
            cTop()
            shelf(1000)
            shelf(500)
            shelf(1350)
            shelf(1650)
            shelf(1650+300)
            shelf(1650+600)
            doors("l2",1000,glass=true)
            doors("l2",650,glass=true)
            doors("l2",800)
            ;
    }
}


module partsU() {
    
    VIEW_H=1600;
    VIEW2_H=1450;
    H=SYSTEM_H-VIEW_H;
    H2=SYSTEM_H-VIEW2_H;
    for(i=[0,1,4,5,6])
    translate([X[i],0,VIEW_H])
    cabinet(str("U",i),D_X[i],H,D_TOP)
        cTop()
            shelf(300)
            shelf(500)
            shelf(700)
        doors("dd",cnt=(i==0||i==5)?1:2,H)
    ;
    


    for(i=[2,3])
    translate([X[i],0,VIEW2_H])
    cabinet(str("U",i),D_X[i],H2,D_TOP)
        cTop()
            shelf(300)
            shelf(500)
            shelf(700)
        doors("dd",H2,glass=true)
    ;

}

module partsRR() {
    DD=570;
    
        translate([0,0,FOOT_H])
    onRightWall(ROOM_Y2A+100) {
        cabinet("R1",600,800,DD)
            cBeams()
            maximera1(150)
            maximera1(150)
            maximera1(150)
            maximera1(350)
        ;
        translate([600,0,0])
        cabinet("R2",800,800,DD)
            cBeams()
            maximera1(150)
            shelf(300)
            doors("dd",650,glass=true)
        ;
    }

}

module partsT() {
    
    DD=330;
    
    H=710;
    S=(H-W)/3;
    
//    translate([0,0,FOOT_H])
    onRightWall(ROOM_Y3A) {
        cabinet("T2",1800,H,DD)
            cTop()
//            maximera1(150)
            slideDoors() {
                partitionBeams(600,$h-2*W) {
                    shelf(W+1*S)
                    shelf(W+2*S);
                    partitionBeams(600,$h-2*W) {
//                        translate([0,100,0])
                        shelf(W+1*S)
                        shelf(W+2*S);
  //                      translate([0,100,0])
                        shelf(W+1*S)
                        shelf(W+2*S);
                    }
               }
           }
            
//            sliders("dd",650,glass=true)
        ;
    }
    
}


module munkalap() {
    MD=635;
    H=FOOT_H+800;
    WALL_DIST=15;//FIXME
    
    module mPiece(dims) {
        if($positive) {
            cube(dims);
        }
        echo("MLAP",dims);
    }
    
    
    translate([X[3],WALL_DIST,H])
    mPiece([ROOM_X-WALL_DIST-X[3],MD,30]);
    
    translate([X[5],WALL_DIST,H])
    mPiece([D_X[5],MD,30]);

    Q=D_X[0]-WALL_DIST;
    translate([X[0],Y[0],H])
    rotate(90)
    translate([0,-Q,0])
    mPiece([MD,Q,30]);
//    mPiece([D_X[0]-WALL_DIST,MD,30]);

        color([1,0,0])
        translate([X[1],150,H])
            cube([780,435,100]);
      
    onRightWall(ROOM_Y2A+100) {
        translate([0,0,H])
        mPiece([800+600,MD,30]);
        
    }
    
}


$part=undef;
mode="preview";

if(mode=="previewL") {
    room("Z");
    posNeg()
    partsL();
}

if(mode=="previewR") {
    room("Z");
    posNeg()
    partsR();
}


if(mode=="preview") {
    room();
    posNeg() {
        partsL();
        partsR();
        partsU();
        munkalap();
        partsRR();
        partsT();
    }
    
}



echo("X",X);

// 27cm felso polc

// Sonoma tolgy A18/SZ
// 7 6 5 12
// r


// maximera 80x60xkicsi x2
// maximera 60x60xmagas x2
// maximera 60x60xkicsi x3

