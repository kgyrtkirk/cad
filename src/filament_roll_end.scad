
use <syms.scad>;

E_R=150;
D_C=25;
X=D_C/2+5;
Y=D_C/2+5;
H=5;
module atCorners() {
    for(x=[-X,X])
    for(y=[-Y,Y])
    translate([x,y,0])
        children();
}
$fn=64;

difference() {
    hull()
    atCorners()
        cylinder(r=10,h=H,center=true);
    
    hull() {
        cylinder(d=D_C,h=2*H,center=true);
        translate([2*X,0,0])
        cylinder(d=D_C+5,h=2*H,center=true);
    }
    
    symX([X,0,0])
    symY([0,Y+5/2,0])
    cylinder(d=2.5,h=2*H,center=true);
    
translate([0,0,E_R])
rotate(90,[0,1,0])
cylinder(r=E_R,h=4*X,center=true,$fn=256);
}

