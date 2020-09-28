
//https://nettfront.hu/hu/termekek/ii-kategoria/a12-r6

$fn=32;

W=1.6;

D=18;
HX=128+56/2+10;
HY=56/2+10;

module base() {
    mirror([0,0,1])
    intersection() {
        union() {
            translate([0,0,D/2-3]) {
                sphere(d=D);
                rotate(-90,[1,0,0])
                cylinder(d=D,h=HY);
                rotate(90,[0,1,0])
                cylinder(d=D,h=HX);
            }
            cube([HX,HY,W]);
        }
        cube(2*[HX,HY,W],center=true);
    }
}

difference() {
    union() {
        base();
        translate([0,50+6,0])
        mirror([0,1,0])
        base();
    }
    for(x=[0,128])
        translate([x+6+50/2,56/2,0])
        cylinder(d=2,h=100,center=true);
    
    translate([HX/2,56/2,0])
    cylinder(d=50,h=10,center=true);
   
}