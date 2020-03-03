
// x, y, rotation
function fwd(X) = [ 0, X, 0];
function side(X) = [ -X, 0,0];
function rot(X) = [ 0, 0, -X];
function rel(X,Y) = [-X,Y,0];

function logo1(li) = logo(li, [0,0,0]);

function sublist(li,off) = (off<len(li))?[ for(i=[off:len(li)-1]) li[i] ]:[];
function stateEval(state,move) = 
    [   state[0] + sin(state[2])*move[0] + cos(state[2])*move[1],
        state[1] + cos(state[2])*move[0] - sin(state[2])*move[1]    ,
        state[2]+move[2]
    ];

function vec2(v) = [v[0],v[1]];

function logo(li,state) =
    0<len(li) ? concat(
               [vec2(stateEval(state,li[0]))],logo(sublist(li,1),stateEval(state,li[0]))
            ) : [];

//function logo(li)

K=50;
S=3;
x=[
    rot(0),fwd(K),side(S),fwd(S),rel(-2*S,2*S),fwd(-3*S)

];
echo(logo1(x));
//linear_extrude()
//polygon(logo1(x));

//echo(sublist(x,0));
//echo(logo([fwd(10),rot(90),fwd(10)]));

//x=[ fwd(1) ];


W=1.2;
Z=3;


A=80;
B=18+W;
C=19+W;
D=18+W;

H=15;


if(false)
difference() {
    union() {
        cube([A,B,H],center=true);
    }
    translate([-W,0,0])
    cube([A,B-2*W,H+1],center=true);
    
}



// FIXME move to a common place
module hullLine() {
    echo($children);
    for(o = [0:$children-2])  {
        hull() {
            children(o+0);
            children(o+1);
        }
    }
}


Q=4;
W2=2*W;
$fn=32;
difference() {
hullLine() {
    translate([A+Q+2*Z,2*Z,0])
    cylinder(d=W,h=H);
    translate([A+Q,0,0])
    cylinder(d=W,h=H);
    translate([A,0,0])
    rotate(-30)
    cylinder($fn=3,d=W,h=H);
    translate([A+Z,Z,0])
    cylinder(d=W,h=H);
    translate([0*A/2,Z,0])
    cylinder(d=W2,h=H);
    translate([0*A/2,0,0])
    cylinder(d=W2,h=H);
    translate([0,0,0])
    cylinder(d=W2,h=H);
    translate([0,-B,0])
    cylinder(d=W,h=H);
    translate([C,-B,0])
    cylinder(d=W,h=H);
    translate([C,-B-D,0])
    cylinder(d=W,h=H);
    
}
translate([C,-B-D/2-.5,H/2])
rotate(90)
rotate(90,[1,0,0])
    cylinder(d=3.2,h=30,center=true);

}



























