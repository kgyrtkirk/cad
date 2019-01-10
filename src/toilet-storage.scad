use <syms.scad>

render=false;


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



function cx2(a,b) = [
    
];


module cx(a,b) {
    for(i=[0:1:S-1]) {
        x=s((i+0.0)/S);
        y=s((i+1.0)/S);
        hull() {
            translate(g(f(x*a+(1-x)*b)))
            children();
            translate(g(f(y*a+(1-y)*b)))
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


a=[
        [ g([0,.4,0]), g([1,0,0]),g([1,1,0]), g([2,1,0]) ],
        [ undef, g([0.9,0,0]),g([.1,1,0]), g([.2,1,0]) ],
    ];

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

SW=.55;
module supportPiece(p) {
    t=[0,M,0];
    g=p[1]-t;
    r=g[2]/norm(g);
    a=acos(r);
    if(a<60) {
            color([1,0,0])
        hull() {
            translate([0,0,-W])
            cylPiece(p,W);
            translate(6/g[2]*(t-p[1]))
            cylPiece(p,SW);
        }

        hull() {
            translate([0,0,-W])
            cylPiece(p,SW);
            translate(t)
                sphere($fn=4,d=SW);
        }
    }
}


//$fn=160;


function interpol(x,a,b) =  x*a+(1-x)*b;

function cx2(a,b) = [
    for(i=[0:1:S])  g(f(interpol( s(i/S), a, b)))
];

function quads(arr) = [
        for(i=[-1:len(arr)-3])
            [ for(j=[0:3]) arr[i+j] ]
    ];

b=quads(cx2([1,0,0],[0,1,0]));

//for(x = a){  cylPiece(x); }
//for(x = b){  cylPiece(x); }

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
        r(W+1);
    }
}

module lidPart() {
    rotate(-12,[1,0,0])
    r();
}

mode="preview0";
if(mode=="preview") {
    basePart();
}
if(mode=="base") {
    basePart();
}
if(mode=="lid") {
    lidPart();
}
