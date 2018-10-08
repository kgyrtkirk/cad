
// For the mini c270 box credit goes to Sp0nge:
// https://www.thingiverse.com/thing:1807604

W=2.2;
D=3.4;
L=5;
S=4;
K=5;
$fn=16;

module mount0(d=K,L0=L,NUT=true){
    
    difference() {
        L=5;
        hull() {
            cylinder(d=D+2*W,h=L0,center=true);
            translate([S,0,0])
            cube([0.1,d,L0],center=true);
        }
        cylinder(d=D,h=2*L0,center=true);
        if(NUT)
        for(z=[-L0/2])
        translate([0,0,z])
        cylinder($fn=6,d=6.35,h=2,center=true);
    }

}

module cameraHolder() {
    translate([-49,59/2,-11/2])
//    rotate(180,[0,0,1])
    rotate(90,[1,0,0])
    import("stl/c270__mini_bottom_closed.stl");

    translate([-S,-L/2,0])
    rotate(-90,[1,0,0])
    mount0();
}

module foot() {
    FOOT_W=7.5;
    FOOT_H1=4;
    FOOT_L0=33;
    FOOT_H2=15;
    
    module  negative_part() {
        cube([FOOT_L0,FOOT_W,FOOT_H2+1]);
        translate([-FOOT_L0+.01,0,FOOT_H1])
        cube([FOOT_L0,FOOT_W,FOOT_H2]);
    }
    
    difference() {
        translate([0,0,FOOT_H2/2+.01])
        cube([FOOT_L0+2*W,FOOT_W+2*W,FOOT_H2],center=true);
        translate([-FOOT_L0/2,-FOOT_W/2,0])
        negative_part();
    }
    translate([FOOT_L0/2+K+W/2,0,FOOT_H2-L/2])
    mirror([1,0,0])
    mount0();
}

function xa(x)= x+1;

module hullPairs(pos){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
    
}
module middle() {
    rotate(90,[1,0,0])
    translate([-S,0,0])
//    mirror([0,0,1])
    mount0(PH,L0=W,NUT=false);
    PH=K+3;
    T=[50,120,0];
    E=T[1]/T[0];
    A=T[0]/E;
    posArr=[ for (x = [0 : E/30 : E+E/1000]) [x,x*x,0]*A ];
    hullPairs(posArr)
        cylinder(d=W,h=PH,center=true);
        
    
    translate(T)
    translate([0,S,0])
    rotate(-90,[0,0,1])
    mount0(d=W,L0=PH);
    
    

//    mount0();
    
}

mode="foot";
mode="middle";
mode="cameraHolder";
if(mode=="cameraHolder") {
    cameraHolder();
}
if(mode=="foot") {
    rotate(180,[1,0,0])
    foot();
}
if(mode=="middle") {
    rotate(180,[0,1,0])
    middle();
}


