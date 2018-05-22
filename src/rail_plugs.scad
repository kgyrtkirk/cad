$fn=32;

ADJ=.5;

W=6.0-ADJ;
R=(11.3-ADJ)/2;
L=17.5-R;
H=11.8;

D=10;
R0=4.8;
//R0=4.6;
//R0=4.5;
O=.5;

include <threads.scad> 

module m1() {

translate([0,0,H/2]) 
difference() {
translate([0,0,-H/2]) {
    linear_extrude(H) {

        translate([-W/2,0,0])
            square([W,L]);
        translate([0,L,0])
            circle(R);
    }
}
rotate(90,[1,0,0]) {
translate([0,0,-5]) {
   metric_thread (R0,1,D,internal=true);
%   sphere(d=R0-1);
}
}

}
}

module m2() { 
        rotate(-90,[1,0,0])
    metric_thread (R0,1,D+5,internal=false);
}




rotate(90,[1,0,0]){

m1();
translate([10,0,H/2])
m2();

}