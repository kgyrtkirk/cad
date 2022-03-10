use <threadlib/threadlib.scad>
use <syms.scad>


mode="edgeDrill2";

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

module edgeDrill() {
    
    module t(d) {
        cylinder(d=d,h=10*$W,center=true);
    }
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
            t(8);


            translate([0,L/2+i*28,$W/2])
            rotate(90,[0,1,0])
            t(D);
        }
            translate([$W/2,-W,-W])
           rotate(45,[1,0,0])
                cube([100,10,10],center=true);
//            cylinder(d=3*W,h=10*$W,center=true);
    }
    

//    nut("M12",turns=1);
}

module empty() {
}


module edgeDrill2() {
    
    module t(d) {
        cylinder(d=d,h=10*$W,center=true);
    }
    
    module holeLocs() {
        
        for(i=[-1,0,1]) {
            D=(i==0)?5:8;
            translate([$W/2,L/2+i*28,0])
            children(1);


            translate([0,L/2+i*28,$W/2])
            rotate(90,[0,1,0])
            children(i==0?0:1);
            translate([$W,L/2+i*28,$W/2])
            rotate(-90,[0,1,0])
            children(i==0?0:1);
        }
    }
    L=80;
    
    $W=18;
    W=4;
    
    
    $fn=64;
    difference() {
        translate([-W,-W,-W])
        cube([W+$W+W,L+W,$W+W]);
        cube([$W,L+W,$W+W]);
        
        holeLocs() {
            t(5);
            t(15);
        }
            translate([$W/2,-W,-W])
           rotate(45,[1,0,0])
                cube([100,W*3.5,3.5*W],center=true);
//            cylinder(d=3*W,h=10*$W,center=true);
    }
    difference() {
    holeLocs() {
        empty();
        translate([0,0,-W+.7])
        nut("M15x1.5",turns=W/1.25);
//        nut("M14x1.25",turns=W/1.25);
    }
        cube([$W,L+W,$W+W]);
    }
    

//    nut("M12",turns=1);
}

if(mode=="edgeDrill") {
    edgeDrill();
}
if(mode=="edgeDrill2") {
    edgeDrill2();
}

if(mode=="m14test") {
    intersection() {
        edgeDrill2();
        translate([-4,1,-4])
        cube(21);
    }
}
