use <hulls.scad>




HEIGHT=2625;

WALL_BACK=2541;
WALL_LEFT=2761;
WALL_RIGHT=1070;
WALL_WIDTH=100;




// B=BARRIER
B_WIDTH=20;
B_HEIGHT=300;

MAT1=[800,1600,100];
MAT2=[800,1800,100];

// S=STRUCTURE
S_HOLE=[700,700];
S_GAP=[800,800];
S_THICK=130;
S_HEIGHT=1800;  //  SAFE_H 177
S_HEIGHT2=S_HEIGHT+S_THICK;
S_BACK_WIDTH=MAT1[0]+B_WIDTH;
S_LEFT_WIDTH=MAT2[0]+B_WIDTH;
S_LEFT_LEN=MAT2[1]+B_WIDTH+S_GAP[1];


CLEARANCE=HEIGHT-S_THICK-S_HEIGHT-MAT1[2];
echo("@clearance",CLEARANCE);

module walls() {

    color([1,0,0])
    translate([WALL_BACK-95,-90,0])
        cylinder(d=22,h=HEIGHT);

    color([0,0,1,.3])
    linear_extrude(HEIGHT)
    polygon(
    [
        [0,0],
        [0,-WALL_LEFT],
        [-WALL_WIDTH,-WALL_LEFT],
        [-WALL_WIDTH,WALL_WIDTH],
        [WALL_BACK+WALL_WIDTH,WALL_WIDTH],
        [WALL_BACK+WALL_WIDTH,-WALL_RIGHT],
        [WALL_BACK,-WALL_RIGHT],
        [WALL_BACK,0],
        ]
    );
    
}


module main() {
    translate([0,0,S_HEIGHT])
    difference() {
        union() {
            translate([0,-S_BACK_WIDTH,0])
            cube([WALL_BACK,S_BACK_WIDTH,S_THICK]);
            translate([0,-S_LEFT_LEN,0])
            cube([S_LEFT_WIDTH,S_LEFT_LEN,S_THICK]);
        }
//        translate([S_HOLE[0],-S_HOLE[1],0]/2)
        cube([S_HOLE[0],S_HOLE[1],S_HEIGHT]*2,center=true);
    }
}

module barrier() {
    Q=B_WIDTH/2;
    points=[
        [WALL_BACK-Q,-(S_BACK_WIDTH-Q)],
        [S_LEFT_WIDTH-Q,-(S_BACK_WIDTH-Q)],
        [S_LEFT_WIDTH-Q,-(S_LEFT_LEN-Q)],
        [Q,-(S_LEFT_LEN-Q)],
    ];
    
    translate([0,0,S_HEIGHT+S_THICK+B_HEIGHT]){
        hullPairs(points,false)
            cube(B_WIDTH,center=true);
        for(p= points) {
            translate(p)
            translate([0,0,-B_HEIGHT/2])
            cube([B_WIDTH,B_WIDTH,B_HEIGHT],center=true);
        }
    }
}

module mat() {
//    translate();
//    cube(MAT1);

    translate([S_GAP[0],0,S_HEIGHT2])
    rotate(-90)
    color([0,1,0,.5])
    cube(MAT1);


    translate([0,-S_LEFT_LEN+B_WIDTH,S_HEIGHT2])
    color([0,1,0,.5])
    cube(MAT2);
}

module steps() {
    STEP_THICK=20;
    STEP_H=S_HEIGHT-600;
    SEAT_H=S_HEIGHT-200;

    echo("@stepH",STEP_H);

    translate([0,0,SEAT_H]) {
        cube([S_HOLE[0]/2,S_HOLE[1]/2,STEP_THICK]);
    }

    translate([0,0,STEP_H]) {
        cube([S_HOLE[0],S_HOLE[1],STEP_THICK]);
    }
}

module all(walls=true) {
main();
barrier();
mirror([0,1,0])
steps();
mat();
    if(walls)
walls();


}

mode="x";
if(mode=="proj") {
projection(cut = true) 
translate([0,0,-S_HEIGHT-10])
all(false);
}else {
    all()
    ;
}