use <syms.scad>


mode="defc";
render=(mode=="def") && false;

$fn=render ? 16 : 4;   // line detail
M=100;  // object scale
N=M/(50/8)/2;   // number of lines
S=render ? 4*N : 4*N;   // line detail

W=3;

if(false)
linear_extrude(twist=360) {
    translate([10,0,0])
    circle();
}

module mySphere() {
    color([1,0,0])
    sphere(d=W);
}


// maps 0:1 to 0:1 but with more detail near 0 and 1
function s(v) = (cos(v*180+180)+1)/2;

// maps 2d points onto a "hill" alike thing;
// retains points on x/y axes
function f0(v) = ([
    v[0],v[1],pow(v[0]*v[1],.5)*2
] + [ v[1]*v[0],v[1]*v[0],0]*2);

function f1(v) = [v[0],v[1],0];

function f(v) = ([
    v[0],v[1]+pow((1-v[0]*v[0])*v[1],1),
    pow((1-v[0]*v[0])*v[1],.25)
] );


// calculates a vector in the given dir (0=x axis)
function v3r(d) = [ cos(d), sin(d), 0 ];

// maps points to a non-perpicular axis position
function g(v3) = 
 v3 *[ v3r(0),
  v3r(90),
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

module cx2(a,b,D) {
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
                mySphere();
        }

    }
}

module fx(n,m) {
    u0=[-1,0,0];
    u1=[1,0,0];
    v0=[0,0,0];
    v1=[0,1,0];

    for(i=[0:n]) {
        j=(n-i);
        z=u0*i/n+u1*j/n;
        cx(z+v0,z+v1,[0,90]) {
                mySphere();
        }
    }
    
    for(i=[0:m]) {
        j=(m-i);
        z=v0*i/m+v1*j/m;
        cx(z+u0,z+u1,[0,90]) {
                mySphere();
        }
    }
    
}

//symX()
//dx( [-1,0,0],[-1,1,0],[-1,0,0],[1,0,0],N,[0,90],[0,0]);
//dx( [-1,0,0],[-1,1,0],[1,0,0],[1,1,0],N,[0,90],[0,0]);
//dx( [0,1,0],[0,1.5,0],[0,0,0],[.5,0,0],N,[0,120],[0,0,0]);

fx(2*N,2*N);

K=5;

hull() {
    R=K/M;
    translate(g([-1,0,0]))
        mySphere();
    translate(g([-1,R,0]))
        mySphere();
    translate(g([1,0,0]))
        mySphere();
    translate(g([1,R,0]))
        mySphere();
}

symX()
hull() {
    R=K/M;
    translate(g([-1,1,0]))
        mySphere();
    translate(g([-1,0,0]))
        mySphere();
    translate(g([-1+R,1,0]))
        mySphere();
    translate(g([-1+R,0,0]))
        mySphere();
}

echo(g(f([0,1,0])));


