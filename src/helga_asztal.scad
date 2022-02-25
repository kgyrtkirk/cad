use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>


$drawerBoxes=true;

$fronts=true;

$machines=true;
$internal=true;
$openDoors=false;
$drawerState="CLOSED";
$handle="125";

$closeWMain=[.4,2];
$closeWFront=[1,1];
$defaultDrawer="std";

$part=undef;

// LG 32QN600-B Monitor 
monitor_dims=[ 714.3 , 45.7,420.0 ,  ];
// vevor stroke: 500
VEVOR_STROKE=500;
//VEVOR_H=500;
CHAIR_D=700; // 67~68 




//computer_case=[ 175,325,408 ];
computer_case=[ 190,375,411 ];


W=18;
$W=18;

EYE_H=785+430;
DESIRED_DESK_H=730; // +?
DESK_H=DESIRED_DESK_H;


LIFT_D=120;
LIFT_Y=45;

LIFT_LOSS=LIFT_D+LIFT_Y;


DD=150;
D_1=750;            //  right depth
D_2=D_1-LIFT_LOSS;         //  left depth
X=[300,0,800,0,300];
PX=prefix(0,X);


D_K=D_1-D_2;

echo("desk_monitor_gap",EYE_H-DESIRED_DESK_H-monitor_dims[1]);

SPACE_X=1320; // approx
module room() {
    L=1350-15; // 1337 - this is very good
    WW=100;
    H=835;
    P_W=45;

    P_H=880-835;

    EDGE_D=30;
    EDGE_H=80;
    color([0,1,1]) {
        mirror([0,1,0])
        cube([L,WW,H]);
        mirror([1,0,0])
        cube([WW,2*720,1225]);
        translate([-25,720+150,1225])
        hull() {
        cylinder(r=150,h=30);
            translate([0,1000,0])
        cylinder(r=150,h=30);
        }
    }
    color([1,0,1]) {

        translate([0,0,H])
        cube([L,P_W,P_H]);
    }
    
    // wall connector
    color([1,0,0])
    translate([30,0,80])
    cube([50,50,200]);

    // radiator
    color([1,0,0])
    translate([L,0,770-650])
    cube([1000,WW,650]);

    //szegely
    color([0,1,0])
    cube([L+100,EDGE_D,EDGE_H]);

    //szegely
    color([0,1,0])
    cube([EDGE_D,2*L+100,EDGE_H]);
    

}

module desk2(){

    WL=350;
    WR=200;
    HR=500;
    SIDE_W=DD-W-W;
    SIDE_SPACE=70;
    TOP_OVER=W;
    $close="";
    $front=false;
    FOOT_H=80;

    translate([0,0,DESK_H])
    eXYp("top",[[0,0],[SPACE_X,0],
                [SPACE_X,D_2+TOP_OVER],
                [SPACE_X-(D_1-D_2),D_1+TOP_OVER],
                [0,D_1+TOP_OVER]
                
                ]);


    echo("balTaroloMely",D_2-LIFT_LOSS);
if(false) {
    translate([SPACE_X-WL,LIFT_D,0])
    cabinet2( name = "L",
        h=DESK_H ,
        dims=[ [0,D_1-LIFT_D], [WL-$W,D_2-LIFT_D]]) {
            cTop()
        doors("D1",100);
        doors("d2",200);
            
    }
}else{

    K=D_1-D_2;
    
    translate([SPACE_X-WL-SIDE_SPACE,LIFT_LOSS,0]) {
        cabinet( name = "L",
            w=WL,
            h=DESK_H ,
            d=D_2) {
                {
                    if(!$positive) {
                        intersection() {
                            translate([-W+$w/2,$d,-K])
                            rotate(45,[1,0,0])
                            cube([$w+2*W,2*K,2*K]);
                            translate([-$w/2,$d-2*K,-2*K])
                            cube([2*$w,3*K,2*K]);
                        }
                    }
                }
                cBeams()
                shelf(K+$W)
                space(K)
                drawer(150)
                drawer(150)
                drawer(150);
        }
    }


    translate([0,1500+LIFT_LOSS,FOOT_H])
    rotate(-90)
    cabinet( name = "R",
        w=1500,
        h=HR-FOOT_H,
        d=WR)
            cTop()
            shelf(300,external=true)
            space(HR-300-FOOT_H)
            skyFoot(FOOT_H);
            
}



    module sideShelf() {
        eXY($close="LF","SideShelf",SIDE_SPACE,D_1-$W);
    }
    translate([SPACE_X-SIDE_SPACE,0,0]) {
        T=DESK_H-D_K-$W;
        for(z=[0,150,300,450])
        translate([0,0,T-z])
        sideShelf();
    }


    echo("remainRight",SPACE_X-CHAIR_D-WL-SIDE_SPACE);
    translate([SPACE_X-CHAIR_D/2-WL-SIDE_SPACE,600,-10])
    cylinder(d=CHAIR_D,h=300);

    module liftBox() {
        h=285;
        translate([0,0,$openDoors?0:-h+$W])
        cylinder(d=60,h=h);

    }

    if($machines)
    color([0,0,1]) {
        up=true;
        x=WR+CHAIR_D/2;
        y=LIFT_LOSS-monitor_dims[1]/2;
        z=EYE_H-monitor_dims[2]/2-(up?0:VEVOR_STROKE);
        translate([x,y,z])
        cube(monitor_dims,center=true);

        translate([x,LIFT_Y+50/2,DESK_H])
        cube([50,50,1000],center=true);

        translate([x-100,LIFT_Y,0])
        cube([100,70,70]);

        translate([50,50,DESK_H])
        liftBox();
    }


    if($machines) {
        translate([0,50+120,FOOT_H+$W])
        rotate(0)
        cube(computer_case);
    }


}

room();

posNeg() {
//   partsDesk();

    desk2();
    
}

