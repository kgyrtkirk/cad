use <syms.scad>

mode="defc";
render=(mode=="def") && false;

$fn=render ? 16 : 4;   // line detail
M=100;  // object scale
N=M/(50/8)/2;   // number of lines
S=render ? 4*N : 4*N;   // line detail

W=3;

module mySphere() {
    color([1,0,0])
    sphere(d=W);
}


// maps 0:1 to 0:1 but with more detail near 0 and 1
function s(v) = (cos(v*180+180)+1)/2;

// maps 2d points onto a "hill" alike thing; also distorts y a little bit
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

//fx(2*N,2*N);




K=5;

module foot() {
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
}

//echo(g(f([0,1,0])));



//foot();


a=[ g([0,0,0]), g([1,0,0]),g([1,1,0]), g([2,1,0]) ];

// "invents" a matrix for which the given axis is the Z axis
function buildMatForZ(z) = [
    cross(z,[z[1],z[2],z[0]]),
    cross(z,cross(z,[z[1],z[2],z[0]])),
    z
];

module showPiece(p) {
    d1=p[2]-p[0];
    k=buildMatForZ(d1/norm(d1));
//    echo(k);
    multmatrix(d1)
    cube();
    
    hull() {
        translate(p[1]) mySphere();
        translate(p[2]) mySphere();
    }
}
$fn=16;

//showPiece(a);


