use <MCAD/gears.scad>

//linear_extrude(height = 2, center = true, convexity = 10, twist = 0)
  //  gear(number_of_teeth=18,diametral_pitch=1);

//https://www.thingiverse.com/thing:5505/#files
use <publicDomainGearV1.1.scad>


n=18;


n1 = 18; //red gear number of teeth
n2 = 20; //green gear
n3 = 5;  //blue gear
n4 = 20; //orange gear
n5 = 8;  //gray rack
mm_per_tooth = 9; //all meshing gears need the same mm_per_tooth (and the same pressure_angle)
thickness    = 6;
hole         = 3;
height       = 12;

N=18;
R0=9.8;
R=(R0-5.4)*1.05;
%cube([R0,R0,1],center=true);
gear(PI*2*R/N,pressure_angle=30,number_of_teeth=N,thickness=2,hole_diameter=2,clearance=0);
/*
d1 =pitch_radius(mm_per_tooth,n1);
d12=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n2);
d13=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n3);
d14=pitch_radius(mm_per_tooth,n1) + pitch_radius(mm_per_tooth,n4);

translate([ 0,  d12, 0]) rotate([0,0,-($t+n2/2-0*n1+1/2)*360/n2]) color([0.75,1.00,0.75]) gear(mm_per_tooth,n2,thickness,hole,0,108);
translate([ d13,  0, 0]) rotate([0,0,-($t-n3/4+n1/4+1/2)*360/n3]) color([0.75,0.75,1.00]) gear(mm_per_tooth,n3,thickness,hole);
translate([ d13,  0, 0]) rotate([0,0,-($t-n3/4+n1/4+1/2)*360/n3]) color([0.75,0.75,1.00]) gear(mm_per_tooth,n3,thickness,hole);
translate([-d14,  0, 0]) rotate([0,0,-($t-n4/4-n1/4+1/2-floor(n4/4)-3)*360/n4]) color([1.00,0.75,0.50]) gear(mm_per_tooth,n4,thickness,hole,0,n4-3);
translate([(-floor(n5/2)-floor(n1/2)+$t+n1/2-1/2)*9, -d1+0.0, 0]) rotate([0,0,0]) color([0.75,0.75,0.75]) rack(mm_per_tooth,n5,thickness,height);

*/