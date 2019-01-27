H2=23.8;
H1=19.0;
W=35.6;
PORT_SIZE=18;
E=0.2;
D1=2.8-E;
D2=5.2-D1+2*E;

D3=11.3-2.3;

use <syms.scad>

function pyth(a,b)=sqrt(a*a+b*b);

module base() {
    rotate(-90,[1,0,0])
    intersection(){
        difference() {
            translate([0,D3/2,0])
            cube([W,D3,H2],center=true);
            
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


base()
linear_extrude(height=PORT_SIZE,twist=0,slices=50,center=true)
square(PORT_SIZE-2,center=true);
