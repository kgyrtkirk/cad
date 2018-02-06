
W1=13;
W2=11.5;

L=30;
R=1;

$fn=32;
rotate(90,[R,0,0]) 
cylinder(d=R,h=W1,center=true);

hull(){
translate([0,(W2-R)/2,0])
sphere(d=R);
translate([0,-(W2-R)/2,0])
sphere(d=R);
translate([L,W2,0])
sphere(d=R);
}