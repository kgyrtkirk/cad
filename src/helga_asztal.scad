use <hulls.scad>
use <furniture.scad>
use <kitchen_box.scad>


$drawerBoxes=true;

$fronts=true;

$machines=true;
$internal=true;
$openDoors=false;
$drawerState="OPEN";
$handle="125";

$closeWMain=[.4,2];
$closeWFront=[1,1];
$defaultDrawer="smart";

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


VEVOR_MOUNT_X=100;
VEVOR_MOUNT_Y=56;

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
    cutCornerShelf($W=28,$close="FL","top",SPACE_X,D_1+TOP_OVER,cL=1.5*(D_1-D_2),rot=true,type="round");
    // monitorkivagas
    {
        Q=750;  //  szelesseg
        P=70;   //  melyseg
        R=110;  //  kozep hatul szelesseg
        E=4;    // tulmeretezes a lekerikitett kivagas miatt


        translate([WR+CHAIR_D/2,0,DESK_H]) {
            translate([0,LIFT_Y+VEVOR_MOUNT_Y+monitor_dims[1]/2,0])
            translate(-[Q/2,P/2,-$W])
            eXY($close="flrb","m-cover",Q,P,rot=true);
            translate([0,0,$W])
            if(!$positive) {
                translate([0,LIFT_Y+VEVOR_MOUNT_Y+monitor_dims[1]/2,0])
                cube([Q+E,P+E,2*$W],true);
                translate([0,LIFT_Y+VEVOR_MOUNT_Y,0])
                cube([R,VEVOR_MOUNT_Y*2,2*$W],true);
            }
        }
    }

    
    // emelotarto
    {
        L_S=640;
        L_C=640;
        W_C=180;
        W_S=70;
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
            
            eXY($front=true,$close="Flr","bill",W,D,rot=true);
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
    
    DH=(DESK_H-FOOT_H-K)/4-.5;
    translate([SPACE_X-WL-SIDE_SPACE,LIFT_LOSS,FOOT_H]) {
        translate([0,0,DESK_H-FOOT_H-K])
        cabinet( name="LT",
            $close="F",
            w=WL,
            sideClose="F",
            h=K,
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
                    // echo("K=",K);
            // translate([400,300,-K])
                    // eXY("a",200,400);
                }
                cBeams();
            }

        cabinet( name = "L",
            $close="F",
            w=WL,
            sideClose="F",
            h=DESK_H -FOOT_H-K,
            d=D_2,
            extraDL=LIFT_LOSS) {
                shelf($front=true,$W,external=true)
                space($front=false,-$W)
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
        {   //  uloke
            $close="FR";
            EX=70;
            EY=10;
            translate([-EX-EY,0,HR-FOOT_H])
            
            cutCornerShelf($front=true,"R2Top",LEN_R2+EX+EY,WR+EY,EX+0*EX/(1+sqrt(2))+EY,rot=true,type="round");

            N=4;
            for(i=[0:N-1]) {
                translate([-EX,0,(HR-FOOT_H)*i/(N)])

                cutCornerShelf($front=true,"ShelfR",EX,WR,cR=EX+0*EX/(1+sqrt(2)),type="round");
            }

            {

                M_W=D_1-D_2-20;
                translate([LEN_R2-M_W,0,HR+100-FOOT_H])
                cutCornerShelf($front=true,"ShelfM",M_W,WR,M_W+0*M_W/(1+sqrt(2)),rot=true,type="round");
            }

        }
        cabinet( name = "R2",
            $close="F",
            sideClose="F",
            w=LEN_R2,
            h=HR-FOOT_H,
            d=WR)
                cTop()
                partition3((LEN_R2+$W+$W)/3,(LEN_R2+$W+$W)/3,$h) {
                    shelf($front=true,300,external=true);
                    shelf($front=true,100,external=true);
                    shelf($front=true,300,external=true);
                    skyFoot($w=LEN_R,FOOT_H,sideR=true);
                }
        translate([LEN_R2,0,0])
        cabinet( name = "R1",
            $close="F",
            sideClose="F",
            w=LEN_R1,
            h=DESK_H-FOOT_H,
            d=WR)
                cTop()
                shelf(100,external=true)
                space(DESK_H-200-FOOT_H)
;//                skyFoot(FOOT_H);
        
    }
            
}

    translate([SPACE_X-SIDE_SPACE,0,0]) {
        T=DESK_H-D_K-$W;
        wallOff=0*$W;
        for(z=[0:.25:1])
        translate([0,wallOff,T-z*(T-FOOT_H)])
        cutCornerShelf($front=true,$close="FL","ShelfL",SIDE_SPACE,D_1-wallOff,cL=SIDE_SPACE+0*40,type="round");
    }


    echo("remainRight",SPACE_X-CHAIR_D-WL-SIDE_SPACE);
    if($machines)
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
        y=LIFT_Y+VEVOR_MOUNT_Y+monitor_dims[1]/2;
        z=EYE_H-monitor_dims[2]/2-(up?0:VEVOR_STROKE);
        translate([x,y,z])
        cube(monitor_dims,center=true);

        
        translate([x,LIFT_Y+VEVOR_MOUNT_Y/2,DESK_H])
        cube([VEVOR_MOUNT_X,VEVOR_MOUNT_Y,1000],center=true);

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

module model() {
    posNeg() {
        desk2();
    }
}

mode="normal";
//mode="P-topXY";
//mode="P-R2TopXY";
// mode="P-ShelfRXY";
// mode="P-ShelfMXY";
// mode="P-ShelfLXY";

if(mode=="normal") {
    room();
    model();
}
if(mode=="print") {
    scale(1/25) {
        room();
        model();
    }
}

if(mode[0] == "P" && mode[1]=="-") {
    $fronts=false;
    $machines=false;
    
    $part=substr(mode,2);
    
    projection(false)
    orient(mode)
//    rotate(90,[0,1,0]) 
        model();
//        previewLU();
}


echo(D_1);
echo(D_2);