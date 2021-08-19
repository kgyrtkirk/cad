use <hulls.scad>
use <syms.scad>

mode="5";

A=toInt(mode);
B=8;
W=2;
WIDTH=B;
$fn=32;
SCREW_D=4;

difference() {
    hullPairs([[A,A,0],[0,0,0],[-B,0,0]],close=false)
        cylinder(d=W,h=WIDTH,center=true);
    translate([-B/2,0,0])
    rotate(-90,[1,0,0]) {
        cylinder(d=SCREW_D,h=B,center=true);
        cylinder(d1=SCREW_D,d2=2*SCREW_D,h=W);
    }
    
}
