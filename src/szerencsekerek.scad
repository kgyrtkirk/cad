use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>
use <syms.scad>

mode="preview";

//@OUTPUT:kerek
//@OUTPUT:allvany



SLOTS=24;

D=150;
PIN_HOLE_D=1.9;
EDGE_SPACE=3;

PLATE_H=1.2;
POST_L=PLATE_H+.5+7+.5+PLATE_H;
POST_H=PLATE_H+.5+7+.5+PLATE_H+3;
///  608ZZ Dimensions: 8mm (inner) x 22mm (outer) x 7mm (width)

$fn=32;
module kerek() {

    difference() {
        union() {
            $fn=128;
            cylinder(h = PLATE_H, d=D);
            cylinder(d1=33,d2=25, h=PLATE_H+5);
        }
        $fn=32;
        translate([0,0,PLATE_H]) 
            cylinder(d=18, h=PLATE_H+5);
        translate([0,0,PLATE_H+.5]) 
            cylinder(d=22.5, h=PLATE_H+5);

        for( a = [0:360/3/SLOTS:359]) {
            rotate(a, [0,0,1]) {
                translate([D/2-EDGE_SPACE,0,-10]) 
                cylinder(h=20, d=PIN_HOLE_D);
            }
        }
    }
}

STAND=[D/2,10,PLATE_H];
module allvany() {

    for( a = [0:120:359]) {
        rotate(a, [0,0,1]) {
            translate([0,STAND[1],0]/-2) 
                cube(STAND);
        }
    }
    translate([D/2,0,STAND[2]/2]) {
        cube([30,STAND[1],STAND[2]],center=true);
    }
    translate([D/2+10,0,0]) {
        translate([0,0,POST_L/2])
        cube([10,2,POST_L],center=true);
        symY([0,1.1,POST_H/2])
        cube([10,2,POST_H],center=true);
    }

    cylinder(h = 7, d=7);
    cylinder(h = PLATE_H+.5, d=11);

    // cylinder(h = h, r = r);
}


if(mode=="preview") {
    allvany();
    translate([0,0,(PLATE_H*2+7+1)]) 
    rotate(180,[1,0,0]) 
    kerek();
}
if(mode=="kerek"){
    kerek();
}
if(mode=="allvany"){
    allvany();
}
