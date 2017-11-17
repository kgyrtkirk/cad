$fn=128;

W=6.0;
R=11.3/2;
L=17.5-R;
H=11.8;

D=10;
R0=4.7;
O=.2;

module m1() {
translate([0,0,-H/2]) {

    linear_extrude(H) {

        translate([-W/2,0,0])
            square([W,L]);
        translate([0,L,0])
            circle(R);
    }
}
}

module m2() {
    rotate(-90,[1,0,0])
    cylinder(h=L,d1=W,d2=W);
    translate([0,L,0])
    sphere(R);
}


module plug() {
rotate(90,[1,0,0])
for (i=[0:1:D])
    translate([0,0,-0.5+i])
cylinder(h=1.1, d1=R0+O, d2=R0-O);


}

m1();
plug();

translate([20,0,0]){
m2();
plug();

}