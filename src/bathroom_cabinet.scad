use <furniture.scad>

$W=18;
$part=undef;

mode="preview";

module cabinet() {
    HOLE_DIST=677;
    IKEA_HANG_Y=50/2;
    IKEA_HANG_X=35/2;
    C_W=HOLE_DIST+IKEA_HANG_X*2;
    C_H=$W+450+$W;
    C_D=300;
//    I_W=IKEA_HANG_X+300;
    I_W=C_W/2-$W/2;
    
    eYZ("A",C_D,C_H);
    translate([C_W+$W,0,0])
    eYZ("A",C_D,C_H);

    translate([$W+I_W,0,$W])
    eYZ("I",C_D,C_H-2*$W);

    translate([$W,0,C_H/2])
    eXY("P",I_W,C_D);

//   translate([$W+I_W+$W,0,C_H/2])
//   eXY("P",I_W,C_D);


    for(z=[0,C_H-$W])
    translate([$W,0,z])
    eXY("A",C_W,C_D);

    
}

posNeg() {
    cabinet();
}

