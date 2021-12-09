
W=1.6;

$fn=32;


mode="stand";

if(mode=="plug") {

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
}
if(mode=="stand") {
    A=12;
    B=22;
    H=3;

    O1=1;
    O2=2;
    Q=2;
    difference () {
        union() {
            translate([0,0,H])
            linear_extrude(W,scale=[(A-W/2)/A,(B-W/2)/B])
            offset(r=O2)
            square([A,B],center=true);

            linear_extrude(H)
            offset(r=O2)
            square([A,B],center=true);
        }
        translate([0,0,H])
        linear_extrude(100)
        offset(r=Q/2)
        square([A-Q,B-Q],center=true);
        
    }
}