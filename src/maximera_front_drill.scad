$fn=63;
X=[(556-533)/2,(598-533)/2];
Y=[39,58]+[.5,.5];
D=1.5;
H=1.3;
K=3;
L=5;

SP=.4;

C=[43,70,L];


mode="main";
if(mode=="main") {
    difference() {
        translate([-K,-K,-H])
        cube(C);
        translate([-SP,-SP,0])
        cube(C);
        for(x=X)
        for(y=Y) {
            translate([x,y,0])
            cylinder(d=D,h=10,center=true);
        }
    }


}

if(mode=="addon") {
        YY=[117,136];
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
