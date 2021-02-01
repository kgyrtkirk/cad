$fn=32;

H=40;

mode="block";
if(mode == "def") {
   difference() {
        cylinder(d=18,h=H,center=true);
        cylinder(d=12,h=H+1,center=true);
        for(i=[0:60:180-1]){
            rotate(i)
            hull() {
                cube([H,4,H-10],center=true);
                cube([H,.001,H-5],center=true);
            }
        }
    }
}

if(mode=="block") {
    L=40;
    S=[18,9,40];
    
    R=9;
    D1=11;
    D2=15;
    
    difference() {
        union() {
            cylinder(d=18,h=L);
            translate([-10,0,0])
            cube([20,1,L]);
        }
        translate([0,R/2,0])
        cylinder(d=D1,h=100,center=true);
        translate([0,R/2,0])
        cylinder(d=D2,h=100,center=true);
        hull() 
        for(h=[10,L-10])
        translate([0,0,h])
        rotate(45,[0,1,0])
        cube([10,100,10],center=true);
    }
    
    
    
}