use <syms.scad>

ROAD_H=2;
FLOOR_H=4;
LANE_W=45;

PLATFORM_W=20;
PLATFORM_H=5;
PLATFORM_Y=70;


ROAD_L=120;
ROAD_EDGE_W=10;
ROAD_W=LANE_W+2*ROAD_EDGE_W+PLATFORM_W;
ROAD_RAMP_LEN=10;


module road() {
    
    FLOOR_SHAPE=[
        [0,0],
        [ROAD_RAMP_LEN,ROAD_H],
        [ROAD_L-ROAD_RAMP_LEN,ROAD_H],
        [ROAD_L,0],
    
    ];
    
    // bottom "road" shape
    color([0.5,0.5,.5])
    translate([-ROAD_W/2,-ROAD_L/2,-ROAD_H])
    rotate(90,[0,0,1])
    rotate(90,[1,0,0])
    linear_extrude(height=ROAD_W)
    polygon(points=FLOOR_SHAPE);
    
    // sides of the road
    symX([ROAD_W/2,0,FLOOR_H/2-ROAD_H])
    cube([ROAD_EDGE_W,ROAD_L,FLOOR_H],center=true);
    
    // platform
    hull()
    symY([0,PLATFORM_Y/2,PLATFORM_H/2-ROAD_H]) {
        cylinder(d=PLATFORM_W,h=PLATFORM_H,center=true);
    }
    
    // cutouts
    
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
