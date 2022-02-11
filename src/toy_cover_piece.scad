$fn=32;

L=62;
W=51;
H=4;
CUT_W=25;
CUT_DEPTH=2;
CUT_H=2;

HOLE_K=65;
HOLE_P_D=9;

difference() {
    union() {
    
    translate([0,L/2,H/2])
    cube([W,L,H],center=true);

    difference() {
        hull() {
            translate([0,HOLE_K,H/4])
            cylinder(d=HOLE_P_D,h=H/2,center=true);
            translate([0,HOLE_K/2,H/4])
            cylinder(d=HOLE_P_D,h=H/2,center=true);
        }
        translate([0,HOLE_K,H/4])
        cylinder(d=3.4,h=H,center=true);
    }

    translate([0,0,CUT_H/2])
    cube([CUT_W,CUT_DEPTH*2,CUT_H],center=true);
}
    translate([0,HOLE_K,H/2])
    cylinder(d=10,h=H);

}