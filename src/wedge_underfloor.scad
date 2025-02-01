use <syms.scad>

L=100;
W=50;

mode="5";
H1=.3;
H2=toInt(mode);


A=L/3;
B=A/2;
D=3;
echo("delta:",D);


module wedge() {
    translate([0,W/2,0])
    rotate(90,[1,0,0])
    linear_extrude(2*W) {
        polygon(    [
            [0,0],
            [0,H1],
            [L,H2],
            [L,0],
        ]);
    }
}

module t(D) {
    
    
    translate([L/2,0,0
    ])
    scale([.5,.5,1])
    linear_extrude(H2*3,center=true) {
        offset(D)
        polygon(    [
            [-A,-B],
            [-A,B],
            [-A-B,B],
            [-A-B,2*B],
            [+A+B,2*B],
            [+A+B,B],
            [+A,B],
            [+A,-B],
        ]);
    }
}


intersection() {
    wedge();
    union() {
        difference() {
            translate([0,-W,0])
            cube([L,W,H2]);
            translate([0,-W,0])
            t(D);
        }
        t(-D);
    }
}

