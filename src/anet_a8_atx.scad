include <MCAD/electronics/ATXpowerSupply.scad>
include <../libraries/raspberrypi.scad>

ATX_wireHarnesPos=[70,115];
A8_HOLES=[ [100,20,0],[100,70,0] ];
ATX_H=50;
ATX_SPACING=7;
//RPI_Z=;

RPI_P=[ ATX_SPACING+20,
        50,
        ATX_H+ATX_outlines[1]+10
        ];

s=200;
//ATX_outlines= [];
module a8_right() {
    W=5;
    rotate(-90,[0,1,0])
    difference(){
        linear_extrude(height=W)
        polygon(points=[[0,0],[400,0],[400,50],[0,100]]);
        
        for( p = A8_HOLES ) {
            translate(p)
            cylinder(20,center=true);
        }
    }
}

%a8_right();


translate([ATX_SPACING,ATX_outlines[2],ATX_H])
    rotate(90,[1,0,0]) {
        %powerSuplyATX();
    }
    
translate(RPI_P){
//    translate([
    rotate(90,[0,0,1])
    translate([85/2,-56/2,0])
%pi3();
}

