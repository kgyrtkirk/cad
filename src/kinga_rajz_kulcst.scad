
//cube();

S=.11;
H=.9;
D=50;

H1=.9;
H2=H1+.6;
//translate([0,-40,0])



difference() {
    union() {
        difference() {
            color([1,0,0])
            cylinder($fn=128,d=D,h=H2);
            translate([0,0,H1])
            color([1,0,0])
            cylinder($fn=128,d=D-2*1.5,h=H2);
        }



        translate([0,D/2,0])
        color([1,0,0])
        cylinder($fn=128,d=6,h=H2);
        
    }
    
        translate([0,D/2,0])
        color([1,0,0])
        cylinder($fn=128,d=3,h=10,center=true);
}


linear_extrude(height = H2, convexity = 10)
scale(S)
translate([-170,-170,0])
import("media/kinga_rajz_out.dxf");


//linear_extrude(height = 1, center = true, convexity = 10)
//   import (file = "a1.dxf", layer = "fan_top");
