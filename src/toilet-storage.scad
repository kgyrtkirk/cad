use <syms.scad>


mode="preview";

$fn=(mode=="def") ? 16 : 4;   // line detail
N=16;   // number of lines
S=(mode=="def") ? 20 : 10;   // line detail
M=100;  // object scale

if(false)
linear_extrude(twist=360) {
    translate([10,0,0])
    circle();
}


// maps 0:1 to 0:1 but with more detail near 0 and 1
function s(v) = (cos(v*180+180)+1)/2;

// maps 2d points onto a "hill" alike thing;
// retains points on x/y axes
function f(v) = ([
    v[0],v[1],pow(v[0]*v[1],.5)*2
] + [ v[1]*v[0],v[1]*v[0],0]*2);


// calculates a vector in the given dir (0=x axis)
function v3r(d) = [ cos(d), sin(d), 0 ];

// maps points to a non-perpicular axis position
function g(v3,D) = 
 v3 *[ v3r(D[0]),
  v3r(D[1]),
  [ 0,0,1]
]* M;

function g1(v3,Q) = 
 v3 *[ [1,0,0],
  [0,1,0],
  [ 0,0,1]
]* M + [Q[0],Q[1],0];


module cx(a,b,D) {
    for(i=[0:1:S-1]) {
        x=s((i+0.0)/S);
        y=s((i+1.0)/S);
        hull() {
            translate(g(f(x*a+(1-x)*b),D))
            children();
            translate(g(f(y*a+(1-y)*b),D))
            children();
        }
    }
}


module dx(u0,u1,v0,v1,n,D,Q) {
    for(i=[0:n]) {
        j=(n-i);
        cx(u0*j/n+u1*i/n, v0*i/n+v1*j/n+Q,D) {
                sphere();
        }

    }
}

//dx( [0,.5,0],[0,1,0],[.5,0,0],[1,0,0],N,[60,120],[0,0]);
dx( [0,1,0],[0,1.5,0],[0,0,0],[.5,0,0],N,[0,120],[0,0,0]);

K=5;
/*
symX()
hull() {
    R=K/M;
    translate(g([0,0,0]))
        sphere();
    translate(g([R,R,0]))
        sphere();
    translate(g([1,0,0]))
        sphere();
    translate(g([1-R,R,0]))
        sphere();
}
*/