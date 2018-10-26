include <syms.scad>


V_C_D=3.9; // ~3.6?
V_S_D=3;

H_C_D=1.8;
H_S_D=H_C_D; // unmeasured?

H_SPACE=15;
V_SPACE=20;
DEPTH=24;    // max: 32?

SPHERE_D=100;

module cx(e,f){
    translate([0,0,-DEPTH/2])
    cube([e,.1+f,DEPTH+f],center=true);
}


Y=V_SPACE+(H_C_D+H_S_D)/2;
Y2=Y+H_SPACE/2;
X=H_SPACE/2+(V_C_D+V_S_D)/2;

module h1(e=0,f=0) {

    
    // H_CENTER
    hull()
    symX([X,0,0])
    rotate(90)
    cx(H_C_D+e,f);

    // H_TOP/BOT
    symY([0,Y,0])
    hull()
    symX([X,0,0])
    rotate(90)
    cx(H_S_D+e,f);

    // V
    hull()
    symY([0,Y2,0]) {
        cx(V_C_D+e,f);
    }

    
/* 
    symX([H_SPACE+(V_C_D+V_S_D)/2,0,0])
    hull()
    symY([0,V_SPACE+(H_C_D+H_S_D)/2,0]) {
        cube(V_C_D,center=true);
    }
    */
}


module mod0() {
    cube([X*2,Y2*2,2],center=true);
    r=SPHERE_D/2;
    SPHERE_Z=DEPTH+sqrt(r*r-Y2*Y2);
    difference() {
        h1(4,0);
        h1(0,1);
        translate([0,0,-SPHERE_Z])
        sphere(d=SPHERE_D);
    }
}


mode="preview";

if(mode == "preview" ){
    mod0();
}
if(mode == "ventPart" ){
    rotate(90,[0,1,0])
    mod0();
}