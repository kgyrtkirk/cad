use <threadlib/threadlib.scad>
use <syms.scad>

mode="ruler8";

//@OUTPUT:ruler8

HALF_DIST=20;
K=6;

W=2.4;
A=18;
L=K*HALF_DIST*2;
E=W;

if(mode=="ruler8") {

    difference() {

        translate([-E,0,-W]) {
            cube([E+A,L,W]);
            cube([E,L,W+W]);
        }

        for(i=[HALF_DIST:2*HALF_DIST:L]) {
            translate([A/2,i,0]) 
            cylinder(d=8,center=true, h=20,$fn=32);
        }

    }
}
//cube([W+A,L,W]);
