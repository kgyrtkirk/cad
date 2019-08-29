
//square();
//polygon([[1,1],[2,2],[10,4]]);

W=3;

r=12;
R=r+W;
A=19-r; // side
B=23-r; // top
CT=5;  // hinge top
AT=3;
AK=3;

steps=20;
points = [

    [-r,-A],
    [-r,0],
	for (a = [0: 1 : steps]) r*[ -cos(a*90/steps),sin(a*90/steps) ],
    [B,r],
    
    [B,r-CT],
    [B+W,r-CT],
    
    [B+W,R],
	for (a = [steps: -1 : 0]) R*[ -cos(a*90/steps),sin(a*90/steps) ],
    [-R,0],
    [-R,-A],

    [-R,-A-W],
    [-r+AT+W,-A-W],
    [-r+AT+W,-A+AK],
    [-r+AT,-A+AK],
    [-r+AT,-A],

];


linear_extrude(6)
polygon(points);