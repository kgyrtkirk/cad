use <hulls.scad>
use <furniture.scad>

$fronts=true;
$machines=true;
$internal=true;
$openDoors=true;
$drawerState="CLOSED";

$part=undef;

$W=18;
module ccornerCab() {
    C_W=1230;
    C_H=1400;
    C_D=400;
    cabinet("CC",C_W,C_H,C_D,foot=50)
        cTop()
        shelf(300,external=true)
        shelf(300,external=true)
//        shelf(300)
//        translate([0,100,0])
        partition2(500,C_H-300-300) {
        shelf(200,external=true)
        shelf(300,external=true);
        shelf(200,external=true)
        doors("DOOR",cnt=2,C_H-600)
            
            ;
        }
            
//        doors("DOOR",cnt=1,C_H-600)
        ;

}

posNeg()
ccornerCab();