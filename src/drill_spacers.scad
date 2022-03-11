use <threadlib/threadlib.scad>
use <syms.scad>


mode="edgeDrill3";

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
    }
    difference() {
    holeLocs() {
        empty();
        translate([0,0,-W+.7])
        nut("M15x1.5",turns=W/1.25);
    }
        cube([$W,L+W,$W+W]);
    }
}


module edgeDrill3() {
    
    module t(d) {
        cylinder(d=d,h=3*W,center=true);
    }
    
    OX=.4;
    
    module holeLocs() {
        
        for(i=[-1,0,1]) {
            D=(i==0)?5:8;
            translate([$W/2,L/2+i*28,0])
            children(1);


            translate([0,L/2+i*28,$W/2+OX])
            rotate(90,[0,1,0])
            children(i==0?0:1);
            translate([$W,L/2+i*28,$W/2+OX])
            rotate(-90,[0,1,0])
            children(1);
        }
    }
    L=80;
    
    $W=18.2;
    W=10;
    CDIST=34+OX;
    CH=CDIST+15/2+W;
    
    $fn=64;
    
    module mainPart() {
        
        difference() {
            translate([-W,-W,-W])
            cube([W+$W+W,W+L+W,W+CH]);
            translate([0,-W-1,0])
            cube([$W,L+4*W,$W+W+CH]);
            
            holeLocs() {
                t(5);
                t(15);
            }
            
            translate([0,L/2,CDIST])
            rotate(90,[0,1,0])
            cylinder(d=15,h=3*$W,center=true);
            
            
            
            translate([$W/2,-W,-W]) {
                translate([0,W/2,CH])
                cube([$W+W/2,W/2,CH],center=true);
                rotate(30,[1,0,0])
                cube([100,W*2.5,5.5*W],center=true);
            }
            
            translate([$W/2,L+W,-W]) {
                translate([0,-W/2,CH])
                cube([$W+W/2,W/2,CH],center=true);
                rotate(-30,[1,0,0])
                cube([100,W*2.5,5.5*W],center=true);

            }
            
            for(y=[-W,L+W])
            translate([0,y,$W/2+OX])
    //        rotate(90,[0,1,0])
            rotate(45,[1,0,0])
            cube([100,W/3,W/3],center=true);
            
            translate([0,L/2,CH])
            rotate(45,[1,0,0])
            cube([100,W/3,W/3],center=true);
      //      cylinder(d=3,h=100,center=true);

        }
        difference() {
            holeLocs() {
                empty();
                difference() {
                    translate([0,0,-W])
                    nut("M15x1.5",turns=W/1.25);
                    translate([0,0,-15-W])
                    cube(30,center=true);
                }
            }
            cube([$W,L+W,$W+W]);
        }
    }
    
    
    intersection() {
        W0=4;
        mainPart();
        union() {
            holeLocs() {
                mirror([0,0,1])
                cylinder(h=W,d2=10,d1=25);
                mirror([0,0,1])
                cylinder(h=W,d2=18,d1=25);
            }
            translate([-W0,-W,-W0])
            cube([W0+$W+W0,W+L+W,CH+W+W]);
        }
        
    }
    
}

if(mode=="edgeDrill") {
    edgeDrill();
}
if(mode=="edgeDrill2") {
    edgeDrill2();
}
if(mode=="edgeDrill3") {
    edgeDrill3();
}
if(mode=="edgeDrill3s") {
    cube([34,18.2+5,2.5]);
}

if(mode=="m14test") {
    intersection() {
        edgeDrill2();
        translate([-4,1,-4])
        cube(21);
    }
}

module d8(H){
    difference() {
        cylinder(d=11,h=H);
        cylinder(d=8.5,h=3*H,center=true);
    }
}

// 20 
// 77.5
// 13
// 32
if(mode=="d8l1") {
    $fn=64;
    H=77.5-20-32+5;
    d8(H);
}
if(mode=="d8l2") {
    $fn=64;
    H=77.5-20-13+5;
    d8(H);
}

if(mode=="d8l3") {
    $fn=64;
    H=77.5-20-25+5;
    d8(H);
}

