$fn=16;
D=3;
SEP=10;
EXT_R=15;
INT_R=5;

BALLON_R=150;
INT_Z=BALLON_R-sqrt(BALLON_R*BALLON_R-EXT_R*EXT_R);
echo(INT_Z);

function vDeg(r)=[sin(r),cos(r),0];

function fn_circle(R,deg)=
    R*vDeg(deg)
    ;


module donout(R1,R2,Z1=0) {

for(x=[0:SEP:360]) {
    p1=fn_circle(R1,x);
    p2=fn_circle(R1,x+SEP);
    q1=fn_circle(R2,x);
    q2=fn_circle(R2,x+SEP);
    hull() {
        translate(p1+[0,0,Z1])   sphere(d=D);
        translate(p2+[0,0,Z1])   sphere(d=D);
        translate(q1)   sphere(d=D);
        translate(q2)   sphere(d=D);
    }
}
}

intersection() {

donout(INT_R,EXT_R);
for(d=[0:120:360]){
    translate(fn_circle(EXT_R+INT_R/2,d))
    donout(INT_R,EXT_R+INT_R);
}
}