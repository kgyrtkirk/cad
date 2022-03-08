use <syms.scad>

mode="7000";
D=toInt(mode)/1000.0;


echo(D);

B=20;

a=B;
b=B+B*((D+2)%3);
cube([a,b,D]);