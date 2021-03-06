use <syms.scad>

$fn=48;

W=2;
D=22;   // hole diameter
P=6;
AD=3.5;
BB=50;

WHEEL_D1=D-2*W-2*W;
WHEEL_D2=D-2*W-3*W;
WHEEL_H=D/2;

module axis(dia){
    rotate(90,[1,0,0])
    cylinder(d=dia,center=true,h=BB);
}

module frame() {
    difference() {
        union() {
            sphere(d=D);
            translate([0,0,-AD/2])
            cylinder(center=true,d=D+2*P,h=W);
        }
        sphere(d=D-2*W);
        translate([0,0,-BB/2-AD/2-W/2])
            cube(BB,center=true);
        translate([0,0,-AD/2])
        cylinder(d=D-2*W,h=AD,center=true);
        
        axis(AD);
    }
}


module wheel() {
    difference() {
        hull()
        symY([0,-WHEEL_H/6,0])
        rotate(90,[1,0,0])
        cylinder(d1=WHEEL_D1,d2=WHEEL_D2,h=WHEEL_H/3);
        

        axis(AD);
    }
}

module w1() {
    difference() {
    translate([0,WHEEL_H/2,0])
        rotate(-90,[1,0,0])
        cylinder(d=AD+W,h=(D-2*W-WHEEL_H-W/2)/2);
    
        axis(AD+.3);
    }
}

mode="preview";

if(mode=="preview") {
    difference() {
        union() {
            frame();
            wheel();
            w1();
        }
        cube(BB);
    }
}
if(mode=="frame") {
    frame();
}
if(mode=="wheel") {
    rotate(90,[1,0,0])
    wheel();
}
if(mode=="w1") {
    rotate(90,[1,0,0])
    w1();
}



