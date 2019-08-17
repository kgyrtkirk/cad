
S=20;

R=(S/2)/cos(360/6/2);
L=30;
W=4;

DRIVER_D=10;
DRIVER_L=30;
INC_L=5;
FINGER_DIA=20;
ARM_L=50;
ARM_W=FINGER_DIA+12;


translate([0,0,INC_L])
cylinder($fn=6,d=DRIVER_D,h=DRIVER_L);

cylinder($fn=6,r1=R+W,h=INC_L,d2=DRIVER_D);
translate([0,0,-INC_L/2]) {

    rotate(90)
    difference() {
    hull()
    for(x=[-1,1])
    translate([50*x,0,0])
    cylinder($fn=32,d=ARM_W,h=INC_L,center=true);
    for(x=[-1,1])
    translate([ARM_L*x,0,0])
    cylinder($fn=32,d=FINGER_DIA,h=INC_L*2,center=true);
    }
}
//cube([100,S,INC_L],center=true);

translate([0,0,-L/2]) {
difference() {
    cylinder($fn=6,r=R+W,h=L,center=true);
    translate([0,0,-W])
    cylinder($fn=6,r=R,h=L,center=true);
}

}