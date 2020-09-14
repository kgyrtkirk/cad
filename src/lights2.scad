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
WW=150;

DLAMP=70;

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

module mainPart() {
    difference() {
        union() {
//            hullPairs(points)
  //          cylinder(d=WW*2/sqrt(3),h=W,$fn=6);
//            cylinder(d=WW,h=W,$fn=32);
            
            linear_extrude(height=W)
            polygon(points*2.5/2);
        }

            linear_extrude(height=3*W,center=true)
            polygon(points*1.5/2);

        pp()
        cylinder(d=DLAMP,center=true,h=100);
    }
}

module beams() {
    gamma=(2*WW+DLAMP/2+W/2)/(2*WW);
    echo("gamma",2*WW*gamma);
    hullPairs(points*gamma)
    cylinder(d=W,h=100);

    color([0,1,0])
    pp() 
    cylinder(d=90,center=true,h=10);
}


module tap() {
    kinai=false;
    if(kinai) {
        color([1,0,0])
        cube([225,19,53]);
    }else{
        //meanwell lpv-35-12
        color([1,0,0])
        cube(        [148,40,30]);
    }
}

module extra() {
translate(points[4])
translate([0,-6,2*W])
tap();

}

mode="preview";

module osszehuzo() {
//    https://www.shop.butoralkatreszbolt.hu/egyeb/135-lap-osszehuzo-vasalat-10013302100.html
    B=31;
    WW=10;
    H=27;
        symY([0,B,0])
    cylinder(d=32,h=H);
    hull()
    symY([0,B,0])
    cylinder(d=WW,h=H);

}

if(mode=="preview") {
    difference() {
    mainPart();
        translate([1.5*WW+15,0,0])
%        osszehuzo();
        }
    beams();
    extra();
}

if(mode=="main") {
    projection()
    mainPart();
}

total_w=5*WW;

echo("total_w",total_w);
echo("total_w",total_w);




