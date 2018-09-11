    W0=1.6;
    HOLE_D_FREE=3.2;
    HOLE_D=2.8;

LANE_W=45;
LANE_SEP=5;
BARRIER_W=2;
BARRIER_H=6;
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
                    S=BARRIER_H-2*W0;
                  cube([S+10,S,11],center=true);
                }
             
             
         }
    }
//    cube([BARRIER_L,BARRIER_W,BARRIER_H]);
}

    BOTTOM_W=4;
eps=5e-3;
    BW=20;
    BH=40;
    BOOTH_POS=[-LANE_W/2 -BW/2-LANE_SEP*3/2,0,-BOTTOM_W-eps];
module booth() {
    W=1.6;
    module roof(){
            B_ROOF=BW*sqrt(2)+2*W;
            B_ROOF_H=B_ROOF/sqrt(2)/2;
        difference() {
            rotate(45,[0,0,1])
            cylinder($fn=4,h=B_ROOF_H,d2=B_ROOF/2,d1=B_ROOF);
            }
    }
        
    color([0,1,0]) {
    translate([0,0,BH/2]) {
        difference() {
            cube([BW,BW,BH],center=true);
            U=BW-2*W;
            U2=BW-4*W;
            cube([U,U,BH*2],center=true);
            
            translate([0,0,U/2]) {
                cube([U2,BH,U],center=true);
                rotate(90,[0,0,1])
                cube([U2,BH,U],center=true);
            }
            for(r=[0,90]) {
                rotate(r,[0,0,1])
                translate([0,0,-BH/2])
                cube([BW+eps,BW/2,BOTTOM_W],center=true);
            }
        }
        
        translate([0,0,BH/2-W*sqrt(2)])
        difference() {
            roof();
            translate([0,0,-2*W*sqrt(2)])
            roof();
        }
    }
}
}

module road() {
    ROAD_W=2;
    WX=-10;
    W=90;
    D1=20;
    D2=-90;
    difference() {
        translate([0,0,-BOTTOM_W/2])
        translate([WX,(D1+D2)/2,0])
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

    BARRIER_POS=[LANE_W/2+LANE_SEP,0,-BOTTOM_W-eps];
    BARRIER_POS2=[-LANE_W/2-LANE_SEP/2,0,-BOTTOM_W-eps];
BARRIER_STAND_H=15;

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
            cylinder(d=HOLE_D+2*W,h=W2,center=true);
            cube([HOLE_D,.001,W2],center=true);
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
    SP=.5;
    W1=BARRIER_W+SP;
    W2=W1+2*W;
    D1=BARRIER_H+SP;
 $fn=16;   
    color([1,0,0]){
    
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
    translate([0,W/2,0])
    cube([W+3,W,W2],center=true);
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
    
    translate([120,0])
    road();
    translate([0,30])
    barrier_post();
    translate([10,30])
    barrier_post2();
    translate([30,60])
    booth();
    translate([20,40])
    barrier();
    
}

mode="preview";
if(mode=="preview")
    preview();

if(mode=="road")
    road();
if(mode=="barrier_post")
    barrier_post();
if(mode=="barrier_post2")
    barrier_post2();
if(mode=="booth")
    booth();
if(mode=="barrier")
    barrier();

//booth();



