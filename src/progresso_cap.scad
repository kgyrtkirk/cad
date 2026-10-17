use <syms.scad>


mode="75";
//@OUTPUT:74
//@OUTPUT:75
//@OUTPUT:76

DI=toInt(mode)/10;

difference() 
{

    minkowski()  {
    linear_extrude(height = 17)
    offset(r=2,$fn=64) 
    circle(d=DI,$fn=3);
        sphere(d=2,$fn=32);
    }
    cylinder(d=DI,h=200,center=true,$fn=64);

}

//    offset(r = 10) { square(20, center = true); }
