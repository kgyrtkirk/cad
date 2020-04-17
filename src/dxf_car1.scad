
//cube();

S=3;
H=.9;
scale(S)
//translate([0,-40,0])
linear_extrude(height = H/S, center = true, convexity = 10)
import("dxf/car1.dxf");

//linear_extrude(height = 1, center = true, convexity = 10)
//   import (file = "a1.dxf", layer = "fan_top");
