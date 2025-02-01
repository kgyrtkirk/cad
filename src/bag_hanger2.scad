$fn=64;


lost=11;
H0=400;
H=H0-lost;
L=1500*H/H0;
echo("L",L);
Q=206*H/H0;
C=sqrt(H*H+L*L);
echo("C",C);
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
    q=12;//(7.7+16.1)/2;
    x0=90;
    y0=50;
    echo("q",q);
    a=atan2(L,H);
   translate([0,H,0])
   rotate(90+a)
    for(ix=[-5:0])
    for(iy=[-0:3]) {
        x=(ix+iy/2)*Q       + cos(90+a) * x0 - sin(90+a)*y0;
        y=iy*sqrt(3)/4*Q    - sin(90+a) * x0 - cos(90+a)*y0;
        px=-x;
        py=y;
        if( 
            (py>250 && px>200 && px <300) ||
                px>0  && py<250
                && py-px < 0
                && (py<100 || ( px < 1000)) 
                && (py<200 || ( px < 600))  ) {
            echo("hanger",round(px),round(py)-q/2);
            translate([x,y,0]) {
                hanger();
            }
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

