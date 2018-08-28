$fn=32;

ADJ=0;

W=6.0-ADJ;
R=(11.3-ADJ)/2;
L=17.5-R;
H=11.8;

eps=1e-3;
D=5;
R0=4.3;
R1=5;
//R0=4.6;
//R0=4.5;
O=.5;

include <threads.scad> 

module m1() {

translate([0,0,H/2]) 
union() {
    translate([0,0,-H/2]) {
        linear_extrude(H) {

            translate([-W/2,0,0])
                square([W,L]);
            translate([0,L,0])
                circle(R);
        }
    }
    rotate(-90,[1,0,0]) 
    intersection() {
        translate([0,0,eps]) {
            PH=1;
            K=8/PH;
            for(x=[0:0+(K-1)*PH]) {
                translate([0,0,-x-PH])
                cylinder(d2=R1,d1=R1-1,h=1);
            }
        }
        cube(center=true,[100,D/2,100]);
    }

}
}

module m2() { 
    //rotate(-90,[1,0,0]) 
    translate([0,0,1])
    intersection() {
        union() {
            PH=1;
            K=7/PH;
            for(x=[0:0+(K-1)*PH]) {
                translate([0,0,x])
                cylinder(d2=R1,d1=R1-1,h=1);
            }
                translate([0,0,K*PH])
            metric_thread (R0,1,D,internal=false);
        }
        cube(center=true,[100,D/2,100]);
    }
}



mode="m1";

if(mode=="m1") {
//    rotate(90,[1,0,0])
    m1();
}
if(mode=="m2") {
    rotate(90,[1,0,0])
    m1();
}

if(mode=="preview") {
//rotate(90,[1,0,0])
    {
m1();
//translate([8,D/4,-1])
//m2();
}
}