use <syms.scad>

mode="7000";
D=toInt(mode)/1000.0;


echo(D);

O=D/10;
R1=12/2+O;
R2=30/2-O;


difference() {
    $fn=128;
    cylinder(D,R2,R2,center=true);
    cylinder(D+1,R1,R1,center=true);
}