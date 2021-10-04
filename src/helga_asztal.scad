use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>



$fronts=true;

$machines=true;
$internal=true;
$openDoors=true;
$drawerState="CLOSED";

$part=undef;


// LG 32QN600-B Monitor 
monitor_dims=[ 714.3 , 420.0 , 45.7 ];


W=18;
$W=18;

EYE_H=785+430;
DESIRED_DESK_H=730; // +?
DESK_H=DESIRED_DESK_H;

echo("desk_monitor_gap",EYE_H-DESIRED_DESK_H-monitor_dims[1]);

SPACE_X=1300; // approx

module room() {
    
}

module partsDesk(){

    cabinet2( name = "D",
        h=DESK_H ,
        dims=[ [0,100] , [ 100,100] , [1000,200]]) {
            
        doors("D1",100);
        doors("d2",200);
            
    }
}

room();

posNeg() {
    partsDesk();
}

