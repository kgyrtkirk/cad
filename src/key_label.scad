use<syms.scad>;
$fn=64;

module roundedCutShape(w,h,d,r) {
        hull()
        symX([(w-2*r)/2,0,0])
        symY([0,(h-2*r)/2,0])
        cylinder(r=r,h=d,center=true);
}


mode="JMF-947";
str=mode;
S=6;

W=.6;
A=len(str)*S+2*W;
B=S*1.4+4*W;
R=2;
H1=4;
H2=H1+4*W;
HP=[-A/2-H2/2+W,0,0];
difference() {
    hull() {
        translate(HP)
        cylinder(d=H2,h=2*W,center=true);
        roundedCutShape(A,B,2*W,R);
    }
    translate([0,0,W])
    roundedCutShape(A-2*W,B-2*W,2*W,R);
    translate(HP)
    cylinder(d=H1,h=3*W,center=true);
}

    color("black")
    linear_extrude(height=W)
    text(str,
        size=S,
        font=
    //"Lato:style=Black",
    //"Ataxia Outline BRK:style=Regular",
    //"Gillius ADF:style=Bold",
    "Georgia:style=Bold",
    //"GFS Didot:style=Bold",
    //"Bitstream Vera Sans:style=Bold",
        halign="center",valign="center");

