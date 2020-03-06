use <syms.scad>
previewMode="73999";
mode=previewMode;
preview=(previewMode==mode);

D=toInt(mode)/1000.0;
echo(D);
W=1.6;
EDGE_H=3;
IN=.5;

$fn=128;

difference() {
    cylinder(d=D+2*W,h=W+EDGE_H+W);
    translate([0,0,W]) {
    cylinder(d=D-2*IN,h=W+EDGE_H+W);
    cylinder(d=D,h=EDGE_H);
    }
    if(preview) {
        translate([0,0,-10])
        cube(100);
    }
    for(i=[0:30:180])
        rotate(i)
    translate([0,0,10+W+1])
    cube([2*D,W,20],center=true);
}


