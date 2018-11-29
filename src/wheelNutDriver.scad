
S=19.5;

R=(S/2)/cos(360/6/2);
L=20;
W=4;

DRIVER_D=9;
DRIVER_L=12;
INC_L=5;



cylinder($fn=6,d=DRIVER_D,h=DRIVER_L);
translate([0,0,-INC_L]){
cylinder($fn=6,r1=R+W,h=INC_L,d2=DRIVER_D);
translate([0,0,-L/2])
difference() {
    cylinder($fn=6,r=R+W,h=L,center=true);
    translate([0,0,-W])
    cylinder($fn=6,r=R,h=L,center=true);
}
}