use <hulls.scad>

$W=1.2;


module shape(dia) {
    $fn=6;
    circle(d=dia);
}
module shapeE(dia,add=0) {
    linear_extrude(.001)
    offset($fn=90,add/4) {
        if($shape == 6) {
            circle($fn=6,d=dia);
        } else {
            D=2*dia;
            intersection() {
                    rotate(0)
                    translate([0,10,0])
                    circle(d=D);
                    rotate(120)
                    translate([0,10,0])
                    circle(d=D);
                    rotate(240)
                    translate([0,10,0])
                    circle(d=D);
            }
        }
    }
}

module shapeRealeaux(dia,add=0) {
    //https://en.wikipedia.org/wiki/Reuleaux_triangle
    fn=$fn;
    D=2*dia;
    linear_extrude(.001)
    offset($fn=90,add/4)
    intersection() {
            rotate(0)
            translate([0,10,0])
            circle(d=D);
            rotate(120)
            translate([0,10,0])
            circle(d=D);
            rotate(240)
            translate([0,10,0])
            circle(d=D);
    }
}


module  pencil_extender(L,D,close=false) {
    G=.1;
    ADD=2*$W+G;
    difference() {
        hullLine() {
            translate([0,0,L])
                shapeE(D,ADD);
            translate([0,0,ADD])
                shapeE(D,ADD);
            translate([0,0,0])
                shapeE(D-2*ADD/4,ADD);
        }
        hullLine() {
            translate([0,0,L+$W])
                shapeE(D,G);
            translate([0,0,L-2])
                shapeE(D);
            translate([0,0,L-14])
                shapeE(D-G);
            translate([0,0,L-20])
                shapeE(D-2);
        }
        if(close)
        for(a = [0:120:359]) 
            rotate(a)
        translate([0,-$W/2,L-7]) {
            cube([10,$W,10]);
        }
    }
}

module  pencil_extender0(L,D) {
    difference() {
        linear_extrude(L) {
            shape(D+2*$W);
        }
        translate([0,0,$W])
        linear_extrude(L) {
            shape(D);
        }
    }
}

mode="tri";
if(mode=="hex") {
    $shape=6;
    pencil_extender($fn=6,50,7.8);
}
if(mode=="tri") {
    $shape=3;
    pencil_extender($fn=3,50,13);
}

if(mode=="hexc") {
    pencil_extender($fn=6,50,7.5,true);
}
if(mode=="tric") {
    pencil_extender($fn=3,50,12.8,false);
}

