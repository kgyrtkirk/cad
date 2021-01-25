
//cube();

H=.6;


module showDxf(scale,fName,offNeg=0,offPos=0,hh=H) {
    linear_extrude(height = hh, center = true, convexity = 10)
    offset(-offNeg)
    offset(offPos)
    scale(scale)
    import(str("dxf/",fName,".dxf"));
}

module contour(scale,fName,c=4,gapKill=0) {
    
    difference() {
        showDxf(scale,fName,offNeg=gapKill,offPos=gapKill);
        showDxf(scale,fName,offNeg=c,offPos=0,hh=2*H);
    }
}


//linear_extrude(height = 1, center = true, convexity = 10)
//   import (file = "a1.dxf", layer = "fan_top");


mode="people3";


%cube([100,100,.1]);

if(mode=="people1") {
    showDxf(.2,mode);
}
if(mode=="people2") {
    showDxf(.2,mode);
}
if(mode=="people3") {
    contour(.4,mode);
}
if(mode=="people4") {
    showDxf(.4,mode);
}


if(mode=="tree1") {
    showDxf(.3,mode);
}
if(mode=="tree2") {
    showDxf(.3,mode);
}
if(mode=="tree3") {
    showDxf(.3,mode);
}
if(mode=="tree4") {
    showDxf(.3,mode);
}

if(mode=="house1") {
    contour(.3,mode,gapKill=.2);
}
if(mode=="house2") {
    contour(.3,mode);
}
if(mode=="house3") {
    showDxf(.3,mode);
    translate([20,35,0])
    cube([10,5,H],center=true);

    translate([55,57,0])
    cube([10,5,H],center=true);
}
if(mode=="house4") {
    showDxf(.3,mode);
}

if(mode=="car3") {
    showDxf(15.7,mode,offPos=2,offNeg=2);
    for(x=[11,100-11])
    translate([x,55,0])
    cylinder(d=8,h=H,center=true);
}
if(mode=="car4") {
    showDxf(1.5,mode);
}
if(mode=="car5") {
    showDxf(7.87,mode);

    a=10;
    for(x=[a,100-a])
    translate([x,42,0])
    cylinder(d=8,h=H,center=true);
}

if(mode=="icecream") {
    showDxf(.7,mode);
}
if(mode=="frozen1") {
    showDxf(.23,mode);
}
if(mode=="frozen2") {
    showDxf(.23,mode);
}

if(mode=="grass1") {
    showDxf(.3,mode,offPos=.1);
}
if(mode=="grass2") {
    showDxf(.15,mode);
}

if(mode=="cherry1") {
    showDxf(.1,mode,offPos=.1);
}
if(mode=="cherry2") {
    showDxf(.1,mode);
}

