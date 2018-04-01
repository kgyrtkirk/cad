

H=15;

D0=26;
D1=32;
O=3;
$fn=64;
HOLE=1;

module half() {

    union() {
        translate([0,0,H/2])
        difference(){
            cylinder(d=D1,h=H,center=true);
            cylinder(d=D0,h=H+1,center=true);
            translate([-D1,-O/2,-D1])
            cube(2*D1);
        }
        
        
        DI=D1-D0;
        RX=(D0+D1)/2/2;
        for(x=[-RX,RX]){
            translate([x,0,H/4]) {
                difference(){
                    hull(){
                        cylinder(d=O,h=H/2,center=true);
                        translate([0,-O/2,0])
                        cube([DI/2,0.1,H/2],center=true);
                    }
                    cylinder(d=HOLE,h=H,center=true);
                }
            }
        }
    }

}

half();