
LANE_W=40;
LANE_SEP=5;
BARRIER_W=3;
BARRIER_H=5;
BARRIER_L=LANE_W;

module barrier() {
    cube([BARRIER_L,BARRIER_W,BARRIER_H]);
}

    BW=10;
    BH=20;
    BOOTH_POS=[-LANE_W/2 -BW,0,-1];
module booth() {
    W=1.0;
    translate([0,0,BH/2]) {
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
}

module road() {
    BOTTOM_W=4;
    ROAD_W=2;
    W=100;
    D=50;
    difference() {
        translate([0,0,-BOTTOM_W/2])
        cube([W,D,BOTTOM_W],center=true);
        // cut out road
        cube([LANE_W,2*D,2*(BOTTOM_W-ROAD_W)],center=true);
        // cut out ramps for cars
        for(y=[-D/2,D/2])
        translate([0,y,0])
        rotate(45,[1,0,0])
        cube([LANE_W,BOTTOM_W*sqrt(2),BOTTOM_W*sqrt(2)],center=true);
        // cut out booth foundation
        translate(BOOTH_POS)
            booth();
    }
}


//barrier();


module preview() {
    translate(BOOTH_POS)
    booth();
    road();
}

preview();
