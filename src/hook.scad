
A=30;
B=50;
W=3;
T=1.6;

X1=1.5;
X2=X1+W/2;

Y1=2;
Y2=6;
Y3=Y2+W;

path=[
[-X2,Y1],
[0,Y3],
[X2,Y1],
[-X1,-Y1],
[-X1,-Y1],
[0,-Y2],
[X1,-Y1],
[X2,-Y1],
[0,-Y3],
[-X2,-Y1],
[X1,Y1],
[0,Y2],
[-X1,Y1],



];

linear_extrude(T)
polygon(path);