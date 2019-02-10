use <syms.scad>;

/*

before v1:
 * decide distance /places of magnets
 * add small grooves between wheel/body
 * reduce lost to 0?



*/

RAIL_DEPTH=3;
SP=1;
W=1.6;

WHEEL_DIST=(20.5+31)/2;



L=80;
WHEEL_PLATFORM_FOUNDATION_L=20;
MAGNET_SPACING=40;
AXIS_L=L-WHEEL_PLATFORM_FOUNDATION_L;
SPACER_H=.8;    // screw spacer
AXIS_R=3.3/2;
WHEEL_R=RAIL_DEPTH+SP+W+AXIS_R;
WHEEL_H=3;
SCREW_L=12; // 12/8
NUT_H=3;
eps=1e-4;
SIDE_W=WHEEL_DIST-WHEEL_H-2*W;
CARRIAGE_H=WHEEL_R;
AXIS_LOST_LENGTH=.8;
$fn=32;

module wheel() {
    ROD_R=AXIS_R+.1;
    H1=WHEEL_H/4;
    H2=WHEEL_H/2;
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
    SCREW_STOP=(SIDE_W/2+SPACER_H+WHEEL_H*5/8+AXIS_LOST_LENGTH+W)-SCREW_L;
    echo(SCREW_STOP);
    module side() {
        hull() {
            rotate(90,[1,0,0])
            cylinder(r=AXIS_R+W,h=SIDE_W,center=true);
            translate([0,0,CARRIAGE_H])
                cube([WHEEL_PLATFORM_FOUNDATION_L,SIDE_W,eps],center=true);
        }
        rotate(90,[1,0,0]) {
            cylinder(r=AXIS_R+W,h=SIDE_W,center=true);
            
            symZ([0,0,SIDE_W/2])
            cylinder(r1=AXIS_R+W,r2=AXIS_R,h=W);
        }
        
    }
    
    module cutoutPattern() {
        D_NUT=5.5/cos(30);
        echo("DN",D_NUT);
        translate([0,-SCREW_STOP,0])
        rotate(90,[1,0,0]) {
            cylinder(r=AXIS_R,h=100);
            translate([0,0,-AXIS_R])
            cylinder(r1=0,r2=AXIS_R,h=AXIS_R);
        }
        NUT_Y=SIDE_W/4;
        hull()
        for(z=[0,-10])
        translate([0,-NUT_Y,z])
        rotate(90,[1,0,0])
        rotate(90)
        cylinder($fn=6,d=D_NUT,h=NUT_H);
        
        // attachment anchor point
        translate([-2,0,5])
        rotate(45)
        rotate(-90,[0,1,0])
        cylinder(d=1,h=30,center=false);
    }
    
//    translate([0,SIDE_W/2,0])
    difference() {
        side();
        symY([0,0,0])
        cutoutPattern();
    }
    
}

module attachment(cutout=false) {
    if(cutout) {
%        cylinder(d=4,h=30);
    }else {
        AW=W/2;
        MAGNET_D=6;
        MAGNET_H=2.8;

        D1=MAGNET_D;
        H1=MAGNET_H;
        D2=MAGNET_D+2*AW;
        H2=MAGNET_H+2*AW;
        D3=cutout?4:3;
        H3=20;

        translate([0,0,-H2/2])
        difference() {
            cylinder(d=D2,h=H2,center=true);
            cylinder(d=D1,h=H1,center=true);
        }
        difference() {
            cylinder(d1=D3,d2=D3,h=H3);
            for(h=[H3-2*W,H3-4*W])
            translate([0,0,h])
            rotate(90,[1,0,0])
            cylinder(d=1,h=H3,center=true);
        }
    }
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
//        translate([0,0,CARRIAGE_H-W])
  //      cube([SIDE_W,2*W,2*W],center=true);
       //        roundedBlock([SIDE_W,SIDE_W/2,W],center=true);
//        if(false)

        symY([0,SIDE_W/2,CARRIAGE_H-W/2])
        hull()
        symX([AXIS_L/2,0,0])  {
//            sphere(r=W);
            rotate(90,[0,1,0])
            rotate(360/16)
            cylinder($fn=8,r=W);
  //          cylinder(d=W);
            
        }
    }
    
    difference() {
        intersection() {
            posPart();
            RR=W*4;
            union() {
            hull()
            symY([0,SIDE_W/2-RR,0])
            symX([L/2-RR,0,0])
                cylinder($fn=128,r=RR,h=50,center=true);
                symX([AXIS_L/2,0,0])
                rotate(90,[1,0,0])
                    cylinder($fn=128,r=AXIS_R+W,h=50,center=true);
            }
        }
        K=1.5*W;
        symX([-L/2,0,CARRIAGE_H-K-W/2])
        rotate(90,[0,1,0])
        hull() {
            symY([0,W,0]) {
                cylinder(r=K,h=40);
    //        attachment(true);
            }
            translate([W/2,0,0])
            cylinder(r=K,h=40);
        }
        
        CARGO_MAGNET_D=2;
        // cut out magnet
        symX([MAGNET_SPACING/2,0,0]) {
            cylinder(d=CARGO_MAGNET_D,h=10);
            for(d=[45,-45])
            rotate(d)
            cube([2*CARGO_MAGNET_D,W/3,30],center=true);
        }

    }
    
}


mode="preview";
if(mode=="preview") {
    difference() {
        union() {
            body();
            symX([-L/2-W,0,CARRIAGE_H-2*W])
            rotate(90,[0,1,0])
            attachment();
        }
        translate([AXIS_L/2,0,0])
        cube(20);
    }
    symX([AXIS_L/2,0,0])
    symY([0,-SIDE_W/2-W-WHEEL_H/2-SPACER_H,0])
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


if(mode=="wheel"){
    wheel();
}

if(mode=="bodyp"){
    $fn=64;
    intersection() {
        rotate(180,[1,0,0])
        body();
        translate([L/2-3,0,0])
        cube(L/2,center=true);
    }
}

if(mode=="spacer"){
    $fn=64;
    difference() {
        cylinder(r=AXIS_R+2*W,h=SPACER_H/2,center=true);
        cylinder(r=AXIS_R+.2,h=10,center=true);
    }
}

