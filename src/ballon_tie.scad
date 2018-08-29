$fn=16;
D=1.5;
SEP=3;
EXT_R=15;
INT_R=5;

BALLON_R=150;
//INT_Z=BALLON_R-sqrt(BALLON_R*BALLON_R-EXT_R*EXT_R);
INT_Z=5;
echo(INT_Z);

function vDeg(r)=[sin(r),cos(r),0];
function pDeg(r)=[-cos(r),sin(r),0];

function fn_exterior(r)=
    EXT_R*vDeg(r)
    -
    (EXT_R-INT_R)*pow((sin(3*r)+1)/2,30)*vDeg(r);
    ;


function fn_interior(r) = [
    INT_R*sin(r),
    INT_R*cos(r),
    0
];


function zoff(v) = -norm(v)*INT_Z/EXT_R*[0,0,1];
    
    
module donout() {

for(x=[0:SEP:360]) {
    p1=fn_exterior(x);
    p2=fn_exterior(x+SEP);
    q1=fn_interior(x);
    q2=fn_interior(x+SEP);
    hull() {
        translate(p1+zoff(p1))   sphere(d=D);
        translate(p2+zoff(p2))   sphere(d=D);
        translate(q1+zoff(q1))   sphere(d=D);
        translate(q2+zoff(q2))   sphere(d=D);
    }
}
}

donout();