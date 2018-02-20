

module attachment(type="plug",extraL=0) {
    dim_x=10;
    dim_y=5;
    dim_z=2;
    e=.1/2;
    plug_z=dim_z+2;
    W=1.2;
    plug_w=2;
    plug_a=.6;
    plug_mid=dim_z+4*e+.2;
    
    module pole(){
        translate([plug_w,0,extraL])
        rotate(90,[1,0,0])
        color([0,1,0]){
            linear_extrude(height=dim_y-2*W,  slices=20, twist=0,center=true)
          polygon(points=[[0,-extraL],[0,plug_mid],[plug_a,plug_mid],
                    [plug_a,plug_z+e],
                    [plug_a,plug_z-1],
                    [plug_a-1,plug_z+e],
                    [-plug_w,plug_z+e],
                    [-plug_w,-extraL]
                ]);
            }
    }

if(true){
translate([0,dim_y/2,0])
    translate([0,-1,0])
    if(type == "plug"){
        k=dim_x/2-W-e-plug_w;
        translate([k,0,0])
        pole();
        translate([-k,0,0])
        rotate(180,[0,0,1])
        pole();
        translate([0,0,-dim_z/2])
        cube([1.5*dim_x,dim_y,dim_z],center=true);
    }else{
        color([1.0,0,0])
        translate([0,0,dim_z/2])
        difference() {
            union(){
            cube([dim_x,dim_y,dim_z],center=true);
        cube([1.4*dim_x,dim_y,dim_z],center=true);
            }
            cube([dim_x-2*W,dim_y-2*W,dim_z*2],center=true);
        }
    }
}   else{
    H=dim_z;
    D=5;
    SCREW_D=3;
    translate([0,D/3,H/2])
    difference() {
        hull() {
            cylinder($fn=6,d=D,h=H,center=true);
            translate([0,-D/3,0])
            cube([2*D,e,H],center=true);
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
attachment("plug",2);

if(true) 
    {
translate([0,7,0])
attachment(2);
translate([0,-7,0])
attachment(2);
}
}


FLOOR=75;
e=.1;
STAGE_H=2;
K=57;
L=90;
W=2;
SA=L*.8/2;
SB=L*.6/2;

RAIL_O=4;

module wallElement(){ 
    EH=FLOOR-e-STAGE_H;
    
    translate([0,-W,0])
    rotate(180,[0,0,1]){
    translate([SA,0,0])
    attachment("socket");
    translate([-SA,0,0])
    attachment("socket");
  
    
    translate([SA,0,EH])
    attachment("plug",STAGE_H);
    translate([-SA,0,EH])
    attachment("plug",STAGE_H);
    }
    
    module rail(){
        translate([-RAIL_O/2,-RAIL_O-W/2,0])
//    rotate(180,[0,0,1])
        difference() {
        cube([RAIL_O+W,RAIL_O+W,FLOOR]);
        translate([W,W/2,-1])
        cube([2*SA,RAIL_O,FLOOR+STAGE_H]);
        translate([W+1,-1,-1])
        cube([2*SA,RAIL_O,FLOOR+STAGE_H]);
            translate([-.1,RAIL_O+W/2-.1,EH])
        cube([RAIL_O*2,RAIL_O,RAIL_O]);
    }

    }
    
    translate([-SB,-W,0])
    rail();

    translate([SB,-W,0])
    //rotate(180,[0,0,1])
    mirror([1,0,0])
    rail();

/*    
    translate([0,-W,0])
    rotate(180,[0,0,1])
    difference(){
    cube([RAIL_O+W,RAIL_O+W,FLOOR]);
    cube([RAIL_O,RAIL_O,2*FLOOR]);
    }
  */  
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
module floorElement(){
    translate([0,-W,0])
    rotate(180,[0,0,1]){
    
    translate([SA,-eps,0])
    attachment("socket");
    translate([-SA,-eps,0])
    attachment("socket");
    }
        
    translate([0,-K,0])
    rotate(180,[0,0,1]){
            translate([0,-W,0])
    rotate(180,[0,0,1]){

    translate([SA,-eps,0])
    attachment("socket");
    translate([-SA,-eps,0])
    attachment("socket");
    }
    }
    
    translate([0,-K/2,W/2])
    difference(){
    cube([L,K,W],center=true);
    cube([L-2*W,K-2*W,W*5],center=true);
    }
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
        S=1.7;
    color([1,0,0])
       translate([0,0,-1])
        cube([CONN_L0,K,1.7]);
        translate([CONN_L0/2,K/2,0.7+S/2])
        difference() {
    color([0,1,0])
        cube([CONN_L0,37,2*S],center=true);
        cube([32,29,S],center=true);
            translate([0,0,1])
        cube([32,20,1.5],center=true);
        }
        
    }
    
}


module car(){
    R0=1.6;
    
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
    }
            atRailPositions()
    {
            translate([0,-R0-W/8,0]) {
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
                translate([0,0,22+R0])
                rotate(90,[1,0,0])
                difference() {
            cylinder($fn=16,r=R0,h=W/2,center=true);
            cylinder($fn=16,r=R0/2,h=2*W,center=true);
                }
                
                hull() {
                    translate([0,0,20])
                        cube();
                    translate([0,-20,0])
                        cube();
                    translate([0,0,0])
                        cube();
                    
                }
                
            }
    }
    
}
}

//testAttach();

module preview() {
    translate([0,0,2])
    rotate(180,[1,0,0])
    floorElement();
    
    translate([0,K+e,2])
    wallElement();
    translate([0,0,2+e])
    rotate(180,[0,0,2])
    wallElement();
    
    translate([0,0,30])
    car();

}

mode="preview";
if ( mode == "car"){
    car();
}
if ( mode == "floor") {
    floorElement();
}
if( mode == "wall") {
    rotate(-90,[1,0,0]) wallElement();
}
if(mode == "preview"){
    preview();
}
//rotate(-90,[1,0,0]) wallElement();
//floorElement();



