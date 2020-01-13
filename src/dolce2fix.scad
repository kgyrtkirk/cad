eps=.1;
H=20;
D1=35+eps;
D2=55-eps;
W=1.6;

$fn=128;

difference() {
    cylinder(d=D2,h=H);
    cylinder(d=D1,h=3*H,center=true);
    translate([0,0,W])
    cylinder(d=D2-2*W,h=H);
}

