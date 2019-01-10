use <syms.scad>

render=true;


eps=1e-4;
$fn=render ? 16 : 4;   // line detail
M=50;  // object scale
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

// final changes to points
function g(v3) =  v3 * M;

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

function unit(v) = norm(v)>0 ? v/norm(v) : undef; 

function transpose(m) = // m is any rectangular matrix of objects
  [ for(j=[0:len(m[0])-1]) [ for(i=[0:len(m)-1]) m[i][j] ] ];

function m33tom44(m,p=[0,0,0]) = [
    concat(m[0], p[0]),
    concat(m[1], p[1]),
    concat(m[2], p[2]),
    [0,0,0,1],
];
// "invents" a matrix for which the given axis is the Z axis
function buildMatForZ(z,x) = [
    unit(cross(z,cross(z,x))),
    unit(cross(z,x)),
    unit(z)
];


function computePointMatrix(z,x,t) =
    m33tom44(transpose(buildMatForZ(z,x)),t);

// 4 point cylinder line
  
module cylPiece(p,diameter=W) {
    module pieceNode(p0,p1,p2) {
        s=(unit(p2-p1) * unit(p2-p0));
        if(p0 == undef || p2 == undef /*|| abs(s)<0.5*/) {
            translate(p1)
                sphere(d=diameter);
        }else{
//            echo(s);
            m=(s>.97)   ? computePointMatrix(p2-p0,[1,1,0],p1)
                        : computePointMatrix(p2-p0,p1-p0,p1);
                
            multmatrix(m)
                scale([1/s,1,1])
                cylinder(h=eps,d1=diameter,d2=0);
        }
    }
    hull() {
        pieceNode(p[0],p[1],p[2]);
        pieceNode(p[1],p[2],p[3]);
    }
}

function interpol(x,a,b) =  x*a+(1-x)*b;

function cx2(a,b) = [
    for(i=[0:1:S])  g(f(interpol( s(i/S), a, b)))
];

function quads(arr) = [
    for(i=[-1:len(arr)-3])
            [ for(j=[0:3]) arr[i+j] ]
    ];

module fx2(n,m,om=0,dia) {
    u00=[-1,0,0];
    u01=[1,0,0];
    v00=[0,0,0];
    v01=[0,1,0];

    uOff=om*(u01-u00) / (n+2);
    vOff=om*(v01-v00) / (m+1);
    u0=u00+uOff;
    u1=u01-uOff;
    v0=v00+vOff;
    v1=v01;
    
    dN=(om==0)?0:1;
    
    l=[
        for(i=[dN:n-dN]) 
            quads(cx2(interpol(i/n,u0,u1)+v0,interpol(i/n,u0,u1)+v1)),
        for(i=[0:m-dN]) 
            quads(cx2(interpol(i/m,v0,v1)+u0,interpol(i/m,v0,v1)+u1)),
    ];
    for(a = l){ for(x = a){ cylPiece(x,dia); }}
}

//hull()

//fx2(2*N,2*N);
module r(d=W) {
    color([0,1,0])
    fx2(2*N-2,2*N-1,1,d);
}
module m() {
    fx2(2*N,2*N,0,W);
}

module basePart() {
    difference() {
        m();
        r(W+.4);
    }
}

module lidPart() {
    rotate(-12,[1,0,0])
    r();
}

mode="preview";
if(mode=="preview") {
    basePart();
    
}
if(mode=="base") {
    basePart();
}
if(mode=="lid") {
    lidPart();
}
