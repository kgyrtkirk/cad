$fn=64;

L=60;
I=2;
Z0=0;
W=2.0;
SPX=-W/2;
Z1=14+SPX;
Z2=18+SPX;
K=10;

FADE=15;

F=Z2+FADE;

CLAMP_W1=0;
CLAMP_W2=10;

HEIGHT=15;


module aux() {
    translate([-CLAMP_W2,Z2-W,0])
    cube([CLAMP_W2/2,1,HEIGHT]);
}

//(false)
mode="main";
if(mode=="aux") {
    rotate(90,[1,0,0])
    aux();
}
if(mode == "main")
difference() {
linear_extrude(HEIGHT)
polygon([
    [-I-CLAMP_W1,-W],
    [0,-W],
    [0,-L], [W,-L],
    [W,Z2+FADE],
    [-I-CLAMP_W2,Z2+2*W],
    [-I-CLAMP_W2,Z2],
    [-I-CLAMP_W2+W,Z2],
    [-I-CLAMP_W2+W,Z2+W],
    [-I,Z2+FADE/2],
    [-I,Z1],
    [-I,Z0],
    [-I-CLAMP_W1,Z0],
]);

    translate([0,-L+HEIGHT/2,HEIGHT/2])
    rotate(90,[0,1,0]) {
        cylinder(d=3.4,h=20,center=true);
        translate([0,0,W*2/3])
        cylinder($fn=6.2,d=6,h=20);
    }


}

S=50;
{
%        aux();
%translate([-S/2-I-.5,0,0])
rotate(-90,[1,0,0])
rotate(45){
    
    cylinder($fn=4,h=Z1,d=S*sqrt(2));
    translate([0,0,Z1])
    cylinder($fn=4,h=Z2-Z1,d1=S*sqrt(2),d2=(S-2*K)*sqrt(2));
}
}