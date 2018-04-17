

//use <ballJoint.scad>

$fn=20;

BJ_R=5;                 //  internal radius
BJ_FOUNDATION_H=BJ_R/4; //  foundation dist
BJ_FOUNDATION_R=BJ_R/2; //  foundation r
BJ_W=1.2;               //  wall width
BJ_SPACING=.1;          //  extra spacing between b&j
BJ_JLEN_RATIO=1.3;      //  1=half ; 2=closed
BJ_CLAW_CNT=4;
BJ_CUTOUT_WIDTH=5;
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

bj_ball();
bj_socket();
