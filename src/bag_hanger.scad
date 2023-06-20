
Q=2;
K=3.0+Q;
BACK_IN=10;        
H=10;


Z1=50;
X=20;
Z2=17;


module l() {
square([K,Z1]);
square([X,K]);
translate([X,0])
square([K,Z2]);
}


linear_extrude(H)
offset(Q/2,$fn=64)
offset(-Q)
l();