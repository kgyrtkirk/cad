use<syms.scad>
$fn=64;

W=1.6;
B_W=40;
B_H=60;


    module     allHull(p) {
        for(i = [0:len(p)-2]) {
//        for(j = [i+1:len(p)-1]) {
            hull(){
                translate(p[i])
                children();
                translate(p[i+1])
                children();
            }
        }
    }


difference() {
    R=30;
    union() {
        translate([0,0,W])
        cube([B_W+W,B_H,2*W],center=true);
        symX([B_W/2,0,0])
  //          echo([for(i=[0:10:60]) [sin(i),cos(i),0] ]);
        allHull([for(i=[0:.1:1]) R*[i,i*i*i,0] ]) {
            cylinder(d=5,h=2*W);
        }
    }
    translate([0,0,2*W])
    cube([B_W,B_H+W,2*W],center=true);
    symY([0,20,0]) {
        cylinder(d=5,h=20,center=true);
    }
    
}
