$fn=64;

W=33;
H=25;
C_DIA=23;
C_W=24;
C_H=1;

HOLE_D=44;
COVER_D=55;

module upperPart() {
    
    H1=.3;
    H2=2;
    difference() {
        union() {
            cylinder(d=COVER_D,h=H1);
            translate([0,0,H1])
            cylinder(d1=COVER_D,d2=C_DIA,h=H2);
        }
        cylinder(d=C_DIA,h=30,center=true);
        cube([C_W,C_W,(H1+H2)*2-H2],center=true);

//        cylinder(   d=HOLE_D );
        
    }
    
}

module     bottomPart() {

    difference() {
        cylinder(    d1=HOLE_D-1,d2=HOLE_D+1,h=10);
        cylinder(    d1=HOLE_D-2-1,d2=HOLE_D-2+1,center=true,h=30);
    }
}

mode="preview";

if(mode=="preview") {
    upperPart();
    bottomPart();
}

if(mode=="upper") {
    upperPart();
}
