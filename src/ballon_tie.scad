$fn=16;
D=3;
SEP=10;
EXT_R=15;
INT_R=5;

BALLON_R=150;
INT_Z=BALLON_R-sqrt(BALLON_R*BALLON_R-EXT_R*EXT_R);
echo(INT_Z);

function vDeg(r)=[sin(r),cos(r),0];
function pDeg(r)=[-cos(r),sin(r),0];

function fn_exterior(r)=
    EXT_R*vDeg(r)
//    +
  //  10*pow((sin(3*r)+1)/2,1/10)*vDeg(r);
    ;

function fn_interior(r) = [
    INT_R*sin(r),
    INT_R*cos(r),
    INT_Z
];


module donout() {

for(x=[0:SEP:360]) {
    p1=fn_exterior(x);
    p2=fn_exterior(x+SEP);
    q1=fn_interior(x);
    q2=fn_interior(x+SEP);
    hull() {
        translate(p1)   sphere(d=D);
        translate(p2)   sphere(d=D);
        translate(q1)   sphere(d=D);
        translate(q2)   sphere(d=D);
    }
}
}

donout();