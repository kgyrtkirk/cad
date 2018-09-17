use <syms.scad>

ROAD_H=2;
FLOOR_H=4;
LANE_W=45;


PLATFORM_L=120;
PLATFORM_EDGE_W=10;
PLATFORM_W=LANE_W+2*PLATFORM_EDGE_W;
PLATFORM_RAMP_LEN=10;


module road() {
    
    FLOOR_SHAPE=[
        [0,0],
        [PLATFORM_RAMP_LEN,ROAD_H],
        [PLATFORM_L-PLATFORM_RAMP_LEN,ROAD_H],
        [PLATFORM_L,0],
    
    ];
    
    
    color([0.5,0.5,.5])
    translate([-PLATFORM_W/2,-PLATFORM_L/2,-ROAD_H])
    rotate(90,[0,0,1])
    rotate(90,[1,0,0])
    linear_extrude(height=PLATFORM_W)
    polygon(points=FLOOR_SHAPE);
    
    
    
    symX([PLATFORM_W/2,0,FLOOR_H/2-ROAD_H])
    cube([PLATFORM_EDGE_W,PLATFORM_L,FLOOR_H],center=true);
}



module preview() {
//    translate(BOOTH_POS)
    road();
}


mode="preview";
if(mode=="preview")
    preview();

if(mode=="road")
    road();
