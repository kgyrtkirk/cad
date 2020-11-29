$fn=63;
X=[(556-533)/2];//,(598-533)/2];
Y0=[39,58]+[.5,.5];
YY=[117.5,136.5,136.5+50,136.5+50+19];
D=1.5;
H=1.0;
K=3;
L=5;

SP=.4;


Y=concat(Y0,YY);

//C=[X[0]*2,Y[len(Y)-1]+Y[0],H];
C=[X[0]*2,Y[len(Y)-1]+10,H];

mode="off5";
if(mode=="main") {
    difference() {
        cube(C);
        for(x=X)
        for(y=Y) {
            translate([x,y,0])
            cylinder(d=D,h=10,center=true);
        }
    }


}
if(mode=="off5") {
    XX=[0,19,-19];
    p=[0,17,32];
    h=[for(y=p) y+17+5];
    difference() {
        union() {
        hull() {
            for(y=p)
                translate([0,y,0])
                cylinder(d=7,h=H);
            for(x=XX)
            for(y=h)
                    translate([x,y,0])
                    cylinder(d=7,h=H);
        }
            for(y=p)
                translate([0,y,0])
                cylinder(d=4.5,h=H+3);
        }
        for(x=XX)
        for(y=h) {
            translate([x,y,0])
            cylinder(d=D,h=10,center=true);
        }
    }


}

if(mode=="addon") {
    difference() {
        union() {
            hull() {
                for(y=concat(YY,Y))
                translate([0,y,0])
                cylinder(d=7,h=H);
            }
            for(y=YY) {
                translate([0,y,0])
                cylinder(d=5,h=4);
            }
        }

        for(y=Y) {
            translate([0,y,0])
            cylinder(d=D,h=10,center=true);
        }
    }
    
}
