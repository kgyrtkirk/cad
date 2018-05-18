
$fn=32;

module bigyo(D,D2,L) {
    translate([0,0,L/2])
    difference() {
        cylinder(d=D, h=L,center=true);
        cylinder(d=D2, h=L*2,center=true);
    }
}


bigyo(18,   2.1 ,   20);
translate([20,0,0])
bigyo(18,   3.1 ,   30);
