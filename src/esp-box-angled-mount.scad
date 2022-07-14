use<syms.scad>
Q=6.8+16.55;
L=30;
W=2;
H=20;

echo(Q);

A=45;
HOLE_D=4.5;
HOLE_DIST=20;   // hole-dist


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
        translate([0,Q,0])
        cube([HOLE_DIST,L,3*W],center=true);
        }
        
        translate([0,L,-W])
        cylinder(d=HOLE_D,h=13*W,center=true);
    }
    


//cube(Q);