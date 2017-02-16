
hWidth=15;
hLen=8;
hOver=8;

module hook(){
    color("red"){
        translate([0,-hWidth/2,0]) {
            square([hLen,hWidth]);
        }
        translate([0.2,-hWidth/2-hOver,0]) {
            difference() {
                square([hLen,hWidth+hOver*2]);
                rotate(-45)
                square(hOver*2);
                translate([0,hWidth+hOver*2,0])
                rotate(-45)
                square(hOver*2);
            }
        }
    }
}

holeW=0.5;

module hole(){
    color("green"){
        difference() {
        square([hLen,hWidth+hOver*2],center=true);
        square([holeW,hWidth],center=true);
        }
    }
}


$fn=128;

b=240;
d1=25;
d2=210 / PI;
echo(d2);

// d1/a = d2/(a+b)
// d1(a+b) = d2 * a
a=b*d1 / (d2-d1);
echo(a);

z=d1 * PI /a * 180 / PI ;
echo (z);


difference() {
    circle(a+b);
    circle(a);
    rotate(90+z)
    square(a+b);
    square(a+b);
    rotate(180)
    square(a+b);
    rotate(270)
    square(a+b);
}

offs = [ b*1/6, b*2/6,b*3/6,b*4/6,b*5/6 ];

// hooks
translate([0,a,0]) {
    for ( o = offs ) {
        translate([0,o,0]) {
            hook();
        }
    }
}
    
// pockets
rotate(z)
translate([0,a,0]) {
    for ( o = offs ) {
        translate([0,o,0]) {
            hole();
        }
    }
}





