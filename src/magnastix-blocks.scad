
use <syms.scad>
W=1.6;
BALL_D=11;
STICK_L=26.4;
STICK_D=5.7;
STICK_END_D=7.1;
STICK_END_H=4.1;

ENL=STICK_END_D-STICK_D;
echo("ENL",ENL);

module stickZ(off=0) {
    $fn=16;
    intersection() {
        union() {
            cylinder(h=STICK_L,d=STICK_D+off,center=true);
            symZ([0,0,(STICK_L-STICK_END_H)/2])
            sphere(d=STICK_END_D+off);
        }
        cube(STICK_L+off,center=true);
    }
}

module stick(off=0) {
    rotate(90,[0,1,0])
    stickZ(off);
}

module stickAndBall(off) {
    stick(off);
    translate([(STICK_L+BALL_D)/2,0,0])
    sphere(d=BALL_D+off,center=true);
}

module nGon(eLength,n) {
    d=360/n;
    r=eLength/2/tan(d/2);
    echo(d);
    echo("r",r);
    
    for(a=[0:d:360]) {
        translate([sin(a),cos(a),0]*r)
        rotate(-a)
        children();
    }
}


module panel(n) {
    E=STICK_L+BALL_D;
    SP=1.2;
    difference() {
//#        nGon(E,n)
//        rotate(90,[0,1,0])
  //      cylinder(d=STICK_D+SP+2*W,h=E,center=true);
        nGon(E,n)
        intersection() {
            stickAndBall(SP+2*W);
            translate([0,-E/2-W,0])
            cube([E-BALL_D+W+W,E,STICK_D+W/2],center=true);
        }
        
        nGon(E,n)
        stickAndBall(SP);
    }
}

mode="p4";

if(mode=="p4") {
    panel(4);
}
if(mode=="p3") {
    panel(3);
}