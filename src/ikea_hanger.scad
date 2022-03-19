$fn=63;
X=[16.5,26.5];
Y=[12, 44];
D=1.5;
H=5;
K=3;
L=5;

SP=.4;


//Y=concat(Y0,YY);

//C=[X[0]*2,Y[len(Y)-1]+Y[0],H];
C=[X[0]+X[1],Y[1]+Y[0],H];
W=18;

//mode="cover";
mode="main";
if(mode=="main") {
    difference() {
        union() {
//            cube(C);
//            translate([0,-W,0])
            cube([C[0],C[1]+W+2,C[2]+4]);
        }
        translate([-1,-1,H])
        cube([C[0]+2,C[1]+W+1,C[2]+4]);
        for(x=X)
        for(y=Y) {
            translate([x,y,0])
            cylinder(d=5,h=100,center=true);
        }
    }
}

if(mode=="cover") {
    
    H1=9.5;
    H2=35;
    
    
    cube([35,52.5,]);
    
}


if(mode=="step") {
    
    c=[X[1]+X[0],Y[0]+Y[1]]/2;
    dx=6.5;
    dy=9;
    
    difference() {
        union() {
//            cube(C);
//            translate([0,-W,0])
            translate(c)
            cube([X[1]-X[0]+2*dx,Y[1]-Y[0]+2*dy,10],center=true);
        }

        for(x=X)
        for(y=Y) {
            translate([x,y,0])
            cylinder(d=6.5,h=100,center=true);
        }
    }
}

if(mode=="diff_marker") {
    L=150;
    difference() {
        translate([-H,0,-H])
        cube([W,L,3*H]);

        translate([0,-H,0])
        cube([W,2*L,10*H]);
        
        for(y=[25,50,75,100,125])
            translate([W/2,y,0])
            cylinder(d=3,h=20,center=true);
    }
}

