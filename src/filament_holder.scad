use <threadlib/threadlib.scad>
use <syms.scad>
use <hulls.scad>


$fn=64;
W=1.6;

mode="def";

K=15;
L1=110; N=(15+65)/2-30+8;
L2=96;
H=30;
PD=8;

if(mode=="def") {
    translate([0,0,1.25/2])
    nut("M8", turns=H/1.25-1, Douter=K*1.5);
    
    difference() {
        hullPairs([
            [0,0,0],
            [L1,N,0],
            [L1,N-PD,0],
            [L1,N,0],
            [L1+L2,N,0],
            [L1+L2,N-PD,0],
            [L1+L2,N-PD,0],
            ],close=false) {
            cylinder(d=K,h=H);
        }
//        hull() {
  //          cylinder(d=K,h=H);
    //        translate([L1,0,0])
      //  }
        cylinder(d=8,h=H*3,center=true);
        translate([L1,N,0])
        translate([L2/2,-PD/2,0])
        cube([L2,PD,100],center=true);
    }
//    cube([L,K,H]);
}



if(mode=="def0") {
    difference() {
        $fn=64;
        cylinder(d=DI-W,h=10);
        cylinder(d=DI-W-W,h=150,center=true);
    }
}

//cube();
