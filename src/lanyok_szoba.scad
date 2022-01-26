use <hulls.scad>
use <gyerekszoba.scad>
use <furniture.scad>

mode="real";

$showParts=(mode!="print");


printScale=1/30;

printMM=1/printScale;


// scale 1:30
WW=2*printMM;
FLOOR_W=printMM;

module room() {
    if($positive) {
        difference() {
            translate([-WW,-WW,-FLOOR_W])
            cube([$roomX+2*WW,$roomY+2*WW,$roomHeight+FLOOR_W]);
            cube([$roomX,$roomY,2*$roomHeight]);
        }
    }    
}

module door(w,h,iw,ih,frame) {
    
    if($positive) {
        translate([-WW-frame,0,0])
        cube([frame+WW+frame,w,h]);
    } else {
        for(cutX=[frame/*,-WW-frame-WW*/]) {
            translate([cutX,0,0])
                cube([WW,w,h]);
        }
        translate([-2*WW,(w-iw)/2,(h-ih)/2])
        cube([3*WW,iw,ih]);
    }
}

module radiator(width,height,depth,thx,thy,thh) {
    if($positive) {
        if($showParts) {
            
            cube([depth,width,height]);
            
            translate([-depth*2/3,width/4,0])
            cube([depth,width/2,height/2]);
            
            // thermo crap
            hull() {
                $fn=8;
                translate([depth/2,thx,thy]) {
                    sphere(d=40);
                }
                translate([depth/2,0,thy]) {
                    sphere(d=40);
                }
            }
            translate([depth/2,thx,thy])
            rotate(90,[0,1,0])
            cylinder(d=40,h=depth/2+thh);
        }
    } else {
        translate([-depth*2/3,width/4,0])
        cube([depth,width/2,height/2]);
    }
}

module pipe(d,length) {
    if($positive)
        cylinder(d=d,h=length);
    
}

// remember:
//  x-is dist from backwall
//  y-is dist from corner
module  atCorner(idx) {
    y=(idx==1 || idx==2);
    x=(idx==2 || idx==3);
    translate([x?$roomX:0,y?$roomY:0,0])
    rotate(-90*idx)
    children();
}

module  atCornerL(idx) {
    atCorner(idx)
    rotate(90)
    children();
}


module ePiece(A,B,D) {
    if($positive) {
        if($showParts) {
            translate([D/2-printMM/2,0,0])
            cube([D+printMM,A,B],center=true);
        }
    } else {
        translate([-printMM/4+.1,0,0])
        cube([printMM/2,A,B],center=true);
    }
}

module wallSwitch() {
    ePiece(85,85,10);
}

module wallOutlet2() {
    ePiece(100,60,50);
}


module kidsRoom() {
    $roomHeight=2625;
    $roomX=2541;
    $roomY=4135;

    room();
    
    atCorner(0) {
        translate([0,435+90,0])
        door(845,2093,700,2000,10);

        translate([0,435+90+845+160,1290])
        wallSwitch();
        
        translate([0,435+90+845+280,150])
        wallOutlet2();
    }
    
    atCorner(1) {
        translate([0,345,150])
        wallOutlet2();
    }
    
    atCornerL(3) {
        translate([0,-300,150])
        wallOutlet2();
    }

    atCorner(2) {
        translate([0,1043+33,250])
        door(980,$roomHeight-450,800,2000,-30);
        
        translate([30,1043-605,200])
        radiator(605,600,100,-35,570,60);
        
        {
            // reality 22; for preview use bigger
            pipeExtra=10; 
            pX=95-pipeExtra;
            pY=90-pipeExtra;
            translate([0,0,$roomHeight-30])
            if($positive)
            cube([pX,pY,30]);
            translate([pX,pY,0]) {
                pipe(22+2*pipeExtra,$roomHeight);
            }
        }
        
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

s=(mode=="print")?1/30:1;

scale(s)
posNeg()
kidsRoom();
