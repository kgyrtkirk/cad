use <syms.scad>


mode="edgeDrill";

if(mode=="edge") {
    
    H=50;
    A=11;
    B1=18;
    B2=30;
    W=4;
    
    
    translate([-W,-B2/2,0])
    cube([W,B2,H]);

    translate([0,-B1/2,0])
    cube([A,B1,H]);
}


if(mode=="ruler9") {
    L=100;
    D=9;
    W=2;
    O=4;
    cube([W+D,L,W]);
    cube([W,L,W+O]);
}


if(mode=="10to5") {
    
    $fn=64;
    h1=5;
    h2=20;
    difference() {
        union() {
            cylinder(d=14,h=h1);
            cylinder(d=10,h=h1+h2);
        }
        cylinder(d=5.5,h=(h1+h2)*3,center=true);
    }
}

if(mode=="edgeDrill") {
    
    L=80;
    
    $W=18;
    W=2.4;
    
    
    $fn=64;
    difference() {
        translate([-W,-W,-W])
        cube([W+$W+W,L+W,$W+W]);
        cube([$W,L+W,$W+W]);
        for(i=[-1,0,1]) {
            D=(i==0)?5:8;
            translate([$W/2,L/2+i*28,0])
            cylinder(d=8,h=$W,center=true);

            translate([0,L/2+i*28,$W/2])
            rotate(90,[0,1,0])
            cylinder(d=D,h=10*$W,center=true);
        }
            translate([$W/2,-W,-W])
           rotate(45,[1,0,0])
                cube([100,10,10],center=true);
//            cylinder(d=3*W,h=10*$W,center=true);
            
        
        
    }
}
