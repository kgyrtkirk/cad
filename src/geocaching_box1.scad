use <threadlib/threadlib.scad>
use <syms.scad>


$fn=64;
W=1.6;


D=24;
DI=D-2*W;
IL=80;
L=IL+W;

MAGNET_D=5.8+.4;
MAGNET_H=2.5;

S=9;

module container() {

translate([0,0,W])
thread("PCO-1881-ext",turns=2);
difference() {
    translate(-[0,0,L-S])
    cylinder(d=D,h=L);

    cylinder(d=DI,h=3*L,center=true);
    
}
rotate(180,[1,0,0])
translate([0,0,L-S]){
    cylinder(d1=D,d2=DI,h=W);
}


module t() {
translate([D/2-W/2,0,0])
rotate(90,[0,1,0])
    children();
}

intersection() {
    union(){
        rotate(30)
        t()
        color([1,0,0])
    linear_extrude(2*W)
        text(" geocaching.com",font="Bitstream Vera Sans:style=Bold" ,size=5.5,valign="center");

        color([1,0,0])
        rotate(-30)
        t()
    linear_extrude(2*W)
        text(" Kérlek ne vidd el!",font="Bitstream Vera Sans:style=Bold" ,size=5,valign="center");
    }
        color([1,0,0])
    cylinder(d=D+2*W,h=3*L,center=true);
}

translate([0,0,-L+S]/2)
rotate(180)
t()
difference() {

ZS=-2;
    Q=3-ZS;
    hull()
    symX([10,0,ZS])
    cylinder(d1=15,d2=MAGNET_D+2*W,h=W+Q);
    symX([10,0,W+Q-MAGNET_H+ZS])
    cylinder(d=MAGNET_D,h=10);
    translate([0,0,-DI/2])
    rotate(90,[0,1,0])
    cylinder(d=DI,h=L,center=true);
    
}

}
mode="full";

if(mode=="full") {
    container();
}

if(mode=="magnet-test"){
    intersection() {
        container();
        translate([-D/2,0,-L/2-S+2])
        cube(15,center=true);
    }
}

//cube();