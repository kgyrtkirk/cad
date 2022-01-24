use <hulls.scad>
use <gyerekszoba.scad>

// scale 1:30

HEIGHT=2625;

WALL_BACK=2541;
WALL_LEFT=2761;
WALL_RIGHT=1070;
WALL_WIDTH=100;



    DOOR=845;
    FRENCH_W=965;
//    DOOR=900;
    WALL_LEFT2=450;
    
    WW=WALL_WIDTH;
    ROOM_Y=WALL_LEFT+DOOR+WALL_LEFT2;
    
    WALL_RIGHT2=ROOM_Y-WALL_RIGHT-FRENCH_W;

ROOM_X=WALL_BACK;


// B=BARRIER
B_WIDTH=20;
B_HEIGHT=300;

MAT1=[800,1600,100];
MAT2=[800,1800,100];

module walls() {

    color([1,0,0])
    translate([WALL_BACK-95,-90,0])
        cylinder(d=22,h=HEIGHT);

    
    color([0,0,1,.3])
    linear_extrude(HEIGHT)
    union() {
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
        polygon(
        [
            [0,-WALL_LEFT-DOOR],
            [0,-ROOM_Y],
            [WALL_BACK,-ROOM_Y],
            [WALL_BACK,-ROOM_Y+WALL_RIGHT2],
            [WALL_BACK+WW,-ROOM_Y+WALL_RIGHT2],
            [WALL_BACK+WW,-ROOM_Y-WW],
            
            [-WW,-ROOM_Y-WW],
            [-WW,-WALL_LEFT-DOOR],
            ]
        );
    }
    
}


module szekrenyA() {
    cube([460,400,1550]);
}
module szekrenyB() {
    cube([750,350,1000]);
}

module emeletes() {
    cube([2300,850,1550]);
}

module gyerekAgy() {
    cube([1840,850,550]);
}

module szonyeg() {
    echo("X>>",ROOM_Y-1700-400);
    color([1,0,.5])
//    rotate(-90)
    cube([1500,2000,10]);
}


module all(walls=true) {
    translate([ROOM_X,-ROOM_Y])
    rotate(90)
    gyerekAgy();

    mirror([0,1,0])
    emeletes();

    translate([0,-WALL_LEFT+750+450])
    rotate(-90)
    szekrenyA();
    translate([0,-WALL_LEFT+750])
    rotate(-90)
    szekrenyB();
    
if(false)
    translate([0,-WALL_LEFT])
    szonyeg();
    
    translate([0,-ROOM_Y])
    hodaly();

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

echo("R",ROOM_X-810-1230);


