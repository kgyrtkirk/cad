
H=5;
B=10;//12.2 real;
A=11.3-1.9; // real depth

Q=1;
A0=A-Q;
A1=A+Q;

C=1.7; // wall width

W=2;

D_A=(A1-A0)/2;

module p() {
    cylinder($fn=32,h=H,d=W,center=true);
}

module hullLine() {
    for(o = [0:$children-2])  {
        hull() {
            children(o+0);
            children(o+1);
        }
    }
}

hullLine() {
    R=[W/2,0,0];
    L=-R;
    
    translate(R)
        translate([0,0,0])  p();
    translate(R)
        translate([D_A+0,B,0])  p();
    translate(L)
        translate([D_A+A0,B,0])  p();
    translate(L)
        translate([A1,0,0])  p();
    translate(R)
        translate([A1+C,0,0])  p();
    translate(R)
        translate([A1+C,B/2,0])  p();
}