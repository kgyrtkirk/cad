$fn=32;

PCB_BELOW=2;
PCB_T=1.6;      // pcb thickness
PCB_S=2-PCB_T;  // spacing between pcb/wall
PCB_Z=2;        // spacing between pcb/botton
PCB_OVER=16.555;
WALL_TH=1.6;

MIL=25.4/1000;
PCB_W=4400 * MIL;
PCB_W0=3400 * MIL;
PCB_H=2000 * MIL;
PCB_HB_X=1200 * MIL;
PCB_HB_Y=450 * MIL;
PCB_HA_X=850 * MIL;
PCB_HA_Y=500 * MIL;

PCB_OVER=16;       // space needed above pcb


module holeCutter(w) {
	translate([0,0,-5])
	cylinder(d1=w,d2=w,h=10);
}

module atPcbMountHolePositions() {
translate([PCB_HA_X,PCB_HA_Y,0])
	children();
translate([PCB_W-PCB_HA_X,PCB_HA_Y,0])
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

// chamfered on the XZ plane
module cube1(a){
     XM=a[0]+a[1]+a[2];
    DEPTH=WALL_TH/2;
    difference(){
        cube([a[0],a[1],a[2]]);
    
        rotate(45,[0,1,0]){
            cube([sqrt(2)*DEPTH,3*a[1],sqrt(2)*DEPTH],center=true);
        }
        translate([a[0],0,0])
        rotate(45,[0,1,0]){
            cube([sqrt(2)*DEPTH,3*a[1],sqrt(2)*DEPTH],center=true);
        }
        translate([a[0],0,a[2]])
        rotate(45,[0,1,0]){
            cube([sqrt(2)*DEPTH,3*a[1],sqrt(2)*DEPTH],center=true);
        }
        translate([0,0,a[2]])
        rotate(45,[0,1,0]){
            cube([sqrt(2)*DEPTH,3*a[1],sqrt(2)*DEPTH],center=true);
        }
        translate([0,DEPTH,0]) {
            rotate(-135,[0,0,1])
                    translate([0,0,-1])
                    cube(XM,XM,XM);
            translate([a[0],0,0])
            rotate(-135,[0,0,1])
                    translate([0,0,-1])
                    cube(XM,XM,XM);
            rotate(90,[0,1,0]){
            rotate(-135,[0,0,1])
                    translate([0,0,-1])
                    cube(XM,XM,XM);
            translate([-a[2],0,0])
            rotate(-135,[0,0,1])
                    translate([0,0,-1])
                    cube(XM,XM,XM);
            }
        }
        translate([a[0]/2,0,a[2]/2])
            rotate(90,[1,0,0])
            text("FRONT",size=min(a[0],a[2])/5,halign="center",valign="center");

    }
}

//projection(cut=true)
//translate([0,0,-PCB_Z-PCB_T])
{
//pcb();

A=WALL_TH+PCB_S+PCB_W+PCB_S+WALL_TH;
A0=WALL_TH+PCB_S+PCB_W0+PCB_S+WALL_TH;
B=WALL_TH+PCB_S+PCB_H+PCB_S+WALL_TH;
B0=WALL_TH+PCB_S+PCB_H/3+WALL_TH;
D=WALL_TH+PCB_Z+PCB_T+PCB_OVER+WALL_TH;
D0=WALL_TH+PCB_Z+PCB_T+PCB_OVER/2+WALL_TH;
echo(D);
    translate([0,B,0])
    rotate(90,[1,0,0])
        cube1([A,WALL_TH,B]);
color([.7,.1,0]) {
    cube1([A0,WALL_TH,D]);
    translate([A0-2*WALL_TH,0,0])
    cube1([A-A0+2*WALL_TH,WALL_TH,D0]);
    translate([A,0,0])
    rotate(90,[0,0,1])  cube1([B,WALL_TH,D0]);
    translate([A,B,0])
    rotate(180,[0,0,1])  cube1([A-A0+WALL_TH*2,WALL_TH,D0]);
    translate([A0,B,0])
    rotate(180,[0,0,1])  cube1([A0,WALL_TH,D]);
    translate([0,B,0])
    rotate(270,[0,0,1])  cube1([B,WALL_TH,D]);
//    translate([A0-WALL_TH,0,D0])
  //  rotate(-90,[1,0,0])
    //    cube1([A-A0+WALL_TH,WALL_TH,B0]);
    
    translate([A,B,D0])
    rotate(180,[0,0,1])
    rotate(-90,[1,0,0])
        cube1([A-A0+WALL_TH,WALL_TH,B0]);
    
    translate([A0,0,D0-WALL_TH]) {
        translate([-WALL_TH,0,WALL_TH])
        rotate(-90,[1,0,0])
            cube1([A-A0+WALL_TH,WALL_TH,B0]);
    rotate(90,[0,0,1])  {
        cube1([B0,WALL_TH,D-D0+WALL_TH]);
        translate([B-B0,0,0]) 
        cube1([B0,WALL_TH,D-D0+WALL_TH]);
    }
        translate([-WALL_TH,B0-WALL_TH,0])
                cube1([A-A0+WALL_TH,WALL_TH,D-D0+WALL_TH]);

        translate([A-A0,B-B0,0])
        translate([0,WALL_TH,0])
    rotate(180,[0,0,1])
                cube1([A-A0+WALL_TH,WALL_TH,D-D0+WALL_TH]);
    }
        translate([A,B0-WALL_TH,D0-WALL_TH*2])
rotate(90,[0,0,1])                 cube1([B-2*B0+2*WALL_TH,WALL_TH,D-D0+2*WALL_TH]);
    
        translate([A0-2*WALL_TH,B0-WALL_TH,D])
rotate(-90,[1,0,0])
            cube1([A-A0+2*WALL_TH,WALL_TH,B-2*B0+2*WALL_TH]);
        translate([0,0,D])
rotate(-90,[1,0,0])
            cube1([A0,WALL_TH,B]);

}

translate([WALL_TH+PCB_S,WALL_TH+PCB_S,WALL_TH+PCB_Z])
    pcb();
}


