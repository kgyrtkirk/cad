use <furniture.scad>

ROOM_X=4460;
ROOM_Y=1355;
ROOM_Z=2020+730;
ROOM_WALL=50;

W=18;
$W=18;
M60I=564;
M60W=M60I+W;

module room(cut) {
    R=[ROOM_X,ROOM_Y,ROOM_Z];
    Q=[ROOM_WALL,ROOM_WALL,0];
    P=[0,0,ROOM_WALL];
    
    EX=[2*ROOM_WALL,0,0];
    EY=[0,2*ROOM_WALL,0];
    
    module walls() {
        difference() {
            translate(-Q)
            cube(R+2*Q);

            translate(-P)
            cube(R+2*P);
        }
    }
    module doorCut() {
        D=[ROOM_WALL,775,2020];
        translate([0,510,0])
        translate(-EX)
        cube(D+2*EX);
    }
    module windowCut() {
        D=[1200,ROOM_WALL,1200];
        H=cut=="Z"?0:910;
        translate([1245,0,H])
        translate(-EY)
        cube(D+2*EY);
    }
    module gasLine() {
        Y=55;
        H=2290;
        p=[ [ROOM_X-1395,Y,0],
            [ROOM_X-1395,Y,H],
            [Y,Y,H],
            [Y,380,H],
            [0,380,H]   ];
        
        color([1,0,0])
        hullPairs(p,false)
            sphere(d=25,$fn=6);
    }
    module gasConvector() {
        
        translate([ROOM_X-1395-50-480,0,0])
        color([1,0,0])
        cube([480,300,840]);
    }
    module electricBox() {
        D=10;
        S=700+2*25;
        H=cut=="Z"?0:900;
        color([0,0,1])
        translate([ROOM_X-785-S,ROOM_Y,H])
        mirror([0,1,0])
        cube([S,D,S]);
    }
    
    difference() {
        union() {
            walls();
            gasLine();
            gasConvector();
            electricBox();
        }
        doorCut();
        windowCut();
        
        if(cut=="Z") {
            translate([0,0,300])
            translate(-2*Q)
            cube(R+4*Q);
        }
    }
    
    
    
}

module cabinet(name,D,heights) {
    Z=prefix(0,heights);
    H=Z[len(Z)-1]+W;
    eYZ(name,D,H);
    translate([M60W,0,0])
    eYZ(name,D,H);
    
    for(z=Z)
    translate([W,0,z])
    eXY(name,M60I,D);
}


module partsL() {
    for(x=[0:600:1200])
        translate([ROOM_X-x-1600,ROOM_Y,0])
        mirror([1,0,0])
        mirror([0,1,0])
            cabinet("L",450,[0,450+W,350+W,300+W,300+W,300+W,400+W]);

}
module partsR() {
    translate([ROOM_X-700,0,0])
        mirror([1,0,0])
            cabinet("R",450,[0,450+W,350+W,300+W,300+W,300+W,400+W]);

//    cabinet("S1",300,[0,280+W,280+W,280+W]);
    for(x=[0:600:1800])
    translate([x,0,0])
    cabinet("S2",300,[0,280+W,280+W,280+W]);
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
    }
}



