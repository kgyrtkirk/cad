
$fn=64;
delta=.0;
h=10;
collar_r=.8;
collar_h=.3;

module m(d1=4.4,d2=3.1){
    difference() {
        union() {
            cylinder(d=d1-delta,h=h);
            cylinder(d=d1+collar_r*2,h=collar_h);
        }
        cylinder(d=d2+delta,h=3*h,center=true);
        
        for(i=[0:3])
        translate([0,0,i*h/3])
        rotate(90*i)
        cube([10,1,h/2],center=true);
    }
}

mode="m36";
if(mode=="m44") {
    m(4.6);
}

if(mode=="m36") {
    m(5);
}
