$fn=32;

WALL_TH=.8;     // 1/2 of wall thickness

STRAP_H0=WALL_TH*3;
STRAP_H1=WALL_TH*2;
STRAP_D=.2;
STRAP_W=WALL_TH*16;
STRAP_R=1.5*WALL_TH;

PCB_BELOW=2;
PCB_T=1.6;      // pcb thickness
PCB_Z=2;        // spacing between pcb/botton
PCB_OVER=16.555;
//PCB_OVER=16;       // space needed above pcb
PCB_S=2-PCB_T+STRAP_R;  // spacing between pcb/wall

MIL=25.4/1000;
PCB_W=3400 * MIL;
PCB_W0=2300 * MIL;  //  start of dht section
PCB_DHT_Z0=50*MIL-WALL_TH;     // dht section hight
PCB_DHT_Z1=150*MIL;     // leave some space?!
PCB_DHT_YC=350*MIL;     // center of dht pin section
PCB_DHT_SPACE=350*MIL;  // 600 dia => 350
PCB_H=1800*MIL;//45.7;//2000 * MIL;
PCB_HB_X=(3400/2-750) * MIL;
PCB_HB_Y=450 * MIL;
PCB_HA_X1=850 * MIL;
PCB_HA_X2=2950 * MIL;
PCB_HA_Y=500 * MIL;

PIR_X=1700*MIL;
PIR_Y= 1300*MIL;
LR_X=3950*MIL;


doProjs=false;

if(PCB_DHT_SPACE - WALL_TH-300*MIL < 0){
    design_error();
}

module holeCutter(w) {
	translate([0,0,-5])
	cylinder(d1=w,d2=w,h=10);
}

module atPcbMountHolePositions() {
translate([PCB_HA_X1,PCB_HA_Y,0])
	children();
translate([PCB_HA_X2,PCB_HA_Y,0])
	children();
}
module atBoxMountHolePositions() {
translate([PCB_HB_X,PCB_H-PCB_HB_Y,0])
	children();
translate([PCB_W-PCB_HB_X,PCB_H-PCB_HB_Y,0])
	children();
}
module pcb() {
    color([.3,.7,0])
    difference() {
    cube([PCB_W,PCB_H,PCB_T] );
    atPcbMountHolePositions()
        holeCutter(2);
    atBoxMountHolePositions()
        holeCutter(8);
    }
}

module wall_comp(){
        sphere(r=WALL_TH,$fn=32);
//      cube([2*WALL_TH,2*WALL_TH,2*WALL_TH],center=true);
}
module wall( a,b ){
    if($children == 0){
        wall(a,b) wall_comp();
    }else{
    color([.9,.9,.3])
        hull(){
            translate(a)
            children();
            translate(b)
            children();
            d=b-a;
            if(d[0]==0){
                translate([a[0],b[1],a[2]])
                children();
                translate([b[0],a[1],b[2]])
                children();
            }else{
                translate([b[0],a[1],a[2]])
                children();
                translate([a[0],b[1],b[2]])
                children();
            }
        }
    }
}

A=WALL_TH+PCB_S+PCB_W+PCB_S+WALL_TH;
A0=WALL_TH+PCB_S+PCB_W0+/*PCB_S+*/WALL_TH;
B=WALL_TH+PCB_S+PCB_H+PCB_S+WALL_TH;
B0=WALL_TH+PCB_S+PCB_DHT_YC+PCB_DHT_SPACE+WALL_TH;
D=WALL_TH+PCB_Z+PCB_T+PCB_OVER+WALL_TH;
D0=WALL_TH+PCB_Z+PCB_T+PCB_DHT_Z0;


module mainBox(){
    union(){
    // RIGHT
    wall( [0,0,0], [A0,0,D] );
    wall( [0,0,0], [A,0,D0] );
    // BACK
    wall( [A,B,0], [A,0,D0] );
    // HATCH
    wall( [A,0,D0], [A0,B0,D0] );
    wall( [A0,0,D], [A0,B0,D0] );
    wall( [A0,B0,D], [A,B0,D0] );
    wall( [A,B,D], [A,B0,D0] );
    // LEFT
    wall( [A,B,D], [0,B,0] );
    // FRONT
    wall( [0,0,0], [0,B,D] );
    // top
    wall( [0,0,D], [A0,B,D] );
    wall( [0,B0,D], [A,B,D] );
    
    wall( [0,0,0], [A,B,0] ) cylinder(d=2*WALL_TH,h=2*WALL_TH,center=true);
    }
}
module dhtHoles(){
    
    translate([ WALL_TH+PCB_S+PCB_W0,
            WALL_TH+PCB_S+PCB_DHT_YC,
            WALL_TH+PCB_Z+PCB_T+PCB_DHT_Z1])
    {
        // dht pins
        rotate(90,[0,1,0])
        {
            for( i = [-1.5:1:1.5] )
                translate([0,i*2.54,0])
                cylinder(d=1,h=10,center=true);
        }
        translate([(50+850)*MIL+WALL_TH,0,0])
        cylinder(d=3,h=10,center=true);
    }
}
module pirDome(){
//        cylinder(h=10,d=23,center=true);
        cylinder(h=2*WALL_TH,d1=23+WALL_TH,d2=23-0.001,center=true);
}

module dcPlug(){
    translate([-5,0,0])
    translate([10,9,11]/2)
    cube([10,10,12],center=true)
//    cube([10,9,11]);
    ;
}
module jackPlug(){
    translate([0,0,0.1])
    translate([-5,0,2.5])
    rotate(90,[0,1,0])
    cylinder(d=5,h=10);
}


module windowCut(w,s){
    hull(){
        cylinder(d=w,h=3*WALL_TH,center=true);
        translate([s,0,0])
        cylinder(d=w,h=3*WALL_TH,center=true);
    }
    cube([w,w,WALL_TH],center=true);
    translate([0,0,-WALL_TH])
    cylinder(d=w*1.1,h=3*WALL_TH,center=true);
    
    translate([s,0,0]){
    cube([w,w,WALL_TH],center=true);
    translate([0,0,-WALL_TH])
    cylinder(d=w*1.1,h=3*WALL_TH,center=true);
    }

}
/*
projection(cut=true)
translate([0,0,-PCB_Z-PCB_T])
{
    translate([WALL_TH+PCB_S,WALL_TH+PCB_S,WALL_TH+PCB_Z])
    pcb();
    
    mainBox();
    dhtHoles();
}
*/
//projection(cut=true)
//translate([0,0,-WALL_TH-PCB_Z-PCB_T-PCB_DHT_Z0])
module product(with_pcb)
{
    if(with_pcb){
        translate([WALL_TH+PCB_S,WALL_TH+PCB_S,WALL_TH+PCB_Z])
        pcb();
    }
    difference(){
        union(){
            mainBox();
            translate([WALL_TH+PCB_S,WALL_TH+PCB_S,0]) {
//                atPcbMountHolePositions()
//                    cylinder(d=4,h=PCB_Z+WALL_TH);
                atBoxMountHolePositions()
                    cylinder(d=8+1.5,h=PCB_Z+WALL_TH);
            }
        }
        
        translate([WALL_TH+PCB_S,WALL_TH+PCB_S,WALL_TH]) {
//            atPcbMountHolePositions()
//                cylinder(d=1.9,h=2*(PCB_Z+WALL_TH),center=true);
            atBoxMountHolePositions() {
                cylinder(d=8,h=PCB_Z+1);
                cylinder(d=4,h=2*(PCB_Z+WALL_TH),center=true);
            }
        }

        dhtHoles();
        
 
        translate([ WALL_TH+PCB_S+PIR_X,
                    WALL_TH+PCB_S+PIR_Y,
                    WALL_TH+PCB_Z+PCB_T+PCB_OVER+WALL_TH])
        pirDome();
        translate([ WALL_TH+PCB_S,
                    WALL_TH+PCB_S+1+150*MIL,
                    WALL_TH+PCB_Z+PCB_T])
        dcPlug();
        translate([ WALL_TH+PCB_S,
                    WALL_TH+PCB_S+1+500*MIL,
                    WALL_TH+PCB_Z+PCB_T])
        dcPlug();
        translate([ WALL_TH+PCB_S,
                    WALL_TH+PCB_S+1550*MIL,
                    WALL_TH+PCB_Z+PCB_T])
        jackPlug();
    }
}

module zBox(z0,z1){
    c=(z0+z1)/2;
    d=abs(z1-z0);
    translate([0,0,c])
    cube([3*A,3*B,d],center=true);
}

module snap0(cut_offset=0){
    translate([0,WALL_TH,0]) {
        // center of strap
        STRAP_LEN=STRAP_H0+STRAP_H1+cut_offset;
        points = [  [ 0,0 ], [ -WALL_TH,-STRAP_R],
                    [ 0,-STRAP_R],
                    [ STRAP_R,0 ],
                    [ STRAP_R, STRAP_H0],
                    [ 0, STRAP_LEN],
                    [ -STRAP_D, STRAP_LEN],
                    [ -STRAP_D, STRAP_H0],
                    [ 0, STRAP_H0]
                ];
        rotate(90,[0,0,1])
        rotate(90,[1,0,0])
        linear_extrude(height=STRAP_W++cut_offset,center=true){
        polygon(points);
        }
        
        if(cut_offset>0){
            translate([0,0,STRAP_H0+STRAP_H1/2])
            rotate(90,[1,0,0])
                    cylinder(h=WALL_TH*10,d=cut_offset);
        }
//        cube([2*WALL_TH,WALL_TH*2,2*WALL_TH],center=true);
    }
}

module unionDiffOperator(diff){
    if(diff){
        difference(){
            children(0);
            children([1:1:$children-1]);
        }
    }else{
        union(){
            children();
        }
    }
    
}
module straps( idx, mask, rotation, loc_xy, yValues){
    
        strap_cut=idx == 1 ? 1 : 0;
/*
        if(idx == 1 || (idx==2 && mask>=2))
        translate(concat(loc_xy,[yValues[1]]))
        rotate(rotation,[0,0,1])
        rotate(180,[0,1,0])
        snap0(strap_cut);
  */  
        if((mask%2)==1 && idx != 2)
        translate(concat(loc_xy,[yValues[0]]))
        rotate(rotation,[0,0,1])
        rotate(0,[0,1,0])
        snap0(strap_cut);
    
}

module product1(partIdx,pcb=false){
    
    unionDiffOperator(diff=(partIdx==1)){
        yValues=[D0-WALL_TH, D-WALL_TH];
        difference(){
            product(pcb);
            cut_y=[ -2*WALL_TH, yValues[0], D+2*WALL_TH ];
            zBox( cut_y[0], cut_y[partIdx]);
            zBox( cut_y[partIdx+1], cut_y[2]);
        }
    
        
        straps( partIdx, 3, 0, [A/2,0], yValues );
        straps( partIdx, 3, 0, [A/4,0], yValues );
        straps( partIdx, 3, 0, [WALL_TH+STRAP_W,0], yValues );
        straps( partIdx, 3, 0, [A0-WALL_TH-STRAP_W,0], yValues );
        straps( partIdx, 3, 270, [0,B*.63], yValues );

        
        straps( partIdx, 3, 180, [A/4,B], yValues );
        straps( partIdx, 3, 180, [A/2,B], yValues );
        straps( partIdx, 3, 180, [A*3/4,B], yValues );
        straps( partIdx, 3, 180, [WALL_TH+STRAP_W,B], yValues );
        straps( partIdx, 3, 180, [A-(WALL_TH+STRAP_W),B], yValues );
     //   straps( partIdx, 2, 0, [(A+A0)/2,B0], yValues );
        //straps( partIdx, 3, 90, [A,(B0+B)/2], yValues );
        straps( partIdx, 3, 90, [A,B0+STRAP_W], yValues );
        straps( partIdx, 3, 90, [A,B-STRAP_W], yValues );
        
//        strap
        
/*        translate([A/2,0,D-WALL_TH])
        rotate(180,[0,1,0])
        snap0(strap_cut);
        translate([A0-WALL_TH-STRAP_W,0,D-WALL_TH])
        rotate(180,[0,1,0])
        snap0(strap_cut);*/
    }
}

mode="preview";

if(mode=="project"){
    projection(cut=true) {
        // dht plane
        translate([3*WALL_TH,0,-WALL_TH-PCB_Z-PCB_T-PCB_DHT_Z0])
        product();
        // pcb plane
        translate([3*WALL_TH,B+3*WALL_TH,-WALL_TH-PCB_Z-PCB_T/2])
        product(true);
        // top plane
        translate([3*WALL_TH,-B-3*WALL_TH,-WALL_TH-PCB_Z-PCB_T-PCB_OVER-WALL_TH])
        product(true);
        // connectors
        rotate(-90,[0,1,0])
        product(true);
        // dht side
        translate([0,B+3*WALL_TH,0])
        rotate(-90,[0,1,0])
        translate([-A0,0,0])
        product(true);
        // dht side2
        translate([0,-B-3*WALL_TH,0])
        rotate(-90,[0,1,0])
        translate([-A0-2*WALL_TH,0,0])
        product(true);
    }
}
if(mode=="preview") {
    product1(0,true);
    translate([0,0,10])
    product1(1,true);
//    translate([0,0,20])
  //  product1(2);
}

if(mode=="bottom") {
    product1(0);
}
if(mode=="top") {
    rotate(180,[1,0,0])
    product1(1);
}
