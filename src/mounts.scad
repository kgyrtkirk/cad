use <syms.scad>
W=1.6;

$fn=32;
Z=1.5+W;

mode="dingdong2";

module hole_a(h,d=8) {
    cylinder($fn=16,d=d,h=h);
}
module hole_x(h) {
    C=h;
    cylinder(d=3.6,h=100,center=true);
    translate([0,0,C+W-2.1])
    cylinder(d=6.05,h=100);
}

module mount(A,B,hole_pos,PCB_H=3.5,MOUNT_BODY_D=8,INSET=1,TP=0) {
    C=PCB_H;
    K=MOUNT_BODY_D;
    Q=INSET;
    difference() {
        minkowski() {
            union() {
                linear_extrude(height=C)
                translate([0,TP/2])
                square([A,B+TP],center=true);
                for(p=hole_pos) {
                    translate(p)
                    hole_a(PCB_H,K);
                }
            }
            sphere(W,$fn=8);
        }
        linear_extrude(height=100,center=true)
        offset(-Q)
        square([A,B],center=true);

        linear_extrude(height=2*C,center=true)
        square([A,B],center=true);

        for(p=hole_pos) {
            translate(p) {
                hole_x(C);
            }
        }
        translate([-100,-100,-200])
        cube(200);
    }
}

if(mode=="sound16") {
    A=48.5;
    B=40.8+.3;
    hole_pos=[ [A/2+Z,0],-[A/2+Z,0] ];
    mount(A,B,hole_pos,PCB_H=3.5);
}

if(mode=="rc522") {
    A=40;
    B=60;
    hole_pos=[ [A/2+Z,0],-[A/2+Z,0] ];
    mount(A,B,hole_pos,TP=5);
}

if(mode=="hourglass") {
    A=40;
    B=84;
    K=B/2-9;
    hole_pos=[  [A/2+Z,-K],-[A/2+Z,-K] ,
                [A/2+Z, K],-[A/2+Z, K] ];
    mount(A,B,hole_pos,PCB_H=3);
}

if(mode=="dingdong") {
    A=27.5;
    B=24;
    K=0;
    PCB_H=3.5;
    hole_pos=[  [A/2+Z,-K],-[A/2+Z,-K] ,
                 ];
    
    difference() {
        mount(A,B,hole_pos,PCB_H=PCB_H);
        translate(-[A/2,-B/3,0])
        cube([6,100,PCB_H+W/3]);
    }
}

if(mode=="dingdong2") {
    
    A=27.5;
    B=24;
    K=0;
    PCB_H=3.5;
    hole_pos=[  [A/2+Z,-K],-[A/2+Z,-K] ,
                 ];
    
    H=10;
    D=29.2;
    D1=D+2*W;
    D2=D;
    $fn=64;
    mirror([0,0,1])
    difference() {
        union() {
            cylinder(d=D1,h=H);
        for(p=hole_pos){
            translate(p)
                hole_a(H+W);
        }
            intersection() {
                translate([0,0,H])
                cylinder(d1=D1,d2=D2,h=W);
                for(i=[0:72:360]) {
                    rotate(i)
                    hull() {
                        cylinder(d=3,h=3*H,center=true);
                        translate([D/2,0,0])
                        cylinder(d=3,h=3*H,center=true);
                    }
                }
            }
            difference() {
                translate([0,0,H])
                cylinder(d1=D1,d2=D2,h=W);
                cylinder(d=D-2*W,h=4*H,center=true);
                
            }
        }
        for(p=hole_pos){
            translate(p)
                hole_x(H);
        }
        cylinder(d=D,h=2*H,center=true);
        cube([6,100,PCB_H+W/3]);
    }
    
}
