

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



module trashCan() {
    SCALE=.57;
    
    union() {
        translate([0,SCALE*-33,0])
        scale(SCALE)
        import("TrashCan-movableWheels_v3.stl");
        translate([0,0,SCALE*(100-3)])
        cube([20,3,3],center=true);
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
        hull() {
            translate([0,3*W,2*W])
            cube([AS_U-P_DIST,AS_V-P_DIST,W],center=true);
            translate([0,3*W,0])
            cube([AS_U-P_DIST,AS_V-P_DIST,W],center=true);
        }
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

mode="trashCan";
if(mode=="hook1"){
    hook1();
}
if(mode=="attach"){
    attachment();
}
if(mode=="trashCan"){
    trashCan();
}

