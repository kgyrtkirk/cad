$W=1.2;


module shape(dia) {
    $fn=6;
    circle(d=dia);
}

D=7.5;
L=50;
difference() {
    linear_extrude(L) {
        shape(D+2*$W);
    }
    translate([0,0,$W])
    linear_extrude(L) {
        shape(D);
    }
    
}