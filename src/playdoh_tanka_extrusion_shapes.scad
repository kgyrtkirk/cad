$fn=32;

H2=23.8;
H1=19.0;
W=35.6;
PORT_SIZE=18;
A=0.3;
E=0.3;
D1=2.8-E-A;
D2=5.2-D1+2*E-A;

D3=11.3-2.3;

use <syms.scad>

function pyth(a,b)=sqrt(a*a+b*b);

module base() {
    rotate(-90,[1,0,0])
    intersection(){
        difference() {
            translate([0,D3/2,0])
            cube([W,D3,H2],center=true);
            
            for(a=[-3,0,3])
            rotate(a,[0,1,0])
            symZ([0,D1+D2/2,H2/2]){
                cube([100,D2,(H2-H1)],center=true);
            }
            symZ([0,0,H2/2]){
                cube([2,2,4],center=true);
            }
            translate([0,D3/2,0])
            rotate(90,[1,0,0])
            children();
        }
        rotate(45,[0,1,0])
        cube(pyth(W,H2)-(H2-H1)-6,center=true);
    }

}

module b1() {
    base() {
        translate([0,0,2])
        linear_extrude(height=D3,twist=0,slices=50,center=true)
        circle(d=PORT_SIZE-2);
//        square(PORT_SIZE-2,center=true);
        children();
    }
}

mode="tube";
if(mode=="b0") {
    base()
    linear_extrude(height=PORT_SIZE,twist=0,slices=50,center=true)
    square(PORT_SIZE-2,center=true);
}
if(mode=="rot3") {
    base()
    linear_extrude(height=PORT_SIZE,twist=60,slices=50,center=true)
    circle(d=PORT_SIZE-2,$fn=3);
}

module sp(i){
        D=3;
        H=3+2;
        rotate(i*60)
        translate([i==0?0:H,0,0])
        circle(d=D);
}

if(mode=="spagetti") {
    b1()
    linear_extrude(height=PORT_SIZE,twist=0,slices=50,center=true) {
        D=3;
        H=3+2;
        for(i=[0:7]) {
            rotate(i*60)
            translate([i==0?0:H,0,0])
            circle(d=D);
        }
    }
}
if(mode=="predator") {
    b1()
    linear_extrude(height=PORT_SIZE,twist=0,slices=50,center=true) {
        sp(0);
        for(i=[1:2:7]) {
            hull() { sp(i); sp(i+1);}
        }
    }
}

if(mode=="lines") {
    b1()
    linear_extrude(height=PORT_SIZE,twist=0,slices=50,center=true) {
        for(i=[1:3]) {
            hull() { sp(i); sp(7-i);}
        }
    }
}

if(mode=="star") {
    b1()
   linear_extrude(height=PORT_SIZE,twist=0,slices=50,center=true) {
        R1=(PORT_SIZE)/4;
        R2=(PORT_SIZE-2)/2;
        polygon(
            [for(a=[0:36:360]) [sin(a),cos(a)] * ((a%72)==0 ? R1:R2) ] 
            );
    }
}
if(mode=="tube") {
    base() {
        R1=(PORT_SIZE)/4-2;
        R2=(PORT_SIZE)/4;
        D=(PORT_SIZE-2);
        rotate(30)
        difference() {
            K=3;
            cylinder(d=D,center=true,h=D3+1);
            for(a=[0:120:360])
                rotate(a)
            translate([R1,0,D3/2-K/2])
            rotate(45,[1,0,0])
                cube([D/2,K,K]);
            
            difference() {
                cylinder(r=R2,center=true,h=D3+1);
                cylinder(r=R1,center=true,h=D3+1);
            }

        }
    }
}

