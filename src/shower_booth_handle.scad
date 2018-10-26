
HANDLE_W=12;
HANDLE_D=50;
ROD_H=10;
ROD_D=16;
HOLE_D=8;
HOLE_L=4;


use <threads.scad>
module thread(I=false) {
    metric_thread (diameter=HOLE_D, pitch=2, length=HOLE_L+ROD_H-1, internal = I);
}


//thread();
$fn=64;

module handle() {
    rotate_extrude(convexity = 10) {
    //    translate([2, 0, 0])
    //    circle(r = 2);
        
    //    polygon( points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]] );
        
        
        R=HANDLE_W/2;
        K=HANDLE_D/R-1;
        s=[ [0,0],
            for(i=[-90:10:90])
                [K+sqrt(1-pow(i/90,2)),1+i/90]*R,
            [ROD_D/2,HANDLE_W],
            [ROD_D/2,HANDLE_W+ROD_H],
            [0,HANDLE_W+ROD_H],
        ];
        polygon( points=s);
    }
}

module handleA() {
    handle();
    translate([0,0,HANDLE_W+ROD_H])
    thread(false);
}

module handleB() {
    difference() {
        handle();
        translate([0,0,HANDLE_W+.1])
        thread(true);
    }
}

mode="handleA";
if(mode=="handleA") {
    handleA();
}
if(mode=="handleB") {
    handleB();
}