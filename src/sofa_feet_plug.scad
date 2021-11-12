
W=1.6;

$fn=32;

A=8;
B=16;

O1=1;
O2=2;

difference () {
    union() {
        linear_extrude(4*W,scale=[(A-W)/A,(B-W)/B])
        offset(r=O1)
        square([A-O1,B-O1],center=true);

        linear_extrude(W)
        offset(r=O2)
        square([A,B],center=true);
    }
    linear_extrude(100,center=true)
    offset(r=-W)
    square([A,B],center=true);
    
}