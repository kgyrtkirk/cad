
$fn=64;

HANDLE_W=12;
HANDLE_D=24;
ROD_H=10;
ROD_D=16;
HOLE_D=8;
HOLE_L=4;


use <threads.scad>
module thread(I=false) {
    if(I) {
        translate([0,0,1])
        cylinder(d1=HOLE_D+1,d2=HOLE_D-1,h=HANDLE_W,center=true);
    }

    translate([0,0,-HANDLE_W/2+1])
    metric_thread (diameter=HOLE_D, pitch=1.25, length=HANDLE_W/2+HOLE_L+ROD_H-1, internal = I);
}


//thread();

module handle0() {
    rotate_extrude(convexity = 10) {
    //    translate([2, 0, 0])
    //    circle(r = 2);
        
    //    polygon( points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]] );
        
        
        R=HANDLE_W/2;
        K=HANDLE_D/R-1;
        s=[ [0,0],
            for(i=[-90:10:90])
                [K+sqrt(1-pow(i/90,2)),1+i/90]*R,
  //      [0,HANDLE_W],
            [ROD_D/2,HANDLE_W],
            [ROD_D/2,HANDLE_W+ROD_H],
            [0,HANDLE_W+ROD_H],
        ];
        polygon( points=s);
    }
}

module handle(topPart) {
    K=100;
    z=HANDLE_W/2 + (topPart ? -K/2 : K/2);
    
    difference() {
        handle0();
        translate([0,0,z])
        cube([HANDLE_D*3,HANDLE_D*3,K],center=true);
    }
}


module handleA() {
    handle(true);
    translate([0,0,HANDLE_W+ROD_H])
    thread(false);
}

module handleB() {
    difference() {
        handle(true);
        translate([0,0,HANDLE_W+.1])
        thread(true);
    }
}

module handleT() {
    handle(false);
}


mode="preview";
if(mode=="handleA") {
    handleA();
}
if(mode=="handleB") {
    handleB();
}
if(mode=="handleT") {
    handleT();
}

if(mode=="preview") {
    difference() {
        union() {
            translate([0,0,-1])
            handleT();
            
            handleA();
            translate([0,0,2*HANDLE_W+2*ROD_H+HOLE_L])
            rotate(4/1.25*360+180,[0,0,1])
            rotate(180,[1,0,0]) {
                translate([0,0,-1])
                handleT();
                handleB();
            }
            
        }
        translate([0,0,-10])
        cube([100,100,100]);
    }
}
