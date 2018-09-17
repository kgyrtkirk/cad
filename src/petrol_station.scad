use <syms.scad>

W=1.6;

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

PUMP_HANDLE_D=2.6;
PUMP_HANDLE_INT=10;
PUMP_CABLE_D=1.2;
PUMP_CABLE_ATTACH_H=PLATFORM_H+PUMP_CABLE_D/2+W;

eps=.01;
POS_PUMP_1=[0,25,-ROAD_H-eps];
POS_PUMP_2=[0,-25,-ROAD_H-eps];

PUMP_BODY=[6,10,15];
PUMP_HEAD=[10,15,8];


module toZ0(P) {
    translate([0,0,P[2]/2])
    children();
}

function shrinkXY(p,val) = [p[0]-2*val,p[1]-2*val,p[2]];

module petrolPump() {
    
    difference() {
        union() {
            toZ0(PUMP_BODY)
            cube(PUMP_BODY,center=true);
            toZ0(PUMP_BODY+PUMP_BODY+PUMP_HEAD)
            cube(PUMP_HEAD,center=true);
        }
        toZ0(PUMP_BODY+PUMP_HEAD-[0,0,2*W])
        cube(shrinkXY(PUMP_BODY,W)+[0,0,PUMP_HEAD[2]],center=true);
        
        cube([20,3,ROAD_H*2],center=true);
        cube([3,20,ROAD_H*2],center=true);
        
        
        translate([0,0,PUMP_CABLE_ATTACH_H])
        rotate(90,[1,0,0])
        cylinder($fn=16,d=PUMP_CABLE_D,h=100,center=true);
        
        
        symY([0,PUMP_HEAD[1]/2,PUMP_BODY[2]+PUMP_HEAD[2]/2])
        rotate(-60,[1,0,0])
        cube([PUMP_HANDLE_D,PUMP_HANDLE_D,PUMP_HANDLE_INT*2],center=true);
    }
    
    
}

module road() {
    
    FLOOR_SHAPE=[
        [0,0],
        [ROAD_RAMP_LEN,ROAD_H],
        [ROAD_L-ROAD_RAMP_LEN,ROAD_H],
        [ROAD_L,0],
    
    ];
    
    difference() {
        union() {
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
        }
    
        // cutouts
        translate(POS_PUMP_1)
        petrolPump();
        translate(POS_PUMP_2)
        petrolPump();
    }
}



module preview() {
    road();
    translate(POS_PUMP_1)
    petrolPump();
    translate(POS_PUMP_2)
    petrolPump();
    
    translate([100,0,0])
    petrolPump();
}


mode="preview";
if(mode=="preview")
    preview();

if(mode=="road")
    road();
