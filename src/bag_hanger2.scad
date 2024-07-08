$fn=64;


L=1500;
H=400;
Q=206;

HANGER_D=10;

module hangers() {
    intersection() {
        union() {
            hangerBase();
            hangerPoles();
            wallHook(36,145);
            wallHook(677,143);
        }
        hangerRange();
    }
}

module hangerPoles() {
    translate([90,H-50,0])
   rotate(90+atan2(L,H))
    for(ix=[-5:0])
    for(iy=[-0:2]) {
        translate([(ix+iy/2)*Q,iy*sqrt(3)/4*Q,0]) {
            hanger();
        }
    }
}
module hanger() {
    color([0,1,0]){
        cube([17,29,50],center=true);
        translate([0,0,20])
        mirror([1,0,0])
        linear_extrude(20) {
            A=62-17/2;
            B=57/2+5;B0=B-10;
            C=17/2;
            polygon(
                [
                    [-A,-B],
                    [C,-B],
                    [C,B0],
                    [A,B0],
                    [A,B],
                    [-C,B],
                    [-C,-B0],
                    [-A,-B0]
                ]
            );
        }
//        cube([17,29,30],center=true);
        
    }
//    17,29
//    2*62-17,57
//    cylinder(100,HANGER_D,HANGER_D);
}

module hangerBase() {
    cube([L,H,8]);
}
module wallHook(x,y) {
    translate([x,y,0])
    color([1,0,0])
    cylinder(30,HANGER_D,HANGER_D*2);
}


module hangerRange() {
    linear_extrude(200) {
        polygon(
            [
                [0,0],
                [L,0],
                [0,H],
                [0,0]
            ]
        );
    }
}


mirror([1,0,0])
hangers();

