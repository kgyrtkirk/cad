// notes:
// never again design with z as a physically flat dir

use <syms.scad>


W=1.6;
eps=1e-4;

DIM=[ 40, 40, 110 ];
OVERHANG_ANGLE=60;

HINGE_K=10;             // diff between hinge center and y center
HINGE_D0=1.2;             // hinge axis diameter
HINGE_D1=HINGE_D0+.8;   // hinge hole diameter
HINGE_D2=HINGE_D1+W;
HINGE_W=DIM[1]/10;
SP=.6;
HINGE_SPACE=SP;
HANDLE_W=4*W;

module decorationCuts(xSpace,ySpace){
    CUTW0=W;
    N=floor((ySpace-CUTW0) / (2*CUTW0) );
    //N=3;
    CUTW=ySpace / (2*N+1);
    echo(CUTW);
    
    for(z=[CUTW+CUTW/2:2*CUTW:ySpace])
    translate([0,0,z])
    cube([CUTW,xSpace-2*CUTW,CUTW],center=true);
}

module containerPart() {

    difference() { 
        
        translate([0,0,DIM[2]/2])
        cube(DIM,center=true);
        
        S=min(DIM[0],DIM[1]);
        SL=1/tan(OVERHANG_ANGLE)*S/2;
        echo("S=",S," SL=",SL);
        
        translate([0,0,DIM[2]/2]) {
            // clear support free end
            translate([0,0,DIM[2]/2-W-SL-.1])
            linear_extrude(height=SL,scale=0)
            square(size=[DIM[0]-2*W,DIM[1]-2*W],center=true);
            
//#            cylinder($fn=4,d1=DIM[0]-2*W,d2=0,h=SL,center=true);
            
            // clear cargo space
            translate([0,0,-W-SL])
            cube(DIM-2*[W,W,0],center=true);
        }
        
        // cut out door-x
        cube([111,DIM[1]-2*W,2*(HINGE_D2+SP)],center=true);
        // cut out door top/bottom handle pos
        cube([HANDLE_W+W,111,2*(W+SP)],center=true);
        
        // side cuts
        symX([-DIM[0]/2,0,HINGE_D2+SP])
        decorationCuts(DIM[1],DIM[2]-HINGE_D2-SP);
        
        // top cuts
        translate([0,DIM[1]/2,HINGE_D2+SP])
        rotate(90,[0,0,1])
        decorationCuts(DIM[0],DIM[2]-HINGE_D2-SP);

        translate([-DIM[0]/2,0,DIM[2]])
       rotate(90,[0,1,0])
        decorationCuts(DIM[1],DIM[0]);
        
    }
}

module hingePart(HINGE_D1=HINGE_D1,HINGE_D2=HINGE_D2,HINGE_W=HINGE_W) {
    $fn=16;
    rotate(90,[1,0,0])
    difference() {
        hull() { 
            //main piece
            cylinder(d=HINGE_D2,h=HINGE_W,center=true);
            // support to wall
            translate([HINGE_D2/2-eps,2*HINGE_D2,0])
            cylinder(d=eps,h=HINGE_W,center=true);
        }
        cylinder(d=HINGE_D1,h=2*HINGE_W,center=true);
    }
//    sphere();
}

module roundedBlock(dim=[10,10,2],zPos=0) {
    hull()
    symXY([dim[0],dim[1],zPos]){
        sphere(d=dim[2]);
    }
}

module lidPartBase(DOOR_W) {
    LX=DIM[0]/2-SP/2-HINGE_D2/2;
    LY=DIM[1]-2*W-SP;
    $fn=16;
    hull()
        symY([0,LY/2-HINGE_D2/2,0]) {
        sphere($fn=16,d=HINGE_D2);
        translate([-HINGE_D2/2,0,-HINGE_D2/2+W/2])
        sphere($fn=16,d=HINGE_D0);
    }
    
    OFF_X=HINGE_D2/2;
    translate([-LX/2,0,-HINGE_D2/2+W/2]) {
    hull() {
        symY([0,LY/2-W/2,0])
        symX([LX/2-W/2,0,0])
        sphere(d=W);
    }

    }
    
    
    A=W/4;
    translate([-DOOR_W+SP/2,0,-HINGE_D2/2+W/2])
//    translate([HANDLE_W/2-SP-W/2,0,0]) 
    translate([A+(HANDLE_W-2*W)/4+W/2,0,0]) 
    {
        hull()
        symXY([A+(HANDLE_W-2*W)/4,DIM[1]/2-W/2,0])
        sphere(d=W);
    }
        
    /*
    translate([-LX/2+W,0,W/2])
    hull() {
        symY([0,LY/2-W/2,0])
        symX([LX/2-W/2,0,0])
        sphere($fn=16,d=W);
    }*/
}

module lidPart(DOOR_W) {
    difference() {
        rotate(180,[0,1,0])
        lidPartBase(DOOR_W);
        symY([0,HINGE_K,0])
        hingePart(HINGE_D0,HINGE_D2+2*SP,HINGE_W+2*SP);
        
        translate([HINGE_D2/2,0,HINGE_D2/2])
       rotate(90,[0,1,0])
       decorationCuts(DIM[1]-2*(W+SP),DOOR_W-HINGE_D2/2);

    }
}

module trailerMountPattern() {
    // this random chineese trailer has some wierd mount pattern...
    CUT_L=2*W+.1;
    D_HOLE=3;
    W=1.2;
    
    L=106.5 - W;
//    L=105.1 + W;
    K=34.6 - W;
    
    module cX(D,L) {
        TOLERANCE=-.5;
        OFF=D>0?D+L:0;
        symY([0,OFF/2,0]){
            cube([K+10*W,L+TOLERANCE,20],center=true);
        }
    }
    
    translate([0,DIM[2]+.005*W,0]/2) {
        OO=( (50.9+W/2-39) - (14.6-W/2+D_HOLE/2))/2;
        difference()  {
            cube([K+W,L+W,CUT_L],center=true);
            //main cut
            cube([K-W,L-W,20],center=true);

            translate([0,-OO,0]) {
                
                cX(0,7.3);
                cX(23.6,3.4);
                cX(54.2,7.5);
                cX(85.6,3);
            }
            
        }
        echo("OO",OO);
        translate([0,-OO,-1.1]) {
            MAGNET_D=1.9;
            $fn=16;
            cylinder(h=CUT_L,d=MAGNET_D,center=false);
            symY([0,39,0])
            cylinder(h=CUT_L,d=MAGNET_D,center=false);
        }
        // hook crap
        symX([(K/2-(5.1-W)),-L/2+2,0])
        cube([W,4,CUT_L],center=true);
    }
    
}


module container(open=false) {
    difference() {
        containerPart();
        translate([0,-DIM[1]/2,0])
        rotate(90,[1,0,0])
        trailerMountPattern();
    }
    
    DOOR_W=DIM[0]/2-HINGE_D2/2;
    symX
    ([DOOR_W,0,HINGE_D2/2]) {
        symY([0,HINGE_K,0])
        hingePart();
        rotate(open?0:-180,[0,1,0])
        lidPart(DOOR_W);
    }
    
}

mode="preview";
//mode="print";
//mode="door";
//mode="floor";
if(mode=="preview"){
    difference() {
        container();
        X=300;
        translate([0,0,-X/2])
        cube(X);
    }
}



if(mode=="print"){
    container(true);
}

if(mode=="door"){
    intersection() {
        container(true);
        cube([100,100,20],center=true);
        
    }
}

if(mode=="floor"){
    projection(cut=true)
    rotate(90,[1,0,0])
    translate([0,DIM[1]/2-eps,0])
    container(true);
}