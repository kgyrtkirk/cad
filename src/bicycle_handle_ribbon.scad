
W=1.6;

U=1.5;
V=1;

D1=1.5;
L=15;
D2=4;
L2=L+7;
L3=L2+3*V+2*U+V;
D3=5;



P=[
    [-D1,0],
    [0,D1],
    [L,D1],
    [L+D2-D1,D2],
    [L+D2-D1,D1],
    [L2,D1],
    [L2,D3],
    [L3-2,D3],
    [L3,D3-2],
    [L3,0],
];

difference() {
    linear_extrude(W) {
        polygon(P);
        mirror([0,1,0])
        polygon(P);
    }
    translate([L2+V+U/2,0,0])
    cube([U,6,20],center=true);
    translate([L2+V+U+V+U/2,0,0])
    cube([U,6,20],center=true);
}