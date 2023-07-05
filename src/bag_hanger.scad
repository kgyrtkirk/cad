

K=2.0;
Q=K/2-.1;
BACK_IN=10;
H=10;
K2=2.5;


Z1=60;
X=32;
Z2=17;


module l() {
square([K,Z1]);
square([X,K*2]);
translate([X,0])
square([K,Z2]);
}


$fn=64;
module ext(l) {
linear_extrude(l) {
    offset(Q)
    offset(-Q)
    l();
    translate([0,Z1-K2])
    square([K2,K2]);
}
}

E=H;

ext(E);