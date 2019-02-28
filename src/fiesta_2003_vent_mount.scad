include <syms.scad>

render=false;
$fn=render ? 64 : 16;

W=1.6;
EE=.1;
V_C_D=3.9-EE; // ~3.6?
V_S_D=3-EE;

H_C_D=1.8-EE;
H_S_D=H_C_D; // unmeasured?

H_SPACE=15;
V_SPACE=20;
DEPTH=30;    // max: 32?

SPHERE_D=100;

Y=V_SPACE+(H_C_D+H_S_D)/2;
Y2=Y/2+H_SPACE/2;
X=H_SPACE/2+(V_C_D+V_S_D)/2;

SP=.2;
SP3=[SP,SP,SP];
SLOT=[X*2+2*W,Y2*2+2*W,W];

PHONE=[76,151,8.6]+ [1,1,1];


module roundedBlock(dim=[10,10,2],zPos=0) {
    hull()
    symXY([dim[0]/2,dim[1]/2,zPos]){
        sphere(d=dim[2]);
    }
}


module cx(e,f){
    translate([0,0,-DEPTH/2])
    cube([e,.1+f,DEPTH+f],center=true);
}


module h1(e=0,f=0) {

    
/*    // H_CENTER
    hull()
    symX([X,0,0])
    rotate(90)
    cx(H_C_D+e,f);
*/
    // H_TOP/BOT
    symY([0,Y/2,0])
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



module mod0(multipart=true) {
    if(multipart) {
        cube(SLOT,center=true);
    }
    r=SPHERE_D/2;
    SPHERE_Z=DEPTH+sqrt(r*r-Y2*Y2);
    difference() {
        union() {
            h1(W*4,0);
            symX([X-W,0,-DEPTH/2])
            cube([2*W,Y2*2,DEPTH],center=true);
//            symY([0,Y/2,-DEPTH])
  //          cylinder(d1=H_SPACE,d2=2*Y2,h=DEPTH);
        }
        h1(0,1);
//        translate([0,0,-SPHERE_Z])
  //      sphere($fn=64,d=SPHERE_D);
    }
}

function const3(val)=[val,val,val];

module holderPart0(multipart=true) {
    H_ADJ=W;
    difference() {
        union() {
            translate([0,0,PHONE[2]/2+W/2+H_ADJ])
            roundedBlock(PHONE+[-W*4,-W*4,2*W]);
//            cube(PHONE,center=true);
            if(multipart)
            translate([0,W,0])
            cube(SLOT+[2*W,0,2*W],center=true);
        }
        translate([0,0,-SLOT[2]/2]){
            color([1,0,0])
            cube(SLOT+2*SP3,center=true);
            color([0,1,0])
            translate([0,0,-W])
            cube(SLOT-[W,W,0],center=true);
        }
        
            translate([0,0,PHONE[2]/2+W+H_ADJ])
            roundedBlock(PHONE-[PHONE[2],PHONE[2],-.1]);
            translate([0,0,PHONE[2]/2+W+W+W+W+W+H_ADJ])
            roundedBlock(PHONE-[PHONE[2],PHONE[2],0]*2);
    }
}


module holderPart(multipart=true) {
    module d1(X0Y0,C0) {
                    hull() {
                        D=DEPTH*3;
                        $fn=16;
                        translate(X0Y0) 
                        cylinder(d=10,h=D,center=true);
                        translate(C0) 
                        cylinder(d=10,h=D,center=true);
                    }
    }

    intersection() {
        union() {
            holderPart0(multipart);
            if(!multipart) {
                translate([0,0,W+SP])
                mod0(multipart);
            }
        }
        
        union() {
        translate([0,0,SLOT[2]])
            symX([0,0,0]) {
                C0=[0,SLOT[1]*.4,0];
                X0Y0=[PHONE[0]/2,-PHONE[1]/2,0];
                X1Y0=[PHONE[0]/2*3/4,-PHONE[1]/2,0];
                X0Y1=[PHONE[0]/2,-PHONE[1]/4,0];
                X0Y2=[PHONE[0]/2,PHONE[1]/2/2*0,0];
//                d1(X0Y0,C0);
                d1(X1Y0,C0);
//                d1(X0Y1,C0);
                d1(X0Y2,C0);
            }
        }
    }
}

mode="allinone";

if(mode == "preview" ){
    holderPart();
    translate([0,0,-10])
    mod0();
}
if(mode == "ventPart" ){
    rotate(90,[0,1,0])
    mod0();
}


if(mode == "allinone" ){
    holderPart(false);
}
