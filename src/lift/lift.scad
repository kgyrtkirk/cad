
/*
    notes after assembling v1
        * need better car / fishing line connection - the line should directed up
!!!     * probably a closed loop system would work better
        * rewise top screw hole things..
        * hard to remove support inside the drum... in the topE channels
        
*/

module closedLoop(){
    sphere();
}




module attachment(type="plug",railSupport=false) {
    dim_z=2;
    H=dim_z;
    D=5;
    SCREW_D=3;
    SS=D/2;
    
    
if(type=="out") {
    translate([0,SS,H/2])
        cylinder($fn=32,d=6,h=10*H,center=true);
    
}else{
    
    translate([0,SS,H/2])
    translate( (type == "plug") ? [0,0,-dim_z] : [0,0,0] ) // hackish

    difference() {
    union() {
        cube([2*D,D,H],center=true);
        translate([0,-W,0])
        cube([2*D,D,H],center=true);
        translate([6.5,0,0]){
        cube([D,D,H],center=true);
        }
        if(railSupport)
        translate([-6.35,0,0]){
        cube([D,D,H],center=true);
        }
    }
    
        cylinder($fn=32,d=SCREW_D,h=2*H,center=true);
    }
}    
}

//attach_O();
//a=2;

module testAttach() {
translate([0,2.5,1])
cube([10,4,2],center=true);
translate([0,0,2])
attachment("plug");

if(true) 
    {
translate([0,10,0])
attachment(2);
translate([0,-10,0])
attachment(2);
}
}


FLOOR=70;
e=.1;
STAGE_H=2;
K=57;
L=90;
W=2;
SA=L*.8/2;
R0=1.6;
SB=L*.6/2 -R0-W/8;

RAIL_O=4;

    EH=FLOOR-e-STAGE_H;

    module rail(FLOOR=FLOOR){
        translate([-RAIL_O/2,-RAIL_O-W/2,0])
//    rotate(180,[0,0,1])
        difference() {
        cube([RAIL_O+W,RAIL_O+W,FLOOR]);
        translate([W,W/2,-1])
        cube([2*SA,RAIL_O,FLOOR+STAGE_H]);
        translate([W+3,-1,-1])
        cube([2*SA,RAIL_O,FLOOR+STAGE_H]);
            translate([-.1,RAIL_O+W/2-.1,EH])
        cube([RAIL_O*2,RAIL_O,RAIL_O]);
    }

    }


module wallElement(){ 
    
    translate([0,-W,0])
    rotate(180,[0,0,1]){
    translate([SA,0,0])
    attachment("socket",railSupport=true);
    translate([-SA,0,0])
    mirror()
    attachment("socket",railSupport=true);
  
    
    translate([SA,0,EH])
    attachment("plug",railSupport=true);
    translate([-SA,0,EH])
    mirror()
        
    attachment("plug",railSupport=true);
    }
    
    
    
    module atRailPositions() {
        translate([-SB,-RAIL_O,0])
//        rotate(-90,[0,0,1])
        children();
        translate([SB,-RAIL_O,0])
//        rotate(-90,[0,0,1])
        mirror([1,0,0])
        children();
    }
    
    


    CLEAR=0.4;
    atRailPositions() {
        $fn=16;
        
        difference() {
            cylinder(r=R0+W,h=FLOOR);
            cylinder(r=R0+CLEAR,h=200,center=true);
            SW=(R0+CLEAR+W);
            translate([SW,0,0])
            cube([2*SW,2*(R0+CLEAR),100*R0],center=true);

/*%            translate([sqrt(2)*2.5,-sqrt(2)*2.5,0])
            rotate(45,[0,0,1])
            cube([10,10,100*R0],center=true);*/
            rotate(180+60,[0,0,1]) {
                cube([.1,.1,100*R0],center=true); 
                translate([0,5,0])
                cube([10,10,100*R0],center=true); 
            }
            translate([0,RAIL_O,FLOOR])
            
                cube([20,RAIL_O+CLEAR,STAGE_H*2+W/2],center=true);
        }
//        translate([-W/8-R0,-(W-RAIL_O),0])
  //      rail();
    }

    p=  [
            [L/2,0,0],
            [L/2,EH,0],
            [-L/2,EH,0],
            [-L/2,0,0]];
    
    module rx(p,i,j,d) {
        $fn=32;
        hull() {
            translate(p[i]) cylinder(d=d,h=W);
            translate(p[j])cylinder(d=d,h=W);
        }
    }

    rotate(90,[1,0,0])
    intersection() {
        translate([-L/2,0,-10])
        cube([L,EH+eps*5,20]);
        union(){
            
    rx(p,0,1,4);
            hull(){
//            translate([0,W,-W*1.5])
    rx(p,1,2,4);
    rx(p,1,2,4);}
    rx(p,2,3,4);
    rx(p,3,0,4);
    rx(p,0,2,2);
    rx(p,1,3,2);
        }
    }
//    difference() {
//    linear_extrude(height=2) polygon(p);
  //  linear_extrude(center=true) offset(r=-1) polygon([p[0],p[1],p[2]]);
    //}
    
    
//    translate([
}
eps=1e-5;

    module atAttachPositions() {
    translate([0,-W,0])
    rotate(180,[0,0,1]){
    
        translate([SA,-eps,0])

    children();
        translate([-SA,-eps,0])
                mirror()
    children();
    }
    translate([0,-K,0])
    rotate(180,[0,0,1]){
            translate([0,-W,0])
    rotate(180,[0,0,1]){

    translate([SA,-eps,0])
    children();
    translate([-SA,-eps,0])
                mirror()
    children();
        }
    }
    }
    


module floorBase(H=W,cutout=false) {
        
    
    atAttachPositions()
    attachment("socket");
        
    
    
    difference(){
    translate([0,-K/2,H/2])
    cube([L,K,H],center=true);
    translate([0,-K/2,H/2])
    cube([L-2*W,K-2*W,H*5],center=true);
    
        if(cutout)
        atAttachPositions()
        attachment("out");
    }
}


module groundFloorElement() {
    GROUND_H=8-W;
    RAMP_L=50;

    union() {
           rotate(180,[1,0,0])
        color([1,0,.5])
            floorBase(GROUND_H,cutout=true);
    
        {
        L=L-W;
        K=K-W;
        color([1,0,.5])
    translate([-L/2,W/2,0]){
        for( i=[0:5] ) 
        for( j=[0:5] ) {
            if( floor(i/3) != floor(j/3))
            if( (i%3) != (j%3))
            if( (i%3) + (j%3) != 2)
            hull() {
                translate([(i%3)*L/2,floor(i/3)*K,-GROUND_H/2])
                cube([W,W,GROUND_H],center=true);
                translate([(j%3)*L/2,floor(j/3)*K,-GROUND_H/2])
                cube([W,W,GROUND_H],center=true);
            }
        }
    }
    }
    // Side supports for car on the floor
    for(y=[2*W-eps,K-W+eps]){
        translate([0,y,-GROUND_H/2])
        difference() {
        color([0,1,1])
        cube([2*SA-8,2*W,GROUND_H],center=true);
            mirror((y<K/2)?[0,1,0]:[1,0,0])
            translate([0,-3*W,0])
            rotate(45,[1,0,0])
        cube([3*SB,4*W,GROUND_H*3],center=true);
        }
    }
    
    // Front ramp
    translate([-L/2-W/2,0,0])
            rotate(180,[0,1,0])
            rotate(-90,[1,0,0])
            linear_extrude(K+W)
                polygon([[0,W],[RAMP_L,-GROUND_H],[0,-GROUND_H]]);
    
    

}
}


module floorElement(){
    floorBase();
    CONN_L0=10;
    CONN_L=25;

    CONN_H=2.5;
    CONN_T=34;
    
    translate([L/2,-K,0]) {
    color([1,0,1])
        difference() {
            pp=[[0,CONN_H-W],[CONN_L,0],[CONN_L+CONN_T,CONN_H],[0,CONN_H]];
            translate([0,0,CONN_H])
            rotate(-90,[1,0,0])
            linear_extrude(K)
                polygon(pp);
//            cube([CONN_L+CONN_T,K,CONN_H]);
        }
    }
    translate([L/2+CONN_L-CONN_L0,-K,CONN_H]) {
        S=2.1;
    color([1,0,0])
       translate([0,0,-1])
        cube([CONN_L0,K,1.7]);
        translate([CONN_L0/2,K/2,0.7+S/2])
        difference() {
    color([0,1,0])
        cube([CONN_L0,37,2*S],center=true);
        cube([32,29,S],center=true);
            translate([0,0,1])
        cube([32,20,2*S],center=true);
        }
        
    }
    
}


module car(){
    
    module atRailPositions() {
        translate([SB,K/2-RAIL_O,0])
            rotate(-90,[0,0,1])
            children();
        translate([-SB,K/2-RAIL_O,0])
            rotate(90,[0,0,1])
        mirror()
            children();
        translate([SB,-K/2+RAIL_O,0])
            rotate(-90,[0,0,1])
        mirror()
            children();
        translate([-SB,-K/2+RAIL_O,0])
            rotate(90,[0,0,1])
            children();
    }


    
    translate([0,K/2,W/2]) {
    color([0,0,1])
    difference(){
        U=W+RAIL_O+W;
        cube([L-3*W,K-4*W,W],center=true);
        atRailPositions()
        translate([0,3*U,0])
        cube([U,7*U,U],center=true);
        
        // car cutout  |A|B|
        A=3*W;  B=W;
        for( i = [0:A:L] )
        translate([-L/2 + (L%A)/2 + i,0,0])
        cube([B,K-10*W,10],center=true);

VEHICLE_WIDTH0=18;
VEHICLE_WIDTH1=35;
TIRE_WIDTH=(VEHICLE_WIDTH1-VEHICLE_WIDTH0)/2;
TIRE_OFF=(VEHICLE_WIDTH1+VEHICLE_WIDTH0)/4;
        
        for(off = [-TIRE_OFF,TIRE_OFF]){
            translate([0,off,W/2]) {
            cube([L-A*2,TIRE_WIDTH,W/2],center=true);

        for(u = [-A*4,A*4])
            translate([u,0,0])
            cube([A,TIRE_WIDTH,W],center=true);
            }
            
        }
    }
    atRailPositions()
    {
            translate([0,0,0]) {
//            rotate(-90,[0,1,0])
//                translate([W,-R0,W])
  //                  cylinder($fn=16,d=RAIL_O,h=3*W,center=true);
//                cube([RAIL_O,RAIL_O,3*W],center=true);
                
                hull(){
                    
                translate([0,0,1])
            cylinder($fn=16,r=R0,h=W,center=true);
            cylinder($fn=16,r=R0/2,h=W,center=true);
                translate([0,0,21])
            cylinder($fn=16,r=R0,h=W,center=true);
                translate([0,0,22])
            cylinder($fn=16,r=R0/2,h=W,center=true);
                }
                
        difference() {
            union() {
                hull() {
                    translate([0,0,20])
                        cube();
                    translate([0,-20,0])
                        cube();
                    translate([0,0,0])
                        cube();
                }
                hull() {
                    translate([0,-15,3])
                        cube([1,13,1]);
                    translate([0,-15,0])
                        cube([1,13,1]);
                    translate([3,-15,0])
                        cube([1,10,1]);
                }
            }
            translate([0,-2,15])
            rotate(90,[0,1,0])
            cylinder($fn=16,d=1,h=2*W,center=true);
            translate([0,-2,5])
            rotate(90,[0,1,0])
            cylinder($fn=16,d=1,h=2*W,center=true);

                
        }
                
            }
    }
    
}
}

use <scad-utils/transformations.scad>

function    to_vec3(x) = [x[0]/x[3],x[1]/x[3],x[2]/x[3] ];

echo("a",[1,2,3,4]);

// computes the tangential point
function    tpoint(e,c,r) =
    let(
            l=norm(c-e),
            s=sqrt(l*l - r*r),
            a=-asin(r/l)
        )
    e+
    (s/l)*to_vec3( 
        rotation([0,0,a])*
        concat(c-e,1)
    )
;

function unit(v) = v/norm(v);

DRUM_R=FLOOR/PI/2;

SHAFT_POINTS=[
    [ SB-W,  -2*W,0],
    [-SB+W,  -2*W,0],
    [ SB-W,-K+2*W,0],
    [-SB+W,-K+2*W,0]   ];

use <threads.scad>


//metric_thread (diameter=20, pitch=2, length=16, square=true, ///thread_size=2,
    //           groove=true, rectangle=3);


module wheelScrew(internal) {
    metric_thread (diameter=8, pitch=1, length=6,internal=internal);
}


module turnHandle(r=5,R=20,N=5,h=10,cd=1){
    translate([0,0,-h/2]){
        cylinder(r=R,h=h,center=true);
        for(i=[1:N]){
            a=i*360/N;
            translate([R*sin(a),R*cos(a),0]) {
                
                for(mZ=[0,1]) {
                    mirror([0,0,mZ])
                    translate([0,0,h/2-cd/2])
                    cylinder(r1=r,r2=r-cd,h=cd,center=true);
                }
                cylinder(r=r,h=h-2*cd,center=true);
            }
        }
    }
}

module wheelTop(){
    H=4; //duplicate in wheelTop/Bottom
    TD=4;
    SP_TOP=.1;
    DIAL_H=5;
    SP_HANDLE=3;

    color([0,1,0])
    translate([0,-K/2,-H/2]) {
        
        difference() {
            union() {
                translate([0,0,-1])
                wheelScrew(false);
                
                MID_CYL_H=TD+SP_TOP;
                translate([0,0,-MID_CYL_H/2])
                    cylinder(r=DRUM_R-.5,h=MID_CYL_H,center=true);
                
                // dial-gear
                translate([0,0,-TD]) {
                    translate([0,0,-SP_TOP])
                translate([0,0,-SP_HANDLE/2])
                    cylinder(r=DRUM_R+W,h=SP_HANDLE,center=true);
                    
                    translate([0,0,-SP_HANDLE])
                    turnHandle(r=6,R=20,N=16,h=DIAL_H);
                
                }
            }
            HANDLE_TOP_Z=-(TD+SP_TOP+DIAL_H+SP_HANDLE);
            SCREW_HEAD_HOLE=7;
            cylinder($fn=16 ,h=100,d=3,center=true);
            translate([0,0,HANDLE_TOP_Z]){
                cylinder($fn=16 ,h=8,d=SCREW_HEAD_HOLE,center=true);
            }
            translate([0,0,HANDLE_TOP_Z]){
                cylinder($fn=16 ,h=2,d2=SCREW_HEAD_HOLE,d1=SCREW_HEAD_HOLE+4,center=true);
            }
        }
        
    }
    
}   

DRUM_R1=DRUM_R+DRUM_R/2;

module wheelBottom(){
    H=4; //duplicate in wheelTop/Bottom
    R1=DRUM_R1;
color([1,0,0])
    difference() {
        // barrel
        translate([0,-K/2,0]) {

            cylinder(h=H,r=DRUM_R,center=true);
                translate([0,0,H/2])
            cylinder(h=W/2,r=R1,center=true);
                translate([0,0,-H/2])
            cylinder(h=W/2,r=R1,center=true);
            
        }
        // inner holes
        for(E = SHAFT_POINTS) {
            C=[0,-K/2,0];
            P=tpoint(E,C,DRUM_R);
            $fn=8;
            hull() {
                translate(P) sphere(d=2);
                translate(C) sphere(d=2);
            }
            hull() {
                translate((P+1*C)/2) cylinder(d=1,h=H);
                translate(C) cylinder(d=1,h=H);
            }
            
        }
        translate([0,-K/2,-H/2-1])
            wheelScrew(true);

    }

}

module topElement(){
    
    R2=DRUM_R1+W;
    //DRUM_R+W+W/2;
    
    $fn=16;
    
    translate([0,0,-10]) 
    {
        $fn=32;
        translate([0,-K,0])
        rotate(180,[1,0,0])
        floorBase(3*W,cutout=true);
        
        
        
 
        
        if(false)
            %for(x=SHAFT_POINTS)
                translate(x)
                cylinder(r=.1,h=5);

// color([0,1,0])       
        difference(){
            union(){
                translate([-L/2,-K,-3*W]) {
                    cube([L,K,W]);
                }

                difference() {
                    union() {
                        for(E = SHAFT_POINTS) {
                            C=[0,-K/2,0];
                            P=tpoint(E,C,DRUM_R);

                            difference(){
                                hull() {
                                    translate(E) 
                                    translate([0,0,-2.5*W])sphere(W/2);
                                    translate(P) 
                                    translate([0,0,-2.5*W])sphere(W/2);
                                    translate(P) sphere(d=3);
                                    translate(E) sphere(d=3);
                                }
                                hull() {
                                    translate(P) sphere(d=1);
                                    translate(E) sphere(d=1);
                                }
                                V=unit(E-P);
                                translate(E+V*W/2)
                                hull() {
                                    translate([0,0,W/2]) 
                                        sphere(W,center=true);
                                    translate([0,0,2*W]) 
                                        sphere(2*W,center=true);
                                }
                            }
                        }
                    }
                    translate([0,-K/2,0])
                    cylinder(h=100,r=R2,center=true);
                }

            }
            atAttachPositions()
                attachment(type="out");
            translate([0,-K/2,0])
                cylinder(h=100,r=DRUM_R,center=true);
        }
        


    }
    
    
}



module preview() {
    translate([0,0,-eps*100])
    groundFloorElement();
    
    translate([0,0,W])
    rotate(180,[1,0,0])
    floorElement();
    
    translate([0,K+e,FLOOR])
    rotate(180,[0,1,0])
    wallElement();
    translate([0,0,FLOOR+e])
    rotate(180,[0,1,0])
    rotate(180,[0,0,1])
    wallElement();
    
    translate([0,0,30])
    car();

    translate([0,K,FLOOR+W]) {
        rotate(180,[0,1,0]) {
        topElement();
        translate([0,0,-10]) {
        wheelBottom();
        wheelTop();
        }

        }
    }
    
}

module wheelDev() {
    
    difference() {
        union() {
            rotate(180,[0,1,0]) {
                topElement();
                translate([0,0,-10])  {
                    wheelBottom();
                    wheelTop();
                }
            }
        }
        
        translate([50,0,0])
        cube([100,200,100],center=true);
    }

}

mode="closedLoop";
//mode="preview";
//mode="topElement";

if(mode == "closedLoop"){
    closedLoop();
}

if ( mode == "sphere"){
    $fn=64;
/*    difference(){
        sphere(d=30,center=true);
//        translate([-100,-100,-200])
  //      cube(200);
    }

*/    
    cylinder(h=11,d=5.8);
    
    
}
if ( mode == "attach"){
    testAttach();
}
if ( mode == "car"){
    car();
}
if ( mode == "floor") {
    floorElement();
}
if ( mode == "ground") {
    groundFloorElement();
}
if( mode == "wall") {
    rotate(-90,[1,0,0]) wallElement();
}
if(mode == "preview"){
    preview();
}
if(mode == "wheelDev"){
    wheelDev();
}
if(mode == "topElement"){
    topElement();
}
if(mode == "wheelBottom"){
    wheelBottom();
}
if(mode == "wheelTop"){
    wheelTop();
}

//rotate(-90,[1,0,0]) wallElement();
//floorElement();



