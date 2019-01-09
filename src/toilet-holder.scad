//include <syms.scad>

//$fn=16;
ARC_RES=3;
EPS=.1;

FOOT_W=10;
FOOT_H=.7;

D0=120;
W=2;
D=D0+W;
L=100;
R=D/2;

function arc(r, deg_st, deg_end, deg_inc)=
    [
        for( a = [deg_st:deg_inc:deg_end] )
            r*[ cos(a),sin(a) ],
    ];


if(false) {
polygon(
        arc(D, 0, 120 , 10)
);
        
circle(d=D);
symX([D+W,0,0])
circle(d=D);
}

module arcWall(degs0) {
    degs=abs(degs0);
    off=[D/2,0];
    xDir=degs0>=0 ? 1 : -1;
    p=(D/2*[cos(degs)*xDir,sin(degs)] - off*xDir);
    m=(degs0<0) ? [1,0,0] : [0,0,0];
    mirror(m)
    translate(-off) {
        FOOT_L=(degs0>0)?W:FOOT_W;
        FOOT_R=(degs0>0)?FOOT_W:W;

        linear_extrude(height=L)
        polygon(
            concat(
                arc(R+W, 0, degs, ARC_RES),
                arc(R-W, degs, 0, -ARC_RES)
            )
        );
        linear_extrude(height=FOOT_H)
        polygon(
            concat(
                arc(R-FOOT_L, 0, degs, ARC_RES),
                arc(R+FOOT_R, degs, 0, -ARC_RES)
            )
        );
    }
    
    translate(p)
    rotate(degs0,[0,0,1])
    children();
}

module mainPart() {
intersection() 
    {
        arcWall(-150)
        arcWall(180)
        arcWall(-240)
        arcWall(180)
        arcWall(-150)
        ;
        translate([D/2+D*cos(30)+1*cos(30)*D,D,0])
        scale([5, 4, 100/D*2])
        sphere($fn=64, D/2,center=true);
    }
}

function clearX(v3)=[0,v3[1],v3[2]];

SX=5*D;
SY=5*D;
SZ=2*D;


module splitShape0(HW,HL,SZ) {
    translate([0,-D/2,0]) {
        translate([0,-SY/2,-SZ/2])
        cube([SX,SY,SZ]);
        cube([2*HL,HW,SZ],center=true);
    }
//    sphere(d=D);
}


module splitShape1(cutOut,e) {
    HW=W+e;
    HL=2*W+e;
    translate([-e/2,0,0])
    splitShape0(HW,HL,SZ);
//    if(cutOut)
}
module splitShape(cutOut=true) {
    e=cutOut ? -EPS/2 : EPS;
    
    if(cutOut) {
        difference() {
        translate([0,-D/2,0])
            cube([2*SX-1,SY-1,SZ-1],center=true);
            splitShape1(cutOut,e);
        }
    }else{
        splitShape1(cutOut,e);
    }
    
//    splitShape0(W+1,2*W+1,2*W);
}

module part(idx) {
    difference() {
        mainPart();
    translate([D/2+D*cos(30),D/2,0])
        rotate(30,[0,0,1])
        splitShape(idx>0);
    translate([D/2+D*cos(30)+2*cos(30)*D,D/2,0])
        rotate(-30,[0,0,1])
        mirror([1,0,0])
        splitShape(idx<2);
    }
}

mode="preview";
//mode="joint";

if(mode=="part0") { part(0); }
if(mode=="part1") { part(1); }
if(mode=="part2") { part(2); }

if(mode=="preview") {
    part(0);
    part(1);
    part(2);
}
if(mode=="joint") {
    intersection() {
        union() {
        part(0);
        translate([10,5,0])
        part(1);
        }
#        translate([D/2+D*cos(30),D/2,0])
        rotate(30,[0,0,1])
        translate([5,-D/2,0])
        cube([30,20,10],center=true);

    }

}

/*
translate([D/2+D*cos(30),D/2,0])
sphere(d=D);

translate([D/2+D*cos(30)+2*cos(30)*D,D/2,0])
sphere(d=D);
*/