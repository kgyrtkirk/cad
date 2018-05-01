
/*
    notes after assembling v1
        * need better car / fishing line connection - the line should directed up
!!!     * probably a closed loop system would work better
        * rewise top screw hole things..
        * hard to remove support inside the drum... in the topE channels
        
    before v2:
        * car attach up&down
        * floor - tying is complicated; add something...
    
        * ramp element: ramp top seems to be W not WALL_W do I still need W=2?
        * attachments of ground seems to be separated...possibly eps problem
    
    
        
*/

function rZ(a,newZ) = [a[0],a[1],newZ];

FLOOR=70;   // DUP!
DRUM_R=FLOOR/PI/2;// DUP!
ROD_R=6;
ROD_LEN=90;
INTERMED_R=ROD_R+2;

K=57;
L=90;

HOLE_D=1;
CHANNEL_D=3;

CH_U=L/2*.8;
CH_D=L/2*.6;
CH_X=K/2*.9;

CH_C=(CH_U+CH_D)/2;

FLOOR=70;
e=.1;
WALL_W=3;
STAGE_H=WALL_W;
W=2;
SB=CH_U;
R0=1.6;
SA=CH_D/2;

RAIL_O=WALL_W+W;
CH_D_O=WALL_W/2;

EH=FLOOR-e-STAGE_H;


// these names might be misleading; they are used in wheels
DW=2;
EDGE=5;
EDGE_W=1;

WHEEL_THICK=DW*2+EDGE_W;

INTERMED_H=CH_U-CH_D-WHEEL_THICK-.1;


module symY(t) {
    translate(t)
        children();
    mirror([0,1,0])
        translate(t)
            children();
}

module cableTiePost(){
    HB=2;
    HT=1;
    D1=4;
    D2=6;
    $fn=16;
    color([0,1,0])
    difference() {
        union() {
            cylinder(h=HB,d=D1);
            translate([0,0,HB])
            cylinder(h=HT,d1=D1,d2=D2);
        }
        // bottom/main hole
        hull() {
            translate([5,0,HB/2])   sphere(d=HOLE_D);
            translate([-5,0,HB/2])  sphere(d=HOLE_D);
        }
        // finalizer engrave
        hull() {
            translate([0,5,HB+HT-HOLE_D*1/3])   sphere(d=HOLE_D);
            translate([0,-5,HB+HT-HOLE_D*1/3])  sphere(d=HOLE_D);
        }
    }
}

module closedLoop(){
    
    module  atChannels0(xScale,yScale=1){
        translate([xScale*CH_X,yScale*CH_U,0])             mirror([0,1,0])
                    children();
        translate([xScale*CH_X,yScale*CH_D,0])                   children();
    }
    module  atChannels1(xScale,yScale=1){
        atChannels0(xScale,yScale) children();
        mirror([0,1,0])
        atChannels0(xScale,yScale) children();
    }
    module  atChannels(xScale=1,yScale=1) {
        atChannels1(xScale,yScale) children();
        mirror([1,0,0])
        atChannels1(xScale,yScale) children();
    }
    module  mainRodCut() {
        cube([ROD_R+.1,ROD_R+.1,ROD_LEN],center=true);
    }
    
    module wheelIntermed() {
        difference() {
            union() {
                $fn=64;
                echo("interH",INTERMED_H);
                cylinder(r=INTERMED_R,h=INTERMED_H,center=true);
            }
//            rotate(45)
            symY([0,ROD_R,0])
            cylinder($fn=16,d=HOLE_D,h=20,center=true);
            mainRodCut();
        }
    }
    
    module wheelDrum(){
        difference() {
            union() {
                $fn=64;
                translate([0,0,0])
                cylinder(r=DRUM_R,h=DW*2,center=true);
                translate([0,0,DW])
                cylinder(r=DRUM_R+EDGE,h=EDGE_W,center=true);
                translate([0,0,-DW])
                cylinder(r=DRUM_R+EDGE,h=EDGE_W,center=true);
                symY([0,DRUM_R,EDGE_W+DW/2])
                cableTiePost();
            }
            symY([0,DRUM_R,0])
            cylinder($fn=16,d=HOLE_D,h=50,center=true);
            // holes near rod for main position
            rotate(90,[0,0,1])
            symY([0,ROD_R,0])
            cylinder($fn=16,d=HOLE_D,h=50,center=true);
            
            mainRodCut();
        }
    }
    
    module  mainRod() {
        difference() {
            union() {
                cube([ROD_R,ROD_LEN,ROD_R],center=true);
                //cylinder($fn=4, r=DRUM_R/2,h=ROD_LEN,center=true);
    S=CH_D-WHEEL_THICK/2-.1;
                color([1,0,0])
                cube([ROD_R+W,2*S,ROD_R+W],center=true);
//                cylinder($fn=4, r=DRUM_R/2+W,h=2*S,center=true);
            }
            
            symY([0,CH_C,0])
            symY([0,WHEEL_THICK/2+(CH_U-CH_D)/2+HOLE_D+.5,0])
            rotate(90,[0,0,1])
            rotate(90,[1,0,0]) {
                $fn=16;
            cylinder(d=HOLE_D,h=100,center=true);
            }
        }
    }
    module  mainRodPreview() {
        
//        rotate(90,[1,0,0])
        mainRod();
        // note: screw pos?
        // probably atChannels is abad idea
        atChannels1(xScale=0){
            rotate(90,[1,0,0]) {
                wheelDrum();
            }
        }
        symY([0,CH_C,0])
        rotate(90,[1,0,0])
        wheelIntermed();
    }
    
    
    module channel(y_off,top) {
        CH_X=
         (y_off==CH_U)?
            K/2-RAIL_O :
            K/2-CH_D_O;
        
        $fn=16;
        o=[CH_X,y_off,(top?1:-1)*DRUM_R];
        i=[DRUM_R,y_off,(top?1:-1)*DRUM_R];
        top=DRUM_R*2;
        
        difference() {
            hull() {
                translate(o)            sphere(d=CHANNEL_D);
                translate(i)            sphere(d=CHANNEL_D);
                translate(rZ(i,top))    sphere(d=CHANNEL_D);
            //    translate(rZ(i,top))    sphere(d=CHANNEL_D);
            }
            
            hull() {
                translate(o)            sphere(d=HOLE_D);
                translate(i)            sphere(d=HOLE_D);
            }
            translate([0,0,-1])
            translate(o)            sphere(d=CHANNEL_D);
            translate([CH_X,y_off,(top?1:-1)*DRUM_R]) {
//                sphere(d=HOLE_D);
            }
        }
    }
    
    // channels
    module topChannels() {
        difference() {
            union() {
                channel(CH_U,true);
                channel(CH_D,false);
                mirror() {
                    channel(CH_U,false);
                    channel(CH_D,true);
                }
                mirror([0,1,0]) {
                    channel(CH_U,true);
                    channel(CH_D,false);
                    mirror() {
                        channel(CH_U,false);
                        channel(CH_D,true);
                    }
                }
            }
            rotate(90,[1,0,0]) {
                cylinder(r=DRUM_R+7,h=ROD_LEN,center=true);
            }
        }
    }
    module topCage() {
        color([0,0,1])
        symY([0,CH_C,0]) {
            rotate(90,[1,0,0])
            difference() {
                cylinder(r=INTERMED_R+2*W,h=INTERMED_H-1,center=true);
                cylinder(h=100,r=INTERMED_R+.1,center=true);
            }
        }
        topChannels();
    }
    
    mainRodPreview();
!    topCage();

}





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

WALL_HEIGHT=2.5*FLOOR;

module floorCutPattern(pat=0){
    eps1=1e-2;
    eps2=1e-1;
    DIA=1;
    $fn=16;
    for(X=[CH_D,-CH_D])
    translate([X,-WALL_W/2,WALL_W/2]) {
        cylinder(d=DIA,h=2*L,center=true);
        cube(WALL_W+eps1,center=true);
    }
    
    rotate(-90,[0,1,0]) {
        translate([WALL_W/2,-WALL_W/2,0])
        cylinder(d=DIA,h=2*L,center=true);
        
    }
    N=5;
    for(i=[0:N-1]) {
        L=L-2*W;    // override L to remove
        x0=-L/2+L/2/N*i;
        x1=-L/2+L/2/N*(i+1);
        if( pat != i%3 ){
            for(X=[(x0+x1)/2,-(x0+x1)/2])
            translate([X,-WALL_W/2,WALL_W/2]){
                cube([x1-x0+eps2*2,WALL_W+eps2,WALL_W+eps2],center=true);
            }
        }
    }
}

module wallElement(){ 
    W0=W;
    W=WALL_W;
    eps2=.2;
    
    module atRailPositions() {
        translate([-SB,-RAIL_O,0])
        children();
        translate([SB,-RAIL_O,0])
        mirror([1,0,0])
        children();
    }
    
    module mainRails() {
        CLEAR=0.4;
        atRailPositions() {
            $fn=32;
            difference() {
                cylinder(r=R0+W,h=WALL_HEIGHT);
                cylinder(r=R0+CLEAR,h=WALL_HEIGHT*3,center=true);
                SW=(R0+CLEAR+W);
                translate([SW,0,0])
                cube([2*SW,2*(R0+CLEAR),WALL_HEIGHT*3],center=true);

                rotate(180+60,[0,0,1]) {
                    cube([.1,.1,WALL_HEIGHT*3],center=true); 
                translate([0,5,0])
                    cube([10,10,WALL_HEIGHT*3],center=true); 
                }
            }
        }
    }
    
    LL=L-2*W0-eps2;
    module floorFortification() {
        EH=FLOOR/2;
        L=LL;
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
                rx(p,2,3,4);
                rx(p,3,0,8);
                rx(p,0,2,2);
                rx(p,1,3,2);
            }
        }
    }
    
    module bottomCableChannel(){
        eps1=1e-1;
        $fn=32;
        L_W=WALL_W-eps1;
        translate([0,0,-WALL_W/2])
        difference() {
            union() {
            hull() {
                translate([CH_D,-CH_D_O,0])
                cylinder(d=L_W,h=L_W,center=true);
        //        cube(L_W,center=true);
                translate([CH_U,-RAIL_O,0])
                cylinder(d=L_W*1.5,h=L_W,center=true);
                translate([CH_U,-CH_D_O,0])
                cube(L_W,center=true);
            }
            translate([CH_U,-CH_D_O,eps1])
                cube(L_W,center=true);
            }
        
            

            
            translate([CH_D,-CH_D_O,W/2])
            sphere(d=L_W*1.5,center=true);
            translate([CH_U+2,-RAIL_O,W/2])
            rotate(60,[0,1,0])
            cube(5.5,center=true);
//            sphere(d=L_W*2,center=true);
            
            hull() {
                translate([CH_D,-CH_D_O,0])
                sphere(d=HOLE_D,center=true);
                translate([CH_U,-RAIL_O,0])
                sphere(d=HOLE_D,center=true);
            }
            
        }
    }
    
    difference() {
        union(){ 
            mainRails();
            union(){
                for( pos_y=[0:FLOOR:WALL_HEIGHT]) {
                    translate([0,0,pos_y]) {
                        floorFortification();
                        translate([0,0,(pos_y==0)?WALL_HEIGHT:0]) // ugly trick
                        mirror([0,0,1])
                        translate([0,0,eps])
                        floorFortification();
                    }
                }
            }
            bottomCableChannel();
            mirror()
            bottomCableChannel();
            translate([0,-W/2,WALL_HEIGHT+W/2-.01])
            cube([LL,W,W],center=true);
            
        }
        for( pos_y=[0:FLOOR:WALL_HEIGHT+FLOOR]) {
            translate([0,0,min(WALL_HEIGHT,pos_y)])
            floorCutPattern();
        }
    }
    
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
    


module floorBase(H=WALL_W,cutout=false) {
    
    pattern=cutout?2:1;

    module atCutPos(){
        children();
        translate([0,-K+WALL_W,0])children();
    }
        
    difference(){
        union() {
            translate([0,-K/2,H/2])
                cube([L,K+2*WALL_W,H],center=true);
            if(cutout)
            translate([0,-K/2,H/2-WALL_W])
                cube([L-2*WALL_W,K,H],center=true);
        }
        translate([0,-K/2,H/2])
            cube([L-2*W,K-2*WALL_W,H*5],center=true);
        translate([0,-K/2,H/2+WALL_W])
            cube([L-2*W,K,H],center=true);
        
        // grave into to back of the floor element
        if(!cutout) {
            $fn=16;
            hull(){
                translate([-L/2,-WALL_W/2,H/2])
                atCutPos()
                    sphere(d=HOLE_D,center=true);
            }
            
        }
        
        if(cutout) {
            atCutPos()
            translate([0,0,-WALL_W])
            floorCutPattern(pattern);
        }
//        }else{
            atCutPos()
            floorCutPattern(pattern);
    //    }
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
    for(y=[W-eps,K+eps*10]){
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
    translate([-L/2-W/2+eps*10,WALL_W,0])
            rotate(180,[0,1,0])
            rotate(-90,[1,0,0])
            linear_extrude(K+W-2*WALL_W)
                polygon([[0,W],[RAMP_L,-GROUND_H],[0,-GROUND_H]]);
    
    

}
}


module floorElement(){
    floorBase();
    CONN_L0=10;
    CONN_L=25;

    CONN_H=2.5;
    CONN_T=34;
    
    // ramp'n clamp
    translate([L/2,-K,0]) {
    color([1,0,1])
        difference() {
            pp=[[0,CONN_H-W],[CONN_L,0],[CONN_L+CONN_T,CONN_H],[0,CONN_H]];
            translate([0,0,CONN_H])
            rotate(-90,[1,0,0])
            linear_extrude(K)
                polygon(pp);
//            cube([CONN_L+CONN_T,K,CONN_H]);
            translate([0,K/2,0])
            symY([0,(K/2-WALL_W/2),0])
                hull() {
                    $fn=16;
                    translate([0,0,WALL_W/2])
                    sphere(d=HOLE_D,center=true);
                    translate([20,0,4])
                    sphere(d=HOLE_D,center=true);
                }
        }
    }

    color([0,1,1])
    translate([0,-K/2,0])
    symY([L/2+7,K/4+5,W]) {
        cableTiePost();
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
        cube([L-3*W,K-2*W-2*WALL_W,W],center=true);
        atRailPositions()
        translate([0,3*U,0])
        cube([U,7*U,U],center=true);
        
        // car cutout  |A|B|
        A=3*W;  B=W;
        for( i = [0:A:L] )
        translate([-L/2 + (L%A)/2 + i,0,0])
        cube([B,K-11*W,10],center=true);

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

module preview() {
    translate([0,0,-eps*100])
    groundFloorElement();
    
    for(Y=[0:FLOOR:2*FLOOR])
    translate([0,0,WALL_W+Y])
    rotate(180,[1,0,0])
    floorElement();

    
    translate([0,K+e,0])
//    rotate(180,[0,1,0])
    wallElement();
    translate([0,0,0])
//    rotate(180,[0,1,0])
    rotate(180,[0,0,1])
    wallElement();
    
    translate([0,0,30])
    car();


/*    translate([0,K/2,WALL_HEIGHT+DRUM_R])
    rotate(90,[0,0,1])
    closedLoop();*/
}

mode="closedLoop";
//mode="preview";
//mode="floor";

if(mode == "closedLoop"){
    
    closedLoop();
//    translate([-K/2,0,0])
  //  rotate(90,[0,0,1])
    //wallElement();
}

if ( mode == "sphere"){
    $fn=64;
/*    difference(){
        sphere(d=30,center=true);
//        translate([-100,-100,-200])
  //      cube(200);
    }

*/
        sphere(d=10);
//    cylinder(h=11,d=5.8);
    
    
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
    rotate(-90,[1,0,0]) 
    wallElement();
}
if(mode == "preview"){
    preview();
}


