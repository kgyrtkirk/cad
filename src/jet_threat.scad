
W1=13;
W2=11.5;

L=30;
R1=1.5;
R2=2.5;
RD=2;

$fn=32;
rotate(90,[R1,0,0]) 
cylinder(d=R1,h=W1,center=true);

difference() {
hull(){
translate([0,(W2-R2)/2,0])
sphere(d=R2);
translate([0,-(W2-R2)/2,0])
sphere(d=R2);
translate([L,W2,0])
sphere(d=R2);
}

for(i=[ .1:.1:.6])
translate(i*[L,W2,0])
cylinder(d=RD*(1-i),h=W1,center=true);



}