use <hulls.scad>
use <syms.scad>



R=50;
H=100;
T=2000;

function low(a) = pow(a,4);

function px(x,a) =
                [low(x)*R*sin(a*T*(1-x)),low(x)*R*cos(a*T*(1-x)),pow(x,15)*H*x];



$density=.01;

function cx2(a,b) = 
                [
        for(x=[0:$density:1])
                px(x,a)
            ]
;


function dx(a,x) = 
                [
        for(aa=[-a:.01:a])
                px(x,aa)
            ]
;
            


eps=1e-4;
W=2;


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
        if(p0 == undef || p2 == undef /*|| abs(s)<0.5*/) {
            translate(p1)
                sphere(d=diameter);
        }else{
            s=(unit(p2-p1) * unit(p2-p0));
//            echo(s);
            m=(s == undef || s>.97)   ? computePointMatrix(p2-p0,[1,1,0],p1)
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


function quads(arr) = [
    for(i=[-1:len(arr)-3])
            [ for(j=[0:3]) arr[i+j] ]
    ];

function interpol(x,a,b) =  x*a+(1-x)*b;



module fx() {
    

    l=[
        for(i=[-.9:.2:1]) 
            quads(cx2(i,0)),
            quads(dx(.9,.9)),
            quads(dx(.1,.973)),
        
    ];
        
    for(a = l){ for(x = a){ cylPiece(x,W); }}

}
    


mode="render";
if(mode=="def") {
//$fn=16;
    
    fx();
}
if(mode=="render") {
    $density=1.0/200;
    $fn=12;
    fx();
}

%translate([0,R,H-40])
    rotate(90,[1,0,0]) {
    cylinder(h=20,d=8);
        
    }