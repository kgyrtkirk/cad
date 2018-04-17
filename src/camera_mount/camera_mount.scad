

//use <ballJoint.scad>

$fn=32;

BJ_R=5;                 //  internal radius
BJ_FOUNDATION_H=BJ_R/4; //  foundation dist
BJ_FOUNDATION_R=BJ_R/2; //  foundation r
BJ_W=1.2;               //  wall width
BJ_SPACING=-.1;          //  extra spacing between b&j
BJ_JLEN_RATIO=1.5;      //  1=half ; 2=closed
BJ_CLAW_CNT=4;
BJ_CUTOUT_WIDTH=3;
BJ_CUTOUT_HEIGHT=8;
    
module  bj_ball() {
    
    translate([0,0,BJ_R+BJ_FOUNDATION_H])
        sphere(r=BJ_R,center=true);
    cylinder(r=BJ_FOUNDATION_R,h=BJ_FOUNDATION_H+BJ_R);
}


module  bj_socket() {
    
    translate([0,0,BJ_R+BJ_W+BJ_FOUNDATION_H])
    difference() {
        sphere(r=BJ_R+BJ_W,center=true);
        sphere(r=BJ_R+BJ_SPACING,center=true);
        translate([0,0,BJ_R*BJ_JLEN_RATIO])
            cube([100,100,BJ_R*2],center=true);
        
        for(i=[1:BJ_CLAW_CNT]){
            a=i*360/BJ_CLAW_CNT;
            translate([sin(a)*BJ_R,cos(a)*BJ_R,0])
            rotate(-a)
            cube([BJ_CUTOUT_WIDTH,BJ_R*2,BJ_CUTOUT_HEIGHT],center=true);
        }
    }
    cylinder(r=BJ_FOUNDATION_R,h=BJ_FOUNDATION_H+BJ_W/2);

}


module suspension(){
    
    A=6;    // hole2edge
    D=8;    // acryl diam
    W=2;

    difference() {
        translate([(W+A+D)/2,0,0])
        cube([W+A+D,30,D+2*W],center=true);
        
        translate([A+D,0,0])
        translate([-50,0,0])
        cube([100,100,D],center=true);

        translate([D,0,0])
        cylinder(d=3.2,h=30,center=true);
        
        translate([(W+A+D),0,0])
        rotate(90,[0,1,0])
        cylinder(r=BJ_FOUNDATION_R+.1,h=.6,center=true);
    }
}

module intermediate(){
    W=2;
    L=50;
    difference() {
        cylinder(r=BJ_FOUNDATION_R+W,h=L);
//        translate([(W+A+D)/2,0,0])
        cylinder(r=BJ_FOUNDATION_R+.1,h=.6,center=true);
        translate([0,0,L])
        cylinder(r=BJ_FOUNDATION_R+.1,h=.6,center=true);
    }
}

mode="intermediate";
if(mode == "bj") {
    bj_ball();
    translate([BJ_R*2+2*BJ_W,0,0])
    bj_socket();
}
if(mode == "suspension") {
    rotate(90,[0,1,0])
    suspension();
}

if(mode == "intermediate") {
    intermediate();
}

if(mode == "mount") {
    cube();
}
