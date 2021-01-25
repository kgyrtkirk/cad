use <syms.scad>
W=1.6;

$fn=32;

A=40;
B=60;
C=3.5;//1.8;


K=8;
Q=1;

TP=5;

module profile() {
    

difference() {
    

    offset(W)
    square([A,W+C+Q/2]);

    translate([Q,0])
    square([A-2*Q,A]);

    hull() {
    translate([0,W])
    square([A,C]);
    translate([Q,W+C+Q])
    square([A-2*Q,.1]);
    }
    
}

}

mode="simple";
if(mode=="fancy") {
linear_extrude(B)
profile();
}


Z=1.5+W;

hole_pos=[ [A/2+Z,0],-[A/2+Z,0] ];



if(mode=="simple") {

        difference() {
            minkowski() {
                union() {
                    linear_extrude(height=C)
    //                offset(W)   
                        translate([0,TP/2])
                    square([A,B+TP],center=true);
                    
                    for(p=hole_pos) {
                        translate(p)
                        cylinder($fn=8,d=K,h=C);
                    }
                }
              sphere(W,$fn=8);
                
            }
            linear_extrude(height=100,center=true)
            offset(-Q)
            square([A,B],center=true);

            linear_extrude(height=2*C,center=true)
            square([A,B],center=true);


            for(p=hole_pos) {
                translate(p) {
                    cylinder(d=3.6,h=100,center=true);
                    translate([0,0,C+W-2.1])
                    cylinder(d=6.05,h=100);
                }
            }

            
            translate([-100,-100,-200])
            cube(200);
//                square([A,B]);
            
            
            
        }
}