// huzos kapcsolo?

include<syms.scad>

A=260;
B=430;
B1=182;

%cube([B,A,1]);


// backlit big switch
module bigSwitch() {
    cylinder(d=23,h=5);
    color([1,0,0])
    cylinder(d=20.3,h=10);
    color([1,0,0])
    translate([0,0,10])
    linear_extrude(2)
    text("S",halign="center",valign="center");
}

module pushButtonSmall() {
    
    cylinder($fn=6,d=12,h=5);
    color([1,0,0])
    cylinder(d=8,h=10);
}

module pushButtonBig() {
    cylinder(d=17,h=5);
    color([0,0,1])
    cylinder(d=12,h=10);
}

module led() {
    cylinder(d=6,h=5);
    color([0,0,1])
    cylinder(d=5,h=10);
}
//17/12


module logicGate(w) {
    A=20;
    B=40;
    CC=[2*A,2*B,1]+[30,30,0];
    translate([0,B,0])
    led();
    for(x=[-A,A]) 
    translate([x,-B,0])
    bigSwitch();
    difference() {
        cube(CC,center=true);
        cube(CC-[1,1,-1],center=true);
    }

}

for(i=[0:3]) {
    SP=80;
    X=B/2-3*SP/2+i*SP;
//    X=30+40+i*SP;
    Y=SP;
    echo(X,Y);
    translate([X,Y,0])
    logicGate(w=100);
}
//symX([30/2,0,0])



pushButtonSmall();
led();