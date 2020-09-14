use <syms.scad>
W=1.6;

$fn=64;

    R1=35/2;
    R2=4;
    C1=[48.8,5.6+R1,0];

    Q=[2*49,2*23,W];

//HR1=R1;
//HR2=R2;
HR1=1;
HR2=1;

module m() {
difference() {
    //translate([-W,-W,0])
    translate([0,0,-W/2])
    cube(Q,center=true);
    
//    translate([0,0,W])
  //  cube(Q);

//    translate(C1)
    cylinder(r=HR1,h=30,center=true);

        symX([R1+HR1,0,0]) {
            cylinder(r=HR1*2,h=30,center=true);
        }
        symY([0,R1+HR1,0]) {
            cylinder(r=HR1*2,h=30,center=true);
        }

    
  //  translate(C1)
    symX([45/2,9.5,0]) {
        cylinder(r=HR2,h=30,center=true);
        
        symX([R2+HR2,0,0]) {
            cylinder(r=HR2*2,h=30,center=true);
        }
        symY([0,R2+HR2,0]) {
            cylinder(r=HR2*2,h=30,center=true);
        }
    }
    
}
}

mode="mount";
if(mode=="project") {
    projection(cut=true) m();
}
if(mode=="mount") {
    p=[20,20+32];
    difference() {
        cube([20+32+20,60,2]);
        for(x=p) {
            translate([x,50,0])
            cylinder(d=2,h=30,center=true);
        }
    }
}
if(mode=="def") {
    m();
}