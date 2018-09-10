    HOLE_D_FREE=3.2;
    HOLE_D=2.8;

LANE_W=40;
LANE_SEP=5;
BARRIER_W=2;
BARRIER_H=5;
BARRIER_L=LANE_W+LANE_SEP*2;

module hullChain(pos){
    for(i=[0:len(pos)-2]) {
         hull() {
             translate(pos[i])
                children();
             translate(pos[i+1])
                children();
         }
     }
}

module barrier() {

     difference() {
         hullChain([[0,-10,0],[0,0,0],[BARRIER_L-BARRIER_W,0,0]])
                cylinder($fn=16,d=BARRIER_H,h=BARRIER_W,center=true);
        cylinder($fn=32,d=HOLE_D_FREE,h=100,center=true);
         
         
         
         for(x=[BARRIER_W+2*BARRIER_W:2*BARRIER_W:BARRIER_L-2*BARRIER_W]) {
             translate([x,0,0])
             render()
                intersection() {
                    rotate(45,[0,0,1])
                    cube([10,1,11],center=true);
                    S=BARRIER_H-1.6;
                  cube([S+10,S,11],center=true);
                }
             
             
         }
    }
//    cube([BARRIER_L,BARRIER_W,BARRIER_H]);
}

    BW=10;
    BH=20;
    BOOTH_POS=[-LANE_W/2 -BW/2-LANE_SEP*3/2,0,-1];
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
    W=80;
    D1=10;
    D2=-45;
    difference() {
        translate([0,0,-BOTTOM_W/2])
        translate([0,(D1+D2)/2,0])
        cube([W,D1-D2,BOTTOM_W],center=true);
        // cut out road
        cube([LANE_W,2*100,2*(BOTTOM_W-ROAD_W)],center=true);
        // cut out ramps for cars
        for(y=[D1,D2])
        translate([0,y,0])
        rotate(45,[1,0,0])
        cube([LANE_W,BOTTOM_W*sqrt(2),BOTTOM_W*sqrt(2)],center=true);
        // cut out booth foundation
        translate(BOOTH_POS)
            booth();
        
        translate(BARRIER_POS)
            rotate(90,[1,0,0])
            barrier_post();
        translate(BARRIER_POS2)
            rotate(90,[1,0,0])
            barrier_post2();

    }
}


//barrier();

    BARRIER_POS=[LANE_W/2+LANE_SEP,0,-1];
    BARRIER_POS2=[-LANE_W/2-LANE_SEP/2,0,-1];
BARRIER_STAND_H=10;

module barrier_post() {
    W=1.6;
    SP=.3;
    W1=BARRIER_W+SP;
    W2=W1+2*W;
    D1=BARRIER_H+SP;
 $fn=16;   
    
    difference() {
        hull() {
            translate([0,BARRIER_STAND_H,0])
            cylinder(d=HOLE_D+W,h=W2,center=true);
            cube([D1,.001,W2],center=true);
//            cylinder(d=D1,h=W2,center=true);
        }
        translate([0,BARRIER_STAND_H,0])    {
            cube([D1,D1,W1],center=true);
            cylinder($fn=32,d=HOLE_D,h=100,center=true);
        }
//        cylinder(d=D1+.00,h=W1,center=true);
        
    }
}

module barrier_post2() {
    W=1.6;
    SP=.3;
    W1=BARRIER_W+SP;
    W2=W1+2*W;
    D1=BARRIER_H+SP;
 $fn=16;   
    
    difference() {
        hull() {
            translate([0,BARRIER_STAND_H,0])
            cylinder(d=W,h=W2,center=true);
            cube([W,.001,W2],center=true);
        }
        translate([0,BARRIER_STAND_H,0])    {
            cube([D1,D1,W1],center=true);
        }
        
    }
}


module preview() {
    translate(BOOTH_POS)
    booth();
    road();
    translate(BARRIER_POS + [0,0,BARRIER_STAND_H])
    rotate(90,[1,0,0])
    rotate(180,[0,0,1])
    barrier();
    
    translate(BARRIER_POS)
    rotate(90,[1,0,0])
    barrier_post();
    translate(BARRIER_POS2)
    rotate(90,[1,0,0])
    barrier_post2();
}

preview();
