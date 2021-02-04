use <syms.scad>
W=1.6;

$fn=32;
Z=1.5+W;

mode="rc522";

module mount(A,B,hole_pos,PCB_H=3.5,MOUNT_BODY_D=8,INSET=1,TP=0) {
    C=PCB_H;
    K=MOUNT_BODY_D;
    Q=INSET;
    difference() {
        minkowski() {
            union() {
                linear_extrude(height=C)
                translate([0,TP/2])
                square([A,B+TP],center=true);
                for(p=hole_pos) {
                    translate(p)
                    cylinder($fn=8,d=K,h=C);
                }
            }
            sphere(W,$fn=8);
        }
        linear_extrude(height=100,center=true)
        offset(-Q)
        square([A,B],center=true);

        linear_extrude(height=2*C,center=true)
        square([A,B],center=true);

        for(p=hole_pos) {
            translate(p) {
                cylinder(d=3.6,h=100,center=true);
                translate([0,0,C+W-2.1])
                cylinder(d=6.05,h=100);
            }
        }
        translate([-100,-100,-200])
        cube(200);
    }
}

if(mode=="rc522") {
    A=40;
    B=60;
    hole_pos=[ [A/2+Z,0],-[A/2+Z,0] ];
    mount(A,B,hole_pos,TP=5);
}