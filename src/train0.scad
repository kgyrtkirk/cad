use <syms.scad>;

ROD_R=3.2/2;
RAIL_DEPTH=3;
SP=1;
W=1.6;

WHEEL_DIST=(20.5+31)/2;



L=80;
AXIS_L=L*3/4;
SPACER_H=.5;
AXIS_R=3.2/2;
WHEEL_R=RAIL_DEPTH+SP+W+AXIS_R;
WHEEL_H=W;
SCREW_L=6;
NUT_H=1;
eps=1e-4;
SIDE_W=WHEEL_DIST-WHEEL_H-SPACER_H*2;
CARRIAGE_H=WHEEL_R;

$fn=32;
module wheel() {
    H1=W/4;
    H2=W/2;
    E=.3;
    DECOR_R=WHEEL_R-RAIL_DEPTH-W;
    rotate_extrude($fn=64) {
        polygon([    
            [ROD_R,-H2],
            [ROD_R,H1],
            [ROD_R*2,H1],
            [ROD_R*2,H2],
            [WHEEL_R,H2],
            [WHEEL_R,H1],
            [WHEEL_R-E,H1],
            [WHEEL_R-E,-H1],
            [WHEEL_R,-H1],
            [WHEEL_R,-H2],

            ]);
    }
}

//wheel();

module wheelPlatform() {
    SCREW_STOP=(SIDE_W/2+SPACER_H+WHEEL_H)-SCREW_L;
    echo(SCREW_STOP);
    module side() {
        hull() {
            rotate(90,[1,0,0])
            cylinder(r=AXIS_R,h=SIDE_W,center=true);
            translate([0,0,CARRIAGE_H])
                cube([15,SIDE_W,eps],center=true);
        }
        rotate(90,[1,0,0])
        cylinder(r=AXIS_R+W,h=SIDE_W,center=true);
    }
    
    module cutoutPattern() {
        translate([0,-SCREW_STOP,0])
        rotate(90,[1,0,0])
        cylinder(r=AXIS_R,h=100);
        NUT_Y=( SIDE_W/2+SCREW_STOP)/2;
        hull()
        for(z=[0,-10])
        translate([0,-NUT_Y,z])
        rotate(90,[1,0,0])
        rotate(90)
        cylinder($fn=6,d=5.5,h=NUT_H);
    }
    
//    translate([0,SIDE_W/2,0])
    difference() {
        side();
        symY([0,0,0])
        cutoutPattern();
    }
    
}

module attachment() {
    AW=W/2;
    MAGNET_D=6;
    MAGNET_H=2;

    D1=MAGNET_D;
    H1=MAGNET_H;
    D2=MAGNET_D+2*AW;
    H2=MAGNET_H+2*AW;
    D3=3;
    H3=20;

    translate([0,0,-H2/2])
    difference() {
        cylinder(d=D2,h=H2,center=true);
        cylinder(d=D1,h=H1,center=true);
    }
    cylinder(d1=D3,d2=D3,h=H3);
}

module roundedBlock(dim=[10,10,2],zPos=0) {
    hull()
    symXY([dim[0],dim[1],zPos]){
        sphere(d=dim[2]);
    }
}


module body() {
    module posPart() {
        symX([AXIS_L/2,0,0])
        wheelPlatform();
        translate([0,0,CARRIAGE_H])
        cube([L/2,SIDE_W/2,W/2]*2,center=true);
        translate([0,0,CARRIAGE_H-W])
        cube([SIDE_W,2*W,2*W],center=true);
       //        roundedBlock([SIDE_W,SIDE_W/2,W],center=true);
        if(false)
        symX([AXIS_L/2,0,0])  {
            cylinder(d=CARRIAGE_H);
            cylinder(d=W);
            
        }
    }
    
    difference() {
        posPart();
        symX([-L/2,0,CARRIAGE_H-W-W-W])
        rotate(85,[0,1,0])
        hull()
        symY([0,W,0])
        attachment();
        
        symX([SIDE_W/4,0,CARRIAGE_H-W])
        rotate(90,[1,0,0])
        cylinder(d=1,h=10,center=true);
    }
    
}


mode="body";
if(mode=="preview") {
    body();
    symX([AXIS_L/2,0,0])
    symY([0,-SIDE_W/2-WHEEL_H/2-SPACER_H,0])
    rotate(90,[1,0,0])
    wheel();
}
if(mode=="wp") {
    wheelPlatform();
    translate([0,-SIDE_W/2-WHEEL_H/2-SPACER_H,0])
    rotate(90,[1,0,0])
    wheel();
}

if(mode=="attach"){
    attachment();
}

if(mode=="body"){
    $fn=64;
    rotate(180,[1,0,0])
    body();
}