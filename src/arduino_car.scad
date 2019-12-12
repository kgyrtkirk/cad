use <syms.scad>

W=1.6;                  // wall
STOMACH=[80,120,30];    // space available inside


// 2x18650 ~ 6.4 ~ 7.2 ~ 8.4
module battery_holder(mount_holes_only=false) {
    
    color([1,0,0])
    cube([33,100,30],center=true);
    if(mount_holes_only) {
        cylinder(d=3,h=100,center=true);
    }
}

// with W wall in XYZ in mind
function    chassisPos(p) = 
    [   STOMACH[0]*p[0],
        STOMACH[1]*p[1],
        STOMACH[2]*p[2]]-STOMACH/2
;

module chassisPiece(p) {
    translate(chassisPos(p))
    cube(W,center=true);
}

module chassis() {
    /*
    difference() {
        cube(STOMACH+[2*W,2*W,0],center=true);
        cube(STOMACH+[0,0,W],center=true);
        
    }
    */
    
    for(i=[0:.5:1-.0001]) {
        symX([0,0,0]) {
        hull() {
            chassisPiece([0,i,0]);
            chassisPiece([1,i+.5,0]);
        }
        symY([0,0,0])
        hull() {
            chassisPiece([0,i,1]);
            chassisPiece([0,i+.5,0]);
        }
    }
    }
}
chassis();
//battery_holder();