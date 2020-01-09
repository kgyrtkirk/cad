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

RAMP_ANGLE=8;
RAMP_RATE=1/tan(RAMP_ANGLE);

PLATFORM_L2=CAR_L+2*W+RAMP_RATE*PLATFORM_H2;
PLATFORM_L1=PLATFORM_L2+RAMP_RATE*PLATFORM_H1;

WHEEL_CENTER=CAR_W-WHEEL_W;


ELEVATE_H=50;   //  elevator height
AXIS_D=W;



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
            
//            cube([W,PLATFORM_L2,PLATFORM_H2]); 
//                translate([W/2,0,PLATFORM_H2])
  //          basePart(W,PLATFORM_L2,PLATFORM_H2*2);
                if(false)
            hull()
                translate([-PLATFORM_W2/8,0,0])
            symX([PLATFORM_W2/8-W,PLATFORM_L2/2,PLATFORM_RAIL_H/2]) 
            rotate(90,[0,90,0])
            cylinder($fn=16,d=PLATFORM_RAIL_H,h=W);
            }
            hull()
            symX([PLATFORM_W2/2-W,PLATFORM_L2,PLATFORM_RAIL_H/2]) 
            rotate(90,[0,90,0])
            cylinder($fn=32,d=PLATFORM_RAIL_H,h=W);


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


module hullLine() {
    for(o = [0:$children-2])  {
        hull() {
            children(o+0);
            children(o+1);
        }
    }
}

module frameL() {
    $fn=32;
    D=AXIS_D+2*W;
    FRAME_L_FOOT=30;
    
    p0=[(PLATFORM_H1+PLATFORM_RAIL_H)/2,ELEVATE_H,0];
    p1=[FRAME_L_FOOT,0,0];
    color("red")
    difference() {
        hullLine() {
            translate(p0)
            cylinder(d=D,h=W);
            cylinder(d=D,h=W);
            translate(p1)
            cylinder(d=D/2,h=W);
        }
        translate(p0)
            cylinder(d=AXIS_D,h=10,center=true);
            cylinder(d=AXIS_D,h=10,center=true);
    }
}


function rotX(v,a)=[
        v[0],
        v[1]*cos(a) - v[2]*sin(a),
        v[1]*sin(a) + v[2]*cos(a)
    ];


module  preview(alpha) {
    platform1();

    
    translate(rotX([0,ELEVATE_H,0],alpha))
    translate([0,0,PLATFORM_H1+.1])
    platform2();


    //translate([0,-CAR_L*2/3,0])
    for(a=[-ELEVATE_H-10,0])
    translate([0,a,0])
    symX([PLATFORM_W2/2+W,-ELEVATE_H+PLATFORM_L2/2,PLATFORM_H1/2])
    rotate(alpha,[1,0,0])
    rotate(-90,[0,1,0])
    frameL();

}

preview(0);


