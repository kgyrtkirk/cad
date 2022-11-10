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
CHAIR_D=680;//700; // 67~68 




//computer_case=[ 175,325,408 ];
computer_case=[ 195,375,411 ];


W=18;
$W=18;

EYE_H=785+430;
DESIRED_DESK_H=730; // +?
DESK_H=DESIRED_DESK_H;


LIFT_D=120;
LIFT_Y=20;//45;

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
    //
    P_W=20;
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
    // párkány
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
    WR=200+$W;
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

    
    // emelotarto
    {
        L_S=640;
        L_C=640;
        W_C=180;
        W_S=80;
        SUP_W=180;  //inner
        SUP_H=300;
        
        translate([WR+CHAIR_D/2,0,DESK_H]) {
            translate([-W_C/2,0,-L_C])
            eXZ("StrokeC",W_C,L_C);

            for(x=[-1,1])
            translate([x*(-W_C/2-$W/2)-$W/2,0,-L_S])
            eYZ($close="f","StrokeS",W_S,L_S);
        }


        
        
    }
    
    // hatso resz takaro
    translate([WR,LIFT_LOSS,0])
    {
        eXZ($close="ou","backHide",CHAIR_D-3,DESK_H-100);
    }
    
    // billentyuzettarto
    {
        W=CHAIR_D-26;
        D=D_2-LIFT_LOSS-30;
        translate([WR+(CHAIR_D-W)/2,LIFT_LOSS+30,DESK_H-100]) {
            
            eXY($close="FBlr","bill",W,D);
        }
    }

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
    
    DH=(DESK_H-FOOT_H-K)/4;
    translate([SPACE_X-WL-SIDE_SPACE,LIFT_LOSS,FOOT_H]) {
        cabinet( name = "L",
            w=WL,
            h=DESK_H -FOOT_H,
            d=D_2,
            extraDL=LIFT_LOSS) {
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
                shelf(K+$W,external=true)
                space(-$W)
                drawer(DH)
                drawer(DH)
                drawer(DH)
                drawer(DH)
                skyFoot($d=D_1,FOOT_H,sideL=true,sideR=true)
                ;
        }
    }


    LEN_R1=500;
    LEN_R2=1002;
    LEN_R=LEN_R1+LEN_R2;
    translate([0,LEN_R+LIFT_LOSS,FOOT_H])
    rotate(-90) {
        cabinet( name = "R2",
            $close="F",
            w=LEN_R2,
            h=HR-FOOT_H,
            d=WR)
                cTop()
                partition3((LEN_R2+$W+$W)/3,(LEN_R2+$W+$W)/3,$h) {
                    shelf(300,external=true);
                    shelf(100,external=true);
                    shelf(300,external=true);
                    skyFoot($w=LEN_R,FOOT_H,sideR=true);
                }
        translate([LEN_R2,0,0])
        cabinet( name = "R1",
            $close="F",
            w=LEN_R1,
            h=DESK_H-FOOT_H,
            d=WR)
                cTop()
                shelf(100,external=true)
                space(DESK_H-200-FOOT_H)
;//                skyFoot(FOOT_H);
        
    }
            
}



    module sideShelf() {
        wallOff=$W;
        translate([0,wallOff,0])
        eXY($close="LF","SideShelf",SIDE_SPACE,D_1-wallOff);
    }
    translate([SPACE_X-SIDE_SPACE,0,0]) {
        T=DESK_H-D_K-$W;
        for(z=[0:.25:1])
        translate([0,0,T-z*(T-FOOT_H)])
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

        translate([60,60,DESK_H])
        liftBox();
    }


    if($machines) {
        translate([0,50+120,FOOT_H+$W])
        color([1,0,1])
        rotate(0)
        cube(computer_case);
    }


}

room();

posNeg() {
//   partsDesk();

    desk2();
    
}
