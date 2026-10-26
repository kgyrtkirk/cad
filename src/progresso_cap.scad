use <syms.scad>


mode="75";
//@OUTPUT:72
//@OUTPUT:74
//@OUTPUT:76

module pCap() {


DI=toInt(mode)/10;
H=32;
TWISTS=H/4;

difference() 
{

    minkowski()  {
        difference() {
            linear_extrude(height = H,center=true)
            offset(r=2,$fn=32) 
            circle(d=DI,$fn=3);
        }

        sphere(d=2,$fn=32);
    }
    cylinder(d=DI,h=200,center=true,$fn=64);

    if(false) {

        K=DI/2;
        S=2;
        for(a=[0:120:359])
        rotate(a) {
            translate([DI/2,0,K]) 
            cube([DI,S,H],center=true);
            translate([-DI/2,0,-K]) 
            cube([DI,S,H],center=true);
        }
    } else {
        K=H;
        linear_extrude(center=true,height=2*H,twist=TWISTS*360,$fn=64)
        translate([-K/2,0,0]){
            square([K,10]);
        }

        


    }
}
}

pCap();
rotate(180)
pCap();

//    offset(r = 10) { square(20, center = true); }
