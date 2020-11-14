use <furniture.scad>
use <syms.scad>


W=18;
$W=18;
M60I=564;
M60W=M60I+W;


$part=undef;
mode="preview";


module polc() {
    w=1400;
    d=270;
    s=335;
    
    b_w=300;
    b_h=50;
    
    for(z=[0:s-W:2*s])
    translate([-w/2,W,z])
    eXY(str("Qu",z),w-((z==s-W)?W:0),d);

    symX([b_w/2,0,-b_h])
    eXZ("Qback",b_w,b_h*2+2*s+W-2*W);

color([1,0,0]){
    translate([-w/2-W,W,0])
    eYZ("Qside",d,s);

    translate([w/2,W,s-W])
    eYZ("Qside",d,s);
}
}


if(mode=="preview") {
    posNeg() {
        polc();
    }
}



