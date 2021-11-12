// actually this is a mono soundmeter; but pretty similar

use <syms.scad>
W=1.6;

$fn=32;

L=170;
K=10;

S=92+67.6+3;   
D=5.5; // led dia
Z=4.65+.5;

E=K;

mode="def";

module gen() {
    difference() {
        
        hull() {
            symX([L/2+K/2,0,0])
            cylinder(d=K,h=Z+W,center=true);
        }
        
        translate([0,W,W])
        cube([L,K,(Z+W)],center=true);
        
        N=20;
//        A=S-D;
        A=136.3/17*19+1;
        for(i=[0:N-1]) {
            translate([(i-(N-1)/2)*A/(N-1),0,0])
                cylinder(d=D,center=true,h=K);
        }

        symX([L/2+K/2,0,0]) {
            cylinder(d=3.6,center=true,h=K);
            mirror([0,0,1])
            cylinder(d=6,h=K);
        }
        U=16;
        symX([S/2-U,0,0]) {
            translate([0,D/2,-Z])
            cube([U,10,10]);
        }
        
    }

}

if(mode=="def") {

    gen();
}