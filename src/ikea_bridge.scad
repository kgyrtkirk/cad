use <syms.scad>

$fn=32;

module roundedCutShape(w,h,d,r) {
        hull()
        symX([(w-2*r)/2,0,0])
        symY([0,(h-2*r)/2,0])
        cylinder(r=r,h=d,center=true);
}



TH=1; //thickness

R=5;

W0=564;
W1=596;
H1=15;
H0=H1+2*8;

H_D=582.5;

//H_D=6;
V_X=5;
V_Y=10;

module main() {
    difference() {
        union() {
            roundedCutShape(W1,H1,TH,R);
            roundedCutShape(W0,H0,TH,R);
        }
        symX([H_D/2,0,0]) {
            cylinder(d=V_X,h=10,center=true);
        }
        
        U=H_D/4;
        for(x=[0,U])
        symX([x,0,0]) {
            hull()
            symY([0,H1/2-V_X,0])
            cylinder(d=V_X,h=10,center=true);
        }
    }
}

projection()
main();