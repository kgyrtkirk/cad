use<syms.scad>

$fn=64;

U=79;
V=79;
H=1.2;

Q=(79-64)/2;
D=2;

difference() {
    hull()
    symX([U/2,0,0])
    symY([0,V/2,0])
    cylinder(d=5,h=H);

    symX([64/2,0,0])
    symY([0,64/2,0])
    cylinder(d=D,h=30,center=true);
    
    translate([-79/2+92-39.5,0,0])
    cylinder(d=D,h=30,center=true);

    symX([U/2,0,0])
    cylinder(d=40,h=30,center=true);

    symY([0,U/2,0])
    cylinder(d=40,h=30,center=true);
    
}
