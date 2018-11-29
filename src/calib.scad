$fn=64;

mode="push_in";
mode="islands";
mode="circles";

if(mode=="push_in") {
    e=0.1/2;
    cylinder(d=10-e,h=5);
    translate([15,0,0])
    difference(){
    cylinder(d=15,h=5);
    cylinder(d=10+e,h=30,center=true);
    }
}

module ring(d,W=2,H=1){
    difference() {    
        cylinder(h=H,d=d+W);
        cylinder(h=22,d=d,center=true);
    }
}

if(mode=="islands") {
    ring(70);
    for(i=[1:12]) {
        rotate(i*30,[0,0,1])
        translate([20,0,(i%3)*H])
        ring(13*i %10 + 0);
    }
}

if(mode=="circles") {
    ring(200,H=.6);
}