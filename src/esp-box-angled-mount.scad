use<syms.scad>
Q=6.8+16.55;
L=30;
W=1.6;
H=20;

echo(Q);

A=45;
HOLE_D=3.5;
HOLE_DIST=10;   // hole-dist


rotate(A,[1,0,0])
translate([0,Q/2,H/2])
difference() {
    cube([L,Q+2*W,H+2*W],center=true);
    translate([0,0,W])
    cube([2*L,Q,H+2*W],center=true);
}


hull() {
    rotate(A,[1,0,0])
    translate([0,Q/2,-W/2])
    difference() {
        cube([L,Q+2*W,W],center=true);
    }
    translate([0,Q/2,-W])
    cube([L/2,Q,W],center=true);
}

    difference() {
        $fn=32;
        if(false) {
        hull()
        symX([L/2+HOLE_DIST,Q/2,-W])
        cylinder(d=HOLE_DIST,h=W,center=true);
        }else {
        translate([0,Q/2,-W])
    cube([L+3*HOLE_DIST,HOLE_DIST,W],center=true);
        }
        
        symX([L/2+HOLE_DIST,Q/2,-W])
        cylinder(d=HOLE_D,h=3*W,center=true);
    }
    


//cube(Q);