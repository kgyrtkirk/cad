
use<syms.scad>
$W=2;


A=20;

mode="clamp";


module clamp(iw1=19,iw2=18,h=20,l=40,w=2) {
    
    a0=iw1/2;
    a1=iw2/2;
    
    b0=a0+w;
    b1=a1+w;
    
    path=[
    
            [a0,0],
            [a1,h],
            [b1,h],
            [b0,0],
            [b0,-w],
            [-b0,-w],
            [-b0,0],
            [-b1,h],
            [-a1,h],
            [-a0,0],
    
    ];
    
    translate([0,0,-l/2])
    linear_extrude(l)
    polygon(path);
    
}


module hook() {
    
    l=45;
    d=9;
    w=$W;
    k=5*w;
    
    difference() {
        union() {
            translate([l/2,0,0])
            cube([l,w,w],center=true);
            translate([l,0,0])
            cube([w,k,w],center=true);
            cylinder(h=w,d=d+2*w,center=true);
        }
        cylinder(h=2*w,d=d,center=true);
    }
    
    
    
}

//clamp();

module fullClamp() {
    w=$W;
    q0=25;
    p0=34;
    q=q0+2*(3*w);
    p=p0+2*(2*w);
    
    
    rotate(-90,[1,0,0])
    clamp(l=q);    
    difference() {
        translate([p/2,0,w/2])
        cube([p,q,w],center=true);
        symY([p0,q0/2,-w])
        cube([w*1.1,5*w,5*w]);
    }
}

if(mode=="hook"){
    hook();
}
if(mode=="clamp"){
    
    fullClamp();
    
    
}
