
$fn=32;

H=40;
difference() {
    cylinder(d=18,h=H,center=true);
    cylinder(d=12,h=H+1,center=true);
    for(i=[0:60:180-1]){
        rotate(i)
        hull() {
            cube([H,4,H-10],center=true);
            cube([H,.001,H-5],center=true);
        }
    }
}