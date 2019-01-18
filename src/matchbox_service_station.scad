use <syms.scad>

W=1.6;
CAR_W=43;
CAR_L=77;
CAR_H=20;

WHEEL_W=10;
//%cube([CAR_W,CAR_L,CAR_H]);

PLATFORM_W1=CAR_W+2*W;
PLATFORM_W2=CAR_W+2*W;
PLATFORM_H1=3*W;
PLATFORM_H2=2*W;

RAMP_ANGLE=10;
RAMP_RATE=1/tan(RAMP_ANGLE);

PLATFORM_L2=CAR_L+2*W+RAMP_RATE*PLATFORM_H2;
PLATFORM_L1=PLATFORM_L2+RAMP_RATE*PLATFORM_H1;

WHEEL_CENTER=CAR_W-WHEEL_W;


module basePart(PLATFORM_W1,PLATFORM_L1,PLATFORM_H1) {
    E=RAMP_RATE*PLATFORM_H1;
    rotate(90,[0,1,0])
    rotate(90)
    translate([0,0,-PLATFORM_W1/2])
    linear_extrude(height=PLATFORM_W1) {
        polygon([
                [0,0],
                [PLATFORM_L1,0],
                [PLATFORM_L1,PLATFORM_H1],
                [E,PLATFORM_H1]
            ]);
    }
}


module platform1() {
    E=RAMP_RATE*PLATFORM_H1;
    translate([0,-E-PLATFORM_L2/2,0])
    difference() {
        basePart(PLATFORM_W1,PLATFORM_L1,PLATFORM_H1);
        translate([0,E+PLATFORM_L2/2,0])
        cube([PLATFORM_W2-2*W,PLATFORM_L2-2*W,20],center=true);
        translate([0,E/2,0])
        cube([CAR_W-2*WHEEL_W,E-4*W,20],center=true);
    }
}

PLATFORM_RAIL_H=PLATFORM_H2+PLATFORM_H2;

module platform2() {
    E=RAMP_RATE*PLATFORM_H2;
    translate([0,-PLATFORM_L2/2,0])
    difference() {
        union() {
            color([0,1,0])
            basePart(PLATFORM_W2-2*W,PLATFORM_L2,PLATFORM_H2);
            symX([PLATFORM_W2/2-W,PLATFORM_L2/2,0]) {
                difference() {
                    hull() 
                    symY([0,PLATFORM_L2/2,PLATFORM_RAIL_H/2])
                    rotate(90,[0,90,0])
                    cylinder($fn=16,d=PLATFORM_RAIL_H,h=W);
                    N=32;
                   for(i=[1:3:N-1]) {
                        e=PLATFORM_L2/N;
                    translate([0,e*i-PLATFORM_L2/2,0])
                    hull()
                        symY([0,e/2,PLATFORM_RAIL_H/2])
                    rotate(90,[0,90,0])
                    cylinder($fn=16,d=PLATFORM_RAIL_H-2*W,h=W*3,center=true);
                    }
                }
            symX([PLATFORM_W2/2-W,PLATFORM_L2/2,0]) 
                    rotate(90,[0,90,0])
                    cylinder($fn=16,d=PLATFORM_RAIL_H,h=W);
            
//            cube([W,PLATFORM_L2,PLATFORM_H2]); 
//                translate([W/2,0,PLATFORM_H2])
  //          basePart(W,PLATFORM_L2,PLATFORM_H2*2);
            }
        }
        translate([0,E+CAR_L/2+W,0]) {
            cube([PLATFORM_W2-2*WHEEL_W-4*W,CAR_L,20],center=true);
    color([0,0,1])
           for(i=[0:1:CAR_L/W]) {
               h=(i%2)==0 ? W : 2*W;
            symX([(CAR_W-WHEEL_W)/2,-CAR_L/2+i*W,PLATFORM_H2])
                cube([WHEEL_W,W+.1,h],center=true);
           }
        }
        
    }

//    symX([WHEEL_CENTER/2,0,0])
 //   cube([WHEEL_W,CAR_L,2],center=true);
}


platform1();

    translate([0,0,PLATFORM_H1+.1])
    platform2();
