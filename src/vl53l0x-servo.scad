
BOARD_D=1.5;
BOARD_H=12.2;
BOARD_W=15.5;
BOARD_HOLE_W1=16.6 ; // extra space added; to make the board stuck
BOARD_HOLE_DIST=(16.6 + 23.1+.2)/2 ;
echo(BOARD_HOLE_DIST);
BOARD_W2=24.6;
BOARD_HOLE_D=3.0;
BOARD_HOLE_EXT=(BOARD_W2-BOARD_HOLE_W1-2*BOARD_HOLE_D)/2;

//echo "hole_ext" % BOARD_HOLE_EXT;


module symX(t) {
    translate(t)
        children();
    mirror([1,0,0])
        translate(t)
            children();
}

module atHoles() {
    echo (24.7-2*.7-3);
    echo(BOARD_HOLE_W1+BOARD_HOLE_D);
    symX([(BOARD_HOLE_W1+BOARD_HOLE_D)/2,0,0])
        children();
}

    B_D=[BOARD_W,BOARD_H,BOARD_D];
    CHIP_W=4.3;
    CHIP_BOARD_TOP_TO_CHIP_BOTTOM=5.5;
    CHIP_BOARD_BOTTOM_TO_CHIP_TOP=9.1;
    CHIP_H=CHIP_BOARD_BOTTOM_TO_CHIP_TOP+CHIP_BOARD_TOP_TO_CHIP_BOTTOM-BOARD_H;
    CHIP_Y=CHIP_BOARD_BOTTOM_TO_CHIP_TOP-CHIP_H/2-BOARD_H/2;
//    CHIP_Y=-(CHIP_BOARD_TOP_TO_CHIP_BOTTOM-CHIP_H/2-BOARD_H/2);
//    CHIP_HH=10;
    CHIP_HH=BOARD_D;

module sensorChip(extend=0,h=CHIP_HH){
    color([0,0,1])
    translate([0,CHIP_Y,BOARD_D])
    cube([CHIP_W+extend,CHIP_H+extend,h],center=true);
}

module pcb() {
    
    difference() {
        union() {
            sensorChip();
            color([0,.7,0]) {
            cube(B_D,center=true);
            hull()
            atHoles()
            cylinder($fn=16,d=BOARD_HOLE_D+BOARD_HOLE_EXT*2,h=BOARD_D,center=true);
            }
        }
        atHoles() {
            cylinder($fn=16,d=BOARD_HOLE_D,h=BOARD_D+1,center=true);
        }
    }
    
    
}

    W=1.6;
    HOLDER_W=BOARD_W2-2*.6;
    HOLDER_H=2*W+BOARD_H+2;

module holder() {
    P_SIZE=BOARD_D+.5;
    eps=1e-4;
    atHoles() {
        intersection() {
            color([1,0,1]) {
                cylinder($fn=16,d=3,h=BOARD_D+.5,center=true);
                translate([0,0,P_SIZE-eps])
                cylinder($fn=16,d1=5,d2=3,h=BOARD_D+.5,center=true);
                translate([0,0,-P_SIZE+eps])
                cylinder($fn=16,d1=3,d2=5,h=BOARD_D+.5,center=true);
            }
            translate([0,-BOARD_HOLE_D/4,-6])
            cube([10,BOARD_HOLE_D/2,12]);
        }
    }
    
}
module servoHorn(height=1.6){
    L=32;
    DE=4;
    DI0=6;
    DI1=7.3;
    T=height;
    
    $fn=16;
    hull() {
        symX([L/2 - DE/2,0,0])
            cylinder(h=T,d=DE,center=true);
        cylinder(h=T,d=DI0,center=true);
    }
    cylinder(h=T,d=DI1,center=true);
    
    HD0=28.5;
    HD5=8.9;
    S=(HD0-HD5)/10;
    echo(5*S);
    
    for(x=[HD5/2:S:HD5/2 + 5*S+S/2]){
        symX([x,0,0])
        cylinder(h=T*5,d=1,center=true);
    }
    cylinder(h=T*5,d=5,center=true);
    
}



module servoMount0(){
    HH=3;
    translate([0,0,-HH/2])
    difference() {
        translate([0,0,HH/2-.7])
        hull()
        symX([30/2,0,0]) {
            cylinder(d=12,h=HH,center=true);
        }
//        cube([35,12,HH],center=true);
        servoHorn();
    }
}
module servoMount1(){
    HH=2;
    difference() {
        hull()
        symX([BOARD_HOLE_W1/2,0,0]) {
            cylinder(d=12,h=HH,center=true);
        }
//        cube([35,12,HH],center=true);
        cylinder($fn=30,h=50,d=5,center=true);
    }
}

SERVO_D0=4.725;

module servoMount(){
    HH=1.6;
    difference() {
        hull()
        symX([BOARD_HOLE_W1/2,0,0]) {
            cylinder(d=12,h=HH,center=true);
        }
//        cube([35,12,HH],center=true);
        cylinder($fn=30,h=50,d=SERVO_D0,center=true);
    }
}


module  fullMount0() {
    rotate(90,[1,0,0])
    holder();
//    translate([0,2,-HOLDER_H/2])
    D0=11.5+(14.3-11.5)*2;
    translate([0,7.5,0])
    servoMount();
    
}

module  fullMount() {
    D0=11.5+(14.3-11.5)*2;
    OFF=D0/2+1.6;
    
    DEPTH=8;
    D1=2.9+.1; // tight 3mm
    D2=min(5,D1+1.4*2);
    //W=(D2-D1)/2;
    W=2;
    //XSERVO_D0=4.8;
    SERVO_D1=SERVO_D0+3;
    translate([0,-OFF,0])
    difference() {
        $fn=32;
        union() {
            symX([BOARD_HOLE_DIST/2,DEPTH/2,D1/2+W]) {
                rotate(90,[1,0,0])
                difference() {
                    cylinder($fn=32,h=DEPTH,d=D2,center=true);
                    cylinder($fn=32,h=2*DEPTH,d=D1,center=true);
                }
            }
            // the servo mount body
            symX([0,0,W/2]) {
                hull() {
                    translate([BOARD_HOLE_DIST/2,DEPTH/2,0])
                    cube([D1,DEPTH,W],center=true);
                    translate([0,OFF,0])
                    cylinder(h=W,d=SERVO_D1,center=true);
                }
            }
        }
        translate([0,OFF,W/2])
        cylinder($fn=15,h=W*2,d=SERVO_D0+.5,center=true);
    }
    
//    translate([0,2,-HOLDER_H/2])
//    translate([0,7.5,0])
  //  servoMount();
    
}



mode="fullMount";
//mode="preview";
if(mode=="preview") {
    rotate(90,[1,0,0])
    pcb();
    fullMount();
}
if(mode=="fullMount") {
//    rotate(180,[0,1,0])
    fullMount();
}
if(mode=="fullMount0") {
    rotate(180,[0,1,0])
    fullMount0();
}

//minkowski() {
//    cube();
//}
