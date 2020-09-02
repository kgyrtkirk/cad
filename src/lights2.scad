use<syms.scad>

$fn=64;

// FIXME move to a common place
module hullLine() {
    echo($children);
    for(o = [0:$children-2])  {
        hull() {
            children(o+0);
            children(o+1);
        }
    }
}

module hullPairs(pos){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
    hull() {
        translate(pos[0]) children();
        translate(pos[len(pos)-1]) children();
    }
    
}



function p(x,y) = [x+y/2,y*sqrt(3)/2];

W=19;
WW=128;

points=[
    p(2,0),
    p(1,1),
    p(0,2),
    p(-1,2),
    p(-2,2),
    p(-2,1),
    p(-2,0),
    p(-1,-1),
    p(0,-2),
    p(1,-2),
    p(2,-2),
    p(2,-1),
]*WW;


module pp() {
    
//    for(i=[-2:2])
  //  for(j=[-2:2])
    //if(abs(i)+abs(j)>1 && abs(i+j)<3 && (i!=-j || abs(i)==2))
    
    for(p=points)
    translate(p)
    children();
}

difference() {
    union() {
        hullPairs(points)
        cylinder(d=WW,h=W);

    }
    pp()
    cylinder(d=70,center=true,h=100);
}

hullPairs(points*1.1)
cylinder(d=W,h=100);

color([0,1,0])
pp() 
cylinder(d=90,center=true,h=10);


module tap() {
    color([1,0,0])
    cube([225,19,53]);
}

translate(points[4])
translate([0,-6,2*W])
tap();