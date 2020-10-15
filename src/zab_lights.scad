$fn=32;

SPOT_REAL_D=90;
SPOT_HOLE_D=70;
SPOT_DIST=150;
D=SPOT_DIST*6;


function xi(b) = b?1:0;




module atLampPos() {
    children();
    for(i=[0:6]) {
        rotate(i*60) {
        translate([SPOT_DIST,0,0])
        children();
        translate([SPOT_DIST*2,0,0])
        children();
        }
    }
    for(i=[0:6]) {
        rotate(i*60+30)
        translate([sqrt(3)*SPOT_DIST,0,0])
        children();
    }
}


module mainLamp() {
    atLampPos() {
    %    cylinder(d=SPOT_REAL_D,h=50,center=true);
    }
    difference() {
        color([0,1,0]) {
        cylinder($fn=6,d=D,h=16);
        }
        atLampPos() {
            cylinder(d=SPOT_HOLE_D,h=50,center=true);
        }
    }
}


module hullPairs(pos){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
    hull() {
        translate(pos[0]) children();
        translate(pos[len(pos)-1]) children();
    }
    
}

module kitchenLamp() {
    
}

module room() {
    H=2;
    A=[5250,3240,H];
    translate([0,0,A[2]/2])
    cube(A,center=true);
    B=[5250,1920,H];
    color([0,0,1])
    translate([0,(A[1]+B[1])/2,B[2]/2])
    cube(B,center=true);

    C=[2640,60,3*H];
    translate([-(A[0]-C[0])/2,(A[1])/2,0])
    color([1,0,0])
    cube(C,center=true);

    D=[600,600,3*H];
    translate([-(A[0]-D[0])/2,(A[1]+D[1])/2,0])
    color([1,0,0])
    cube(D,center=true);

}

room();
//translate([-1000,0,0])
rotate(90)
mainLamp();

translate([-1000,2500,0])
kitchenLamp();

