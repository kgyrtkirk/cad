// * raise rods in X dir
// * probably lower overhang support angle? and print with generic support
// * use brim?
// * enable adaptive layers or .3

use <syms.scad>
render=false;
render1=render;//render;


eps=1e-4;
$fn=render1 ? 16 :4;   // line detail
M=100;  // object scale
N=M/(50/8)/2;   // number of lines
ZRATIO=2/3;
S=render1 ? 8*N : 2*N;   // line detail
n=4*N;
m=2*N;

W=3;

module mySphere(d=W) {
    color([1,0,0])
    sphere(d=d);
}


// maps 0:1 to 0:1 but with more detail near 0 and 1
function s(v) = (cos(v*180+180)+1)/2;

function s2(v) = (sin(v*180/2));


// maps 2d points onto a "hill" alike thing; also distorts y a little bit
function hill(v) = ([
    v[0],v[1]+pow((1-v[0]*v[0])*v[1],1),
    pow((1-v[0]*v[0])*v[1],.25)*ZRATIO
] );


function f(v) = hill([s2(v[0]),1-s2(1-v[1])]);

//function f(v) = hill(v);



// calculates a vector in the given dir (0=x axis)
function v3r(d) = [ cos(d), sin(d), 0 ];

// final changes to points
function g(v3) =  v3 * M;

K=8-W;

module foot() {
    difference() {
        translate([0,0,-W/2])
        union() {
            hull() {
                R=K/M;
                translate(g([-1,0,0]))
                    mySphere(2*W);
                translate(g([-1,R,0]))
                    mySphere(2*W);
                translate(g([1,0,0]))
                    mySphere(2*W);
                translate(g([1,R,0]))
                    mySphere(2*W);
            }

            symX()
            hull() {
                R=K/M;
                translate(g([-1,1,0]))
                    mySphere(2*W);
                translate(g([-1,0,0]))
                    mySphere(2*W);
                translate(g([-1+R,1,0]))
                    mySphere(2*W);
                translate(g([-1+R,0,0]))
                    mySphere(2*W);
            }
        }
        translate([0,0,-500-W/2])
        cube(1000,center=true);
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


    u0=[-1,0,0];
    u1=[1,0,0];
    v0=[0,0,0];
    v1=[0,1,0];

            
            
module fx2(om=0,dia) {
    dN=0;
    U=8;
    l0= interpol(1/U/n,u0,u1)+interpol(1/U/m,v1,v0);
    l1= interpol(1/U/n,u0,u1)+v1;
    r0= interpol(1/U/n,u1,u0)+interpol(1/U/m,v1,v0);
    r1= interpol(1/U/n,u1,u0)+v1;
    
//        for(i=[1:1]) 
  //          quads(cx2(interpol(i/4/n,u0,u1)+v0,interpol(i/4/n,u0,u1)+v1)),
    
    
    l=[
/*        quads(cx2(r0,r1)),
        quads(cx2(l0,r0)),
        quads(cx2(l0,l1)),*/
        for(i=[dN:n-dN]) 
            quads(cx2(interpol(i/n,u0,u1)+v0,interpol(i/n,u0,u1)+v1)),
        for(i=[0:m-dN]) 
            quads(cx2(interpol(i/m,v0,v1)+u0,interpol(i/m,v0,v1)+u1)),
    ];
    for(a = l){ for(x = a){ cylPiece(x,dia); }}
}

C_X=2+3+2;
C_Y=4+1;


module cutOut() { 
    points=[
        //Y+
        for(i=[C_X:n-C_X]) 
            interpol(i/n,u0,u1)+interpol(-1/m,v0,v1),
        //X-
        for(i=[0:m-C_Y]) 
            interpol(i/m,v0,v1)+interpol(C_X/n,u1,u0),
        //Y-
        for(i=[C_X+1:n-C_X]) 
            interpol(i/n,u1,u0)+interpol(C_Y/m,v1,v0),
        //X+
        for(i=[C_Y+1:m]) 
            interpol(i/m,v1,v0)+interpol(C_X/n,u0,u1),
    //        interpol(i/n,u0,u1)+v1,
//        for(i=[0:m-1]) 
  //          quads(cx2(interpol(i/m,v0,v1)+u0,interpol(i/m,v0,v1)+u1)),
    ];
        
        
        p2=[for(p=points) [ g(f(p))[0],g(f(p))[1] ] ];
         
        linear_extrude(200) {
            polygon(p2);
        }
        
        if(false)
%        color([1,0,0])
        for(p0=[points])
//        hull() 
        for(x=p0)
            translate(g(f(x)))
            sphere($fn=4,d=10);
    
}


module basePart() {
    fx2(0,W);
}

module lidPart() {
    color([0,1,0])
    intersection() {
        basePart();
        cutOut();
    }
}

module floorPart() {
    difference() {
        basePart();
        cutOut();
    }
    foot();
}
    


mode="preview";
if(mode=="preview") {
    floorPart();
    translate([0,0,10])
        lidPart();
}
if(mode=="preview2") {
    basePart();
    translate([0,20,0])
    cube([95,170,50]);
}
if(mode=="base") {
    floorPart();
}
if(mode=="full") {
    basePart();
    foot();
}
if(mode=="lid") {
    k0=[for(i=[0,m-C_Y]) 
    (interpol(i/m,v0,v1)+interpol(C_X/n,u1,u0))];
    k=[for(i=k0)  g(f(i))];
    d=k[0]-k[1];
    
//    for(p=k)
  //      translate(p)
    //        sphere(3);
    
//    echo(d);
    alpha=atan2(d[2],d[1]);
    echo(alpha);

    
    translate(-k[1])
    rotate(-alpha,[1,0,0])
    lidPart();
}
