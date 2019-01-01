
use <syms.scad>


W=1.6;
eps=1e-4;

DIM=[ 40, 40, 110 ];

HINGE_K=10;             // diff between hinge center and y center
HINGE_D0=W;             // hinge axis diameter
HINGE_D1=HINGE_D0+.6;   // hinge hole diameter
HINGE_D2=HINGE_D1+W;
HINGE_W=4;
SP=.4;
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
        
        translate([0,0,DIM[2]/2])
        translate([0,0,-W])
        cube(DIM-2*[W,W,0],center=true);
        
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
    
    translate([-DOOR_W+SP/2,0,-HINGE_D2/2+W/2])
//    translate([HANDLE_W/2-SP-W/2,0,0]) 
    translate([(HANDLE_W-2*W)/4+W/2,0,0]) 
    {
        hull()
        symXY([(HANDLE_W-2*W)/4,DIM[1]/2-W/2,0])
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



module container(open=false) {
    containerPart();
    
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
mode="door";
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
