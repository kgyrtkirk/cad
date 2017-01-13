$fn=32;

PCB_BELOW=2;
PCB_T=1.6;      // pcb thickness
PCB_S=2-PCB_T;  // spacing between pcb/wall
PCB_Z=2;        // spacing between pcb/botton
PCB_OVER=16.555;
WALL_TH=.8;     // 1/2 of wall thickness

MIL=25.4/1000;
PCB_W=4400 * MIL;
PCB_W0=3300 * MIL;  //  start of dht section
PCB_DHT_Z0=300*MIL;     // dht section hight
PCB_DHT_Z1=350*MIL;     // leave some space?!
PCB_DHT_YC=450*MIL;     // center of dht pin section
PCB_DHT_SPACE=350*MIL;  // 600 dia => 350
PCB_H=2000 * MIL;
PCB_HB_X=1200 * MIL;
PCB_HB_Y=450 * MIL;
PCB_HA_X1=850 * MIL;
PCB_HA_X2=3950 * MIL;
PCB_HA_Y=500 * MIL;

PIR_X=2200*MIL;
PIR_Y= 700*MIL;

PCB_OVER=16;       // space needed above pcb

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
        sphere(r=WALL_TH,$fn=8);
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
A0=WALL_TH+PCB_S+PCB_W0+PCB_S+WALL_TH;
B=WALL_TH+PCB_S+PCB_H+PCB_S+WALL_TH;
B0=WALL_TH+PCB_S+PCB_DHT_YC+PCB_DHT_SPACE+WALL_TH;
D=WALL_TH+PCB_Z+PCB_T+PCB_OVER+WALL_TH;
D0=WALL_TH+PCB_Z+PCB_T+PCB_DHT_Z0;

module mainBox(){
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
                #cylinder(d=1,h=10,center=true);
        }
        translate([(50+850)*MIL,0,0])
        cylinder(d=3,h=10,center=true);
    }
}
module pirDome(){
//        cylinder(h=10,d=23,center=true);
        cylinder(h=2*WALL_TH,d1=23+WALL_TH,d2=23-0.001,center=true);
}

module dcPlug(){
    translate([-5,0,0])
    cube([10,9,11]);
}
module jackPlug(){
    translate([0,0,0.1])
    translate([-5,0,2.5])
    rotate(90,[0,1,0])
    cylinder(d=5,h=10);
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
    mainBox();
    dhtHoles();
        translate([ WALL_TH+PCB_S+PIR_X,
                    WALL_TH+PCB_S+PIR_Y,
                    WALL_TH+PCB_Z+PCB_T+PCB_OVER+WALL_TH])
        pirDome();
        translate([ WALL_TH+PCB_S,
                    WALL_TH+PCB_S+13.7-9,
                    WALL_TH+PCB_Z+PCB_T])
        dcPlug();
        translate([ WALL_TH+PCB_S,
                    WALL_TH+PCB_S+25.4-9,
                    WALL_TH+PCB_Z+PCB_T])
        dcPlug();
        translate([ WALL_TH+PCB_S,
                    WALL_TH+PCB_S+1700*MIL,
                    WALL_TH+PCB_Z+PCB_T])
        jackPlug();

    }
}


if(doProjs){
    projection(cut=true) {
        translate([3*WALL_TH,0,-WALL_TH-PCB_Z-PCB_T-PCB_DHT_Z0])
        product();
        translate([3*WALL_TH,B+3*WALL_TH,-WALL_TH-PCB_Z-PCB_T/2])
        product(true);
        translate([3*WALL_TH,-B-3*WALL_TH,-WALL_TH-PCB_Z-PCB_T-PCB_OVER-WALL_TH])
        product(true);
        rotate(-90,[0,1,0])
        product(true);
        translate([0,B+3*WALL_TH,0])
        rotate(-90,[0,1,0])
        translate([-A0,0,0])
        product(true);
    }
}else{
    product(true);
}