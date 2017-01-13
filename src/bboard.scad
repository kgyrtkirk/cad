
//$fn=32;

D=30;
W=260+430+22+4;//720;
H=6+20+4*260+4;//1090;
N=4;
SPACE=10;
SPACE1=12;
HOLE_R=2;
INLET=2;
DS=2;
WW=22;

// A < B

A= ( H - 2 * SPACE1 - (N-1)*DS ) / N;
B= W - 2*SPACE1 - DS - A;
B1= H - 2 * SPACE1 -2*DS - 2*B;
echo("W=",W);
echo("H=",H);
echo("A=",A);
echo("B=",B);
echo("B1=",B1);


module section(w,h){
    translate([w/2,h/2,0]) {
        cube([w-2*SPACE,h-2*SPACE,3*D],true);
        translate([0,0,D])
        cube([w,h,2*INLET],true);
    }
    translate([SPACE/2,SPACE/2,0]) {
        cylinder(h=3*D,r1=HOLE_R,r2=HOLE_R,center=true);
        translate([w-SPACE,0,0]) 
        cylinder(h=3*D,r1=HOLE_R,r2=HOLE_R,center=true);
        translate([w-SPACE,h-SPACE,0]) 
        cylinder(h=3*D,r1=HOLE_R,r2=HOLE_R,center=true);
        translate([0,h-SPACE,0]) 
        cylinder(h=3*D,r1=HOLE_R,r2=HOLE_R,center=true);
    }
};

function prefix(v,i) = (i==0 ? v[i] : v[i] + prefix(v,i-1,s));

difference(){
    cube([W,H,D]);
    // L 
    dLY=[B1,B,B];
    for(i=[0:len(dLY)-1]) {
        y=prefix(dLY,i)+SPACE1+i*DS-dLY[i];
        dy=dLY[i];
        echo(y+SPACE-WW,y+dy-SPACE-WW,"i=",i," y=",y," dy=",dy);
        translate([SPACE1,y,0])
            section(A,dy);
    }
    dRY=[A,A,A,A];
    for(i=[0:len(dRY)-1]) {
        y=prefix(dRY,i)+SPACE1+i*DS-dRY[i];
        dy=dRY[i];
        echo(y+SPACE-WW,y+dy-SPACE-WW,"i=",i," y=",y," dy=",dy);
        translate([SPACE1+A+DS,y,0])
            section(B,dy);
    }
    // trim edge
    translate([W,H,D]){
        rotate(-45,[1,0,0]){
        cube([3*W,D,5,],center=true);
        }
        rotate(-45,[0,1,0]){
        cube([5,3*W,D],center=true);
        }
    }
}
/*
module holder(){
    difference(){
        box[HSIZE
    }
}
*/


