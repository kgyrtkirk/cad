include <syms.scad>

mode="1";
num=toInt(mode);
echo(num);

module t(l,t,s) {
    linear_extrude(l)
    text(str(t),valign="center",halign="center",size=s);
}

$fn=96;
module half() {

    W=1.2;
    H=W;
    s=10.0*pow(num,.03)*(.5+len(mode)/3);
    s2=10.0*pow(num,.03);

    difference() {
        cylinder(d=2*s,h=H);
        translate([0,0,H/2])
        cylinder(d=2*(s-W),h=H);
    }
    t(H,num,s2);
}

half();
rotate(180,[1,0,0])
half();