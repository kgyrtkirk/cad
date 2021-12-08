use <threadlib/threadlib.scad>
use <syms.scad>


$fn=32;
    
OR=111/2;
IR=28/2;
W=2;
H=10;

OF=.5;
mode="part";

module part() {
    
    difference() {
        rotate_extrude($fn=128,angle=180) 
        offset(OF)
        offset(-OF)
        polygon([
                [ IR,0],
                [ OR+W, 0],
                [ OR+W, H],
                [ OR, H],
                [ OR, W ],
                [IR, W],
                ]
            );
        
        translate([-OR/2,O,0])
        cylinder(d=3.5,h=20,center=true);
    }
    
    
    O=8;
    translate([OR/2,0,W]) {
        difference() {
            hull()
            for(a=[O,-O])
            translate([0,a,0])
            cylinder(d=8,h=W);
            translate([0,-O,0])
            cylinder(d=3.5,h=20,center=true);
        }
        translate([0,-O,0])
        translate([-0,0,.5/2])
        nut("M3",turns=W/.5,Douter=5);
    }
    
}

if(mode=="part") {
    part();
}

if(mode=="preview") {
    part();
    rotate(180)
    part();
}