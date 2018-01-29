use <../libraries/path_extrude.scad>

U_W=44.5;
U_H=10;
D=1;

shape_U= -[
            [ 0,          0   ],
            [ U_W/2,      0   ],
            [ U_W/2,      U_H ],
            [ (U_W/2-D),  D   ],
            [-(U_W/2-D),  D   ],
            [-U_W/2,      U_H ],
            [-U_W/2,      0     ]
        ];

            
//polygon(shape_U);


SP_A=180+25.33;
SP_R=(83+38.5)/2;
SP_H=70;


sPath=[ for(t = [0:.05:1]) 
       [    SP_R*sin(t*SP_A),
            SP_R*cos(t*SP_A),
            SP_H*t
       ]
];



pi=3.14159;
myPoints = [ for(t = [0:90:222]) [cos(t+45),sin(t+45)] ];
myPath = [ for(t = [0:3.6:360])
    [5*cos(2*t),5*sin(2*t), (t<0)?0:((t*t*90)/500/100 * 4*pi/180)] ];
path_extrude(points=shape_U, path=sPath);
//path_extrude(points=myPoints, path=sPath);



