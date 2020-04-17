use <syms.scad>
use <9g_servo.scad>

MAOAM_DIMS=[27.7,8.6,15.8]+[1,1,1];
W=1.6;
EPS=1e-5;
CAPACITY=6;

module maoam() {
    cube(MAOAM_DIMS);
}

module storage() {
    
    H=MAOAM_DIMS[2]*CAPACITY;
    difference() {
        translate([0,0,H/2])
        hull()
        symZ([0,0,H/2+W])
        cube([MAOAM_DIMS[0],MAOAM_DIMS[1],EPS]+2*[W,W,0],center=true);

//        translate([0,0,H/3])
        // center cut
        translate([0,0,H/2])
        hull()
        symZ([0,0,H/2])
        cube([MAOAM_DIMS[0],MAOAM_DIMS[1],EPS],center=true);
        
        // loader cut
        translate([0,W,H-MAOAM_DIMS[2]/2])
        cube(MAOAM_DIMS+[0,2*W,0],center=true);
        
        
        // ejector cut
        translate([0,0,MAOAM_DIMS[2]/2])
        cube(MAOAM_DIMS+[3*W,0,0],center=true);
        
        
        
    }

}

//9g_motor();


storage();