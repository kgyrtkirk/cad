

I1=26;
I2=14;
J=57;

I=I1+I2;

W=1.2;

$fn=64;

A=8;
B=16;

O1=1;
O2=2;


module shape1() {
    difference() {
        offset(r=I2)
        translate([0,I1/2])
        square([J-2*I2,I1],center=true);
        translate([0,-50,0])
        square(100);
    }
    
}


module shape() {
    A=63.65;
    difference() {
    translate([-48+4,-A/2,0])
    scale(A/620)
    import("dxf/cl_end.dxf");
        translate([100,0,0])
        square(200,center=true);
    }
}
module shapeI() {
    offset(r=-1.5)
    shape();
}


mode="main";

if(mode=="def") {

linear_extrude(1)
difference() {
        shape();
        offset(r=-2*W)
        shape();
}
}

if(mode=="main") {
    
    linear_extrude(W)
    shape();
    translate([0,0,W])
    difference() {
        linear_extrude(5)
            difference() {
                    shapeI();
                    offset(r=-2*W)
                    shapeI();
            }
            translate([-30,0,0])
        cube([15,100,10],center=true);
    }
    
}


if(false)
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