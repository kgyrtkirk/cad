$fn=32;


K=12;       //  hanger body thickness
R=20/2;     //  cherry radius
W=3;        //  wall sizes
HD=3.1;     //  hanger hook wire diameter
HDI=HD-.3;   // make the cutout smaller
H=30;       //  hanger h
// internal
O=R+K/2;    //  cherry radius off

module half() {
    translate([0,0,-H]) {
        translate([O,0,0])
        sphere(r=R);
        hull() {
            translate([O,0,0])
            sphere(d=W);
            translate([HD/2+W/4,0,H])
            sphere(d=W);
        }
    }
}

module cherry() {
    half();
    mirror([1,0,0])
    half();
} 

module product() {
    difference() {
        union() {
            cylinder(d=HD+W,h=5,center=true);
            cherry();
        }
        cylinder(d=HD,h=50,center=true);
        translate([-HDI/2,0,-50])
        cube([HDI,100,100]);

        rotate(90,[0,1,0])
        cylinder(d=1,h=50,center=true);
        translate([0,W*2/3,0])
        rotate(90,[0,1,0])
        cylinder(d=1,h=50,center=true);
        
    }
}

mode="preview";
if(mode=="def") {
    rotate(90,[1,0,0])
    product();
}
if(mode=="fitting") {
    intersection() {
    rotate(90,[1,0,0])
    product();
        cube(10,center=true);
    }
}
if(mode=="preview") {
    product();
}