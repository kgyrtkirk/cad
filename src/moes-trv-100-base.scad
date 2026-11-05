use <threadlib/threadlib.scad>
use <syms.scad>

mode="ai";

//@OUTPUT:ai

HALF_DIST=20;
K=6;

W=2.4;
A=18;
L=K*HALF_DIST*2;
E=W;

if(mode=="ruler81") {

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



if(mode=="mine"){
difference() {
    union() {
        cylinder(d=46, h=3);
        cylinder(d=46, h=3);
    }
    cylinder(d=18, h=10,center=true);
}
}

if(mode=="ai") {
    

// valve connector — decoded from valve-connector.stl (axis at origin; STL has it at 150,150)
$fn = 128;


RI=18/2;
RK=40/2;
RO=47.5/2; // 23.35
EPS=10e-4;


// (r, z) half-section
profile = [
    [RI, -3], [RK, -3],[RK, 0],[RO, 0], [RO, 3],
    [15, 3], [13, 5],                       // flange top -> neck
    [13, 12.2], [13.45, 12.2], [13.95, 12.7], [13, 16],  // barb
    [10.7, 16], [10.7, 5],                  // top face, inner wall
    [RI+.4, 3], [RI, 3]                      // inner flare, shelf
];

difference() {
    rotate_extrude() polygon(profile);
    for (a = [0 : 60 : 300])                // 6 radial slots, 2 wide, open at top
        rotate([0, 0, a]) translate([9, -1, 5]) cube([6, 2, 12]);

    SA=38.5;
    SD=4;
    H=4/2;
    
    // optional flange holes (skipped):
    //for (a = [0, 90, 180]) rotate([0, 0, a]) translate([18, 0, -1]) cylinder(d = 3.6, h = 5, $fn = 32);
    for (a = [0, 180]) rotate([0, 0, a]) translate([SA/2+SD/2, 0, 3-H+EPS]) {
        cylinder(d = 3, h = 15,center=true, $fn = 32);
        cylinder(d1 = 3, d2=3+2*H,h = H, $fn = 32);
    }

     symX([33/2,54,-3])
         cube([4,100,6],center=true);
     symX([37/2,54,-3])
         cube([4,100,6],center=true);
}

}