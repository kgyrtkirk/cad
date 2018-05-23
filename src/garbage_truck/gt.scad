
use <../syms.scad>

AS_U=12;        //  attachment hole size
AS_V=3;
W=2;

RZ=13;  //  base cyl dist (12 ; but there are some glue)
ATT_DIST=10;  //  attach dist from base
ATT_V=4;      // attach vertical thickness
ATT_H=2;      // attach horizontal thickness
HOLE_DIST=4;
HOLE_Y=1;
HOLE_D=1;

P_DIST=0.7;


HOLDER_THICKNESS=4; // remaining holder thickness
HOLDER_Y=3;         // remaining holder



CAN_X0=30/2;
CAN_Y0=30/2;
CAN_X1=40/2;
CAN_Y1=40/2;
CAN_X2=CAN_X1+W/2;
CAN_Y2=CAN_Y1+W/2;
CAN_R=5;
CAN_H=50;

module trashCan() {
    W=2;
    $fn=16;
    module roundedBlock(dim=[10,10,2],zPos=0) {
        hull()
        symXY([dim[0],dim[1],zPos]){
            sphere(d=dim[2]);
        }
    }
    
    difference() {
        union () {
            // main "cup"
            hull() {
                dx=CAN_X1-CAN_X0;
                dy=CAN_X1-CAN_X0;
                roundedBlock([CAN_X0,CAN_Y0,CAN_R]);
                roundedBlock([CAN_X1+dx,CAN_Y1+dy,CAN_R],CAN_H*2);
            }
            // enlarged top
            roundedBlock([CAN_X2,CAN_Y2,CAN_R],CAN_H);
            

        }
        hull() {
            roundedBlock([CAN_X0-W,CAN_Y0-W,CAN_R],W);
            roundedBlock([CAN_X1-W,CAN_Y1-W,CAN_R],CAN_H+W);
        }
        translate([0,0,2*CAN_H])
        cube(CAN_H*2,center=true);
    }
    
    
    module hingePost(HINGE_W,HINGE_H,HINGE_D1){
        difference() {
            hull() {
                translate([0,1,0])
                cube([HINGE_H,HINGE_W,HINGE_W],center=true);
                translate([0,HINGE_W,0])
                    rotate(90,[0,1,0])
                cylinder(d=HINGE_W,h=HINGE_H,center=true);
            }
            translate([0,HINGE_W,0])
            rotate(90,[0,1,0])
            cylinder(d=HINGE_D1,h=HINGE_H+1,center=true);
        }
    }
    
    HINGE_X=10;
    HINGE_W=4.5;
    HINGE_D0=2;
    HINGE_D1=HINGE_D0+.6;

                
    translate([0,CAN_Y2,CAN_H]) {

        symX([HINGE_X,1,-HINGE_W/2]) {
            hingePost(HINGE_W,HINGE_W/2,HINGE_D1);
        }

        difference() {
            union() {
                hull()
                    symX([HINGE_X+HINGE_W,1+HINGE_W,-HINGE_W/2]) {
                    sphere(d=HINGE_W);
                }
                translate([0,HINGE_W+1,0])
                rotate(180,[0,0,1])
                rotate(90,[1,0,0])
                hanger();

            }
            symX([HINGE_X,1,-HINGE_W/2])
            hingePost(HINGE_W+0.04,HINGE_W/2+2,HINGE_D0);
        }
        
    }
    


}

module hanger(){
    WW=AS_V-P_DIST;
        SHAVE=WW/2;
            translate([0,-WW/2,0])
        hull() {
            translate([0,SHAVE/2,10*W])
            cube([AS_U-P_DIST-2*W,WW-SHAVE,.01],center=true);
            translate([0,0,0])
            cube([AS_U-P_DIST,WW,.01],center=true);
        }
}

module hook1() {
    union() {
        translate([0,0,ATT_V+W/2])
        cube([AS_U-P_DIST,AS_V-P_DIST,ATT_V*2],center=true);
        hull() {
            cube([AS_U-P_DIST,AS_V-P_DIST,W],center=true);
            translate([0,3*W,0])
            cube([AS_U-P_DIST,AS_V-P_DIST,W],center=true);
        }
        hanger();
    }
    
    
}

module attachment() {

    difference() {

        //holder base
        rotate(90,[0,1,0])
        scale([1,1,HOLDER_THICKNESS+2*ATT_H])
        difference(){
            hull(){
                translate([0,ATT_DIST-1/2,0])
                cube([ATT_V,1,1],center=true);
                translate([0,-RZ/2,0])
                cylinder(d=RZ,h=1,center=true);
            }
            translate([0,-RZ/2,0])
            cylinder(d=RZ+.1,h=100,center=true);
            
            translate([HOLE_DIST/2,HOLE_Y,0])
            cylinder(d=HOLE_D,h=100,center=true);
            translate([-HOLE_DIST/2,HOLE_Y,0])
            cylinder(d=HOLE_D,h=100,center=true);
        }

        translate([0,-50+HOLDER_Y,0])
        cube([HOLDER_THICKNESS,100,100],center=true);
        
        translate([ATT_H/2+50,HOLDER_Y+W+50,0])
        cube([100,100,100],center=true);
        translate([-(ATT_H/2+50),HOLDER_Y+W+50,0])
        cube([100,100,100],center=true);
    }


    translate([0,ATT_DIST+AS_V/2+W,0]){
            difference() {
                cube([AS_U+2*W,AS_V+2*W,ATT_V],center=true);
                cube([AS_U,AS_V,ATT_V*3],center=true);
            }
        
    }

}

module trashCanPrint(){
    translate([0,0,CAN_H])
    rotate(180,[1,0,0])
    trashCan();
}

mode="trashCanTop";
if(mode=="hook1"){
    hook1();
}
if(mode=="attach"){
    attachment();
}
if(mode=="trashCan"){
    trashCan();
}
if(mode=="trashPrint"){
    trashCanPrint();
}

if(mode=="trashCanTop"){
    intersection() {
        trashCanPrint();
        cube([100,100,10],center=true);
    }
}
