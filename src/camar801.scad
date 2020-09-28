use <syms.scad>

$fn=32;

H_X=[20,20+32]+[18,18];
H_Y=42+18;
W=1.6;
D=2;
R=10/2;

difference() {
    cube([H_X[1]+H_X[0],H_Y+10,W]);
    for(x=H_X)
        translate([x,H_Y,0]) {
            cylinder(d=D,center=true,h=100);
            symX([R,0,0]) {
                cylinder(r=2,h=30,center=true);
            }
            symY([0,R,0]) {
                cylinder(r=2,h=30,center=true);
            }
        }

    
    
    translate([15,35,0])
    cylinder(d=D,center=true,h=100);
    translate([15/2,35,0])
    cylinder(d=D,center=true,h=100);
    translate([15,35/2,0])
    cylinder(d=D,center=true,h=100);
    
        translate([80,30,0])
    cylinder(d=30,center=true,h=100);
        translate([40,30,0])
    cylinder(d=30,center=true,h=100);
}

