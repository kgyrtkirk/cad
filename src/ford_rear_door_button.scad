$fn=64;


module symY(t) {
    translate(t)
        children();
    mirror([0,1,0])
        translate(t)
            children();
}


module  cappedCylinder(d=1,h=1,center=true,capB=1,capT=1) {
   sq2 =sqrt(2);
    translate([0,0,-h/2])
    {
        cylinder(d1=d-capB*sq2,d2=d,h=capB);
        translate([0,0,capB])
        cylinder(d=d,h=h-capB-capT);

        translate([0,0,h-capT])
        cylinder(d2=d-capT*sq2,d1=d,h=capB);
//    cylinder(d=d,h=h-cap,center=center);
    }
    
//    cylinder(d=d,h=h,center=center);
}

module cross() {
    W=3;
    DIA=10;
    H=50;
    cylinder(d1=DIA*2,d2=0,h=DIA);
    translate([0,0,H/2]) {
        cube([W,DIA,H],center=true);
        rotate(90)
        cube([W,DIA,H],center=true);
    }
}

D=40;
W=1.6;
P=11;
CLAMP_D=8;
CLAMP_G=2;

translate([0,0,P/2])
difference() {
    union() {
        cappedCylinder(d=D,h=P,center=true);
        translate([0,0,P/2])
        hull() {
        translate([0,0,0-CLAMP_G])
            cube([D+CLAMP_G,CLAMP_D,.1],center=true);
            cube([D,CLAMP_D,.1],center=true);
        }
    }
    translate([0,0,W])
    cappedCylinder(d=40-2*W,h=P,center=true);
    symY([0,CLAMP_D/2,W+W])
    cube([100,W/2,P],center=true);
    
}


cross();