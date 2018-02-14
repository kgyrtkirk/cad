
include <threads.scad> 

$fn=32;

P=[10.7,-4.2,0];
//union() {
difference(){
union() {
translate(P) {
  cylinder(d=9.5+2,h=10.1);
  cylinder(d=6.5,h=14);
}

translate([0,0,-0.0489998])
  import("motor_block.stl");
}


translate([0,0,-.01])
translate(P) {
translate([0,0,5])
#      cylinder(d1=3,d2=4,h=10);
//#      cylinder(d1=3,d2=5,h=10);

render() metric_thread (6,1,5,internal=true);
}

}