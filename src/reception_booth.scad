
LANE_W=40;
LANE_SEP=5;
BARRIER_W=3;
BARRIER_H=5;
BARRIER_L=LANE_W;

module barrier() {
    cube([BARRIER_L,BARRIER_W,BARRIER_H]);
}

module booth() {
    BW=10;
    BH=20;
    W=1.0;
    difference() {
        cube([BW,BW,BH],center=true);
        U=BW-2*W;
        cube([U,U,BH*2],center=true);
        
        translate([0,0,U/2]) {
            cube([U,BH,U],center=true);
            rotate(90,[0,0,1])
            cube([U,BH,U],center=true);
        }
    }
    
    translate([0,0,BH/2-W*sqrt(2)])
    difference() {
        B_ROOF=BW*sqrt(2)+2*W;
        B_ROOF_H=B_ROOF/sqrt(2);
        rotate(45,[0,0,1])
            cylinder($fn=4,h=B_ROOF_H,d2=0,d1=B_ROOF);
        translate([0,0,-2*W*sqrt(2)])
        rotate(45,[0,0,1])
            cylinder($fn=4,h=B_ROOF_H,d2=0,d1=B_ROOF);
    }
    
}


//barrier();

booth();