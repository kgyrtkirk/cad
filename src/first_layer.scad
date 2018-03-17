W=2;
H=1;

$fn=32;
module ring(d){

difference() {    
    cylinder(h=H,d=d+W);
    cylinder(h=22,d=d,center=true);
}
}
   ring(70);
for(i=[1:12]) {
    rotate(i*30,[0,0,1])
    translate([20,0,(i%3)*H])
    ring(13*i %10 + 0);
}