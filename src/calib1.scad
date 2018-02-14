$fn=64;

e=0.1/2;

cylinder(d=10-e,h=5);
translate([15,0,0])
difference(){
cylinder(d=15,h=5);
cylinder(d=10+e,h=30,center=true);
}