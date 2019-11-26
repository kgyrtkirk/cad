
W=1.6;

THICK=.6+.5;
WIDTH=4.7+.5;
NECK=3.7+.5;
LEN=7;
S=.8;

difference() {
    cube([WIDTH+2*W,THICK+2*W,LEN],center=true);
    translate([0,0,1])
    cube([WIDTH,THICK,LEN],center=true);
    cube([NECK,THICK,LEN*2],center=true);
    
    translate([0,0,-1.5*W])
    rotate(90)
    cube([WIDTH,THICK,LEN],center=true);
//    translate([WIDTH/2-1,THICK/2,-LEN])
//    cube([WIDTH,S,LEN]);
}
