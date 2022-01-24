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
    cabinet("CC",C_W,C_H,C_D,foot=80)
        cTop()
        
    
        partition2(C_W-500,600) {
        shelf(400);
        shelf(200);
        shelf(0,external=true)
//        translate([0,100,0])
        partition2(500,C_H-300-300) {
            shelf(200,external=false)
                shelf(500,external=false)
                //doors("DOOR",cnt=1,C_H-600-200+$W)
            ;
            shelf(300,external=false)
            shelf(600,external=false)
                doors("DOOR",cnt=2,C_H-600+$W);
        }
    }
            
//        doors("DOOR",cnt=1,C_H-600)
        ;

}

    
module cXY() {
    
    eXY();
}


module shelfPiece(name,a,b,cutL=0,cutR=0) {
    ppp(name) {
        difference() {
            cube([a,b,$W]);
            translate([a,b,0])
                rotate(45)
                cube([cutL*sqrt(2),a,a],center=true);
            translate([0,b,0])
                rotate(-45)
                cube([cutR*sqrt(2),a,a],center=true);
        }
    }
}

module shelves() {
    
    module level(l,r,d) {
        
        color([1,0,0])
        shelfPiece("A1",l,d,d/2,d);
        
        translate([0,r,0.1])
        rotate(-90)
        shelfPiece("A2",r,d,d,d/2);
    }
    
    ID=300;
    IDW=ID+$W;
    level(1000,700,200);
    translate([0,0,IDW])
    level(1500,1000,200);
    translate([0,0,2*IDW])
    level(2000,1300,200);
    
}


module hodaly(){
    posNeg()
    ccornerCab();
}


mode="cab";

if(mode=="cab") {
    posNeg()
    ccornerCab();
    
    if(false)
    translate([0,550,0])
    %cube([780,20,2000]);
}

if(mode=="shelves") {
    posNeg()
    shelves();
    
}
