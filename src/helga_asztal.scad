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
monitor_dims=[ 714.3 , 45.7,420.0 ,  ];

//computer_case=[ 175,325,408 ];
computer_case=[ 190,375,411 ];


W=18;
$W=18;


EYE_H=785+430;
DESIRED_DESK_H=730; // +?
DESK_H=DESIRED_DESK_H;

D_1=750;
D_2=D_1-300 ;
X=[300,0,800,0,300];
PX=prefix(0,X);


echo("desk_monitor_gap",EYE_H-DESIRED_DESK_H-monitor_dims[1]);

SPACE_X=1300; // approx
module room() {
    L=1350-15;
    WW=100;
    H=835;
    P_W=45;
    P_H=880-835;
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
    
    // radiator
    color([1,0,0])
    translate([L,0,770-650])
    cube([1000,WW,650]);

}




module partsDesk(){

    cabinet2( name = "D",
        h=DESK_H ,
        dims=[ [0,D_1],[X[0],D_1] , [ X[1],D_1] ,[X[2],D_1],[X[3],D_1], [X[4],D_2]]) {
            
        doors("D1",100);
        doors("d2",200);
        doors("d2",200);
        doors("d2",200);
        doors("d2",200);
            
    }
    
    translate([PX[0]+W,0,DESK_H])
    cylinder(d=60,h=200,center=true);
    
    translate([(PX[1]+PX[2])/2+3*W,100+monitor_dims[1]/2,EYE_H-monitor_dims[2]/2])
//    translate([(PX[1]+PX[2])/2+3*W,100+monitor_dims[1]/2,DESK_H+monitor_dims[2]/2+80-18])
//    rotate(90,[1,0,0])
    cube(monitor_dims,center=true);
    
}

module desk2(){
    translate([0,0,DESK_H])
    eXYp("top",[[0,0],[SPACE_X,0],
                [SPACE_X,D_2],
                [SPACE_X-(D_1-D_2),D_1],
                [0,D_1]
                
                ]);


    translate([SPACE_X-300,0,0])
    cabinet2( name = "L",
        h=DESK_H ,
        dims=[ [0,D_1], [270,D_2]]) {
            
        doors("D1",100);
        doors("d2",200);
        doors("d2",200);
        doors("d2",200);
        doors("d2",200);
            
    }
    cabinet2( name = "R",
        h=DESK_H ,
        dims=[ [0,D_1], [270,D_1]]) {
            
        doors("D1",100);
        doors("d2",200);
        doors("d2",200);
        doors("d2",200);
        doors("d2",200);
    }
    
    translate([700-50,400,-10])
    cylinder(d=700,h=300);
}

room();

posNeg() {
//   partsDesk();

    desk2();
}

