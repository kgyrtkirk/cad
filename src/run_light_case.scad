use <syms.scad>
W=1.6;

$fn=32;

L=60;
K=10;

S=52;   
D=3.5; // led dia
Z=3.65;

E=K;

difference() {
    
    hull() {
        symX([L/2+K/2,0,0])
        cylinder(d=K,h=Z+W,center=true);
    }
    
    translate([0,W,W])
    cube([L,K,(Z+W)],center=true);
    
    N=10;
    A=S-D;
    for(i=[0:N-1]) {
        translate([(i-(N-1)/2)*A/(N-1),0,0])
            cylinder(d=D,center=true,h=K);
    }

    symX([L/2+K/2,0,0]) {
        cylinder(d=3.6,center=true,h=K);
        mirror([0,0,1])
        cylinder(d=6,h=K);
    }
    
}