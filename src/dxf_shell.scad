
//cube();

S=1.45;
H=.6;
scale(S)
translate([0,-70,0])
linear_extrude(height = H/S, center = true, convexity = 10)
import("dxf/Shell-512.dxf");

//linear_extrude(height = 1, center = true, convexity = 10)
//   import (file = "a1.dxf", layer = "fan_top");
