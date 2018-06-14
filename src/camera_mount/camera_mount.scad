
//use <ballJoint.scad>

$fn=32;

BJ_R=5;                 //  internal radius
BJ_FOUNDATION_H=BJ_R/4+1; //  foundation dist
BJ_NUT_H=5;
BJ_FOUNDATION_BALL=BJ_FOUNDATION_H+BJ_NUT_H;
BJ_FOUNDATION_R=BJ_R/2; //  foundation r
BJ_W=1.2;               //  wall width
BJ_SPACING=.05;        //  extra spacing between b&j (make it stuck)
BJ_JLEN_RATIO=1.6;      //  1=half ; 2=closed
BJ_CLAW_CNT=4;
BJ_CUTOUT_WIDTH=3.5;
BJ_CUTOUT_HEIGHT=8;


BJ_SEAT_R=BJ_FOUNDATION_R;

module  bj_ball() {
    
    translate([0,0,BJ_R+BJ_FOUNDATION_BALL])
        sphere(r=BJ_R,center=true);
    cylinder(r=BJ_FOUNDATION_R,h=BJ_FOUNDATION_BALL+BJ_R);
}

module bj_thread(internal) {
    translate([0,0,-.1])
    metric_thread (diameter=BJ_R*2+BJ_W+BJ_W, pitch=1, length=6,internal=internal);
}


use <threads.scad>
module bj_nut() {
 //metric_thread (diameter=20, pitch=2, length=16, square=true, ///thread_size=2,
     //           groove=true, rectangle=3);
//    render()
    difference() {
        cylinder($fn=6,h=BJ_NUT_H,r=BJ_R+BJ_W*3);
        bj_thread(true);
    }
}

module skewZ(val) {
    multmatrix(m =  [   [1,0,0,0],
                        [0,1,0,0],
                        [0,0,1,0],
                        [0,0,0,1],
                    ]) 
    children();
}
 


module  bj_socket() {
    
    translate([0,0,BJ_R+BJ_W+BJ_FOUNDATION_H])
    difference() {
        sphere(r=BJ_R+BJ_W,center=true);
        sphere(r=BJ_R+BJ_SPACING,center=true);
        translate([0,0,BJ_R*BJ_JLEN_RATIO])
            cube([100,100,BJ_R*2],center=true);
        
        for(i=[1:BJ_CLAW_CNT]){
//        for(i=[1:1]){
            a=i*360/BJ_CLAW_CNT;
            b=(2*i+1)*360/2/BJ_CLAW_CNT;
            translate([sin(a)*BJ_R,cos(a)*BJ_R,0])
            rotate(-a)
            cube([BJ_CUTOUT_WIDTH,BJ_R*2,BJ_CUTOUT_HEIGHT],center=true);
            

//            if(false) 
                {
                        translate([0,0,-BJ_R/3])
                        rotate(3,[cos(b)*BJ_R,-sin(b)*BJ_R,0])
                        intersection() {
                            bj_nut();
                            translate([sin(b)*BJ_R,cos(b)*BJ_R,0])
                            cube(10,center=true);
                        }
                    }

        }
        
//        skewZ()
//        bj_nut();
//        bj_thread(false);
    }
    cylinder(r=BJ_FOUNDATION_R,h=BJ_FOUNDATION_H+BJ_W/2);

}




module suspension(){
    
    A=6;    // hole2edge
    D=8;    // acryl diam
    W=2;
    HOLE_D=3.2;

    difference() {
        translate([(W+A+D)/2,0,0])
        cube([W+A+D,W+A+D,D+2*W],center=true);
        
        translate([A+D,0,0])
        translate([-50,0,0])
        cube([100,100,D],center=true);

        translate([D-HOLE_D/2,0,0])
        cylinder(d=HOLE_D,h=30,center=true);
        
        translate([(W+A+D),0,0])
        rotate(90,[0,1,0])
        cylinder(r=BJ_FOUNDATION_R,h=10,center=true);
    }
}

module intermediate(){
    W=2;
    L=50;
    rotate(90,[0,1,0])
    difference() {
        
X=BJ_FOUNDATION_R+W+W;
        cube([X,X,L],center=true);
//        translate([(W+A+D)/2,0,0])

/*        translate([0,0,-L/2])
        cylinder(r=BJ_FOUNDATION_R+.3,h=.6,center=true);
        translate([0,0,L/2])
        cylinder(r=BJ_FOUNDATION_R+.3,h=.6,center=true);
*/
        
        translate([0,X/2+W/2,0])
        cube([X+1,X,L-2*W],center=true);
        translate([0,-(X/2+W/2),0])
        cube([X+1,X,L-2*W],center=true);
    }
}

module mount(){
    HI=21;      //  hight
    WI=20;      //  width    
    W=1;      //  wall
    PCB_W=1;
    PCB_I=.5;
    SP_BACK=4;  // spacing at back
    SP_FRONT=1; // spacing at front
    
    
    
    difference(){
        S=W+SP_BACK+PCB_W+SP_FRONT;
        translate([0,0,S/2])
        cube([WI,HI+2*W,S],center=true);
        
        // go to pcb middle in Z
        translate([0,0,W+SP_BACK+PCB_W/2]) {
            cube([WI+1,HI,PCB_W],center=true);
            cube([WI+1,HI-PCB_I*2,SP_BACK*2+PCB_W/1],center=true);
        }
        cylinder(r=BJ_SEAT_R,h=10,center=true);
    }
}


mode="bj";
if(mode == "bj") {
    SP=BJ_R*2+2*BJ_W;
    bj_ball();
    translate([SP,0,0])
    bj_socket();
    translate([-SP,0,0])
    bj_nut();
}
if(mode == "suspension") {
    rotate(90,[0,1,0])
    suspension();
}

if(mode == "intermediate") {
    intermediate();
}

if(mode == "mount") {
    mount();
}
