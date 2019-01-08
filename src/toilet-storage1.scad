$fn=16;
N=16;   // number of lines
S=20;   // line detail
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
function g(v3) = 
 v3 *[ v3r(60),
  v3r(120),
  [ 0,0,1]
]* M;


module cx(a,b) {
    for(i=[0:1:S-1]) {
        x=s((i+0.0)/S);
        y=s((i+1.0)/S);
        hull() {
            translate(g(f(x*a+(1-x)*b)))
            sphere();
            translate(g(f(y*a+(1-y)*b)))
            sphere();
        }
    }
}


module dx(u,v,n) {
    for(i=[0:n]) {
        j=n-i;
        cx(u*i/n, v*j/n);
    }
}

dx( [1,0,0],[0,1,0],N);