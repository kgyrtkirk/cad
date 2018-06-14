use <../libraries/path_extrude.scad>

U_W=44.5;
U_H=10;
D=1.4;
U_OV=8;

shape_U= [
            [ 0,          0   ],
            [ U_W/2,      0   ],
            [ U_W/2,      U_H ],
            [ U_W/2-D/2,      U_H ],
            [ (U_W/2-D),  D   ],
            [-(U_W/2-D),  D   ],
            [-U_W/2+D/2,      U_H ],
            [-U_W/2,      U_H ],
            [-U_W/2,      0     ]
        ];

            
SP_A=180+25.33;
SP_R=(83+38.5)/2;
SP_H=70;


sPathMain=[ 
for(t = [0:.005:1]) 
    [  SP_R*sin(t*SP_A),
        SP_R*cos(t*SP_A),
        SP_H*t  ,
    ]
];

echo(sPathMain[len(sPathMain)-1]);
sPath=concat(
[
    [-U_OV,SP_R,0],
    [-U_OV/2,SP_R,0]
],sPathMain,[
sPathMain[len(sPathMain)-1]+[U_OV/2*cos(SP_A),-U_OV/2*sin(SP_A),0],
sPathMain[len(sPathMain)-1]+[U_OV*cos(SP_A),-U_OV*sin(SP_A),0]
]);
//,sPathMain

//sPath=concat(sPathMain);

pi=3.14159;
myPoints = [ for(t = [0:90:222]) [cos(t+45),sin(t+45)] ];
myPath = [ for(t = [0:3.6:360])
    [5*cos(2*t),5*sin(2*t), (t<0)?0:((t*t*90)/500/100 * 4*pi/180)] ];

O_W=.8;

module connector(){

/*    
    rotate(90,[0,0,1])
    rotate(-90,[1,0,0])
    color([1,0,0]) 
#    linear_extrude(height=U_OV)
        polygon(shape_U);
  */  
    translate([-2.5,0,-0.001]) {
        
        difference() {
        translate([-2,0,2.5])
            cube([6,40,5],center=true);
        
        translate([-2,0,2.5])
            cube([6-2*O_W,40-2*O_W,8],center=true);
    }
        /*
        translate([0,-20,0])
        cube([1,40,5]);
        translate([-5,-20,0])
        cube([1,40,5]);

        translate([-5,-20,0])
        cube([6,1,5]);
        translate([-5,20-1,0])
        cube([6,1,5]);
        */
        
        translate([-7,-10,0])
        cube([2,20,1]);
        
    }
}

partial=false;
module ramp()
{
    intersection() {
        if(partial) {
        translate([00,-SP_R,0])
        rotate(20,[0,0,1])
        cube([30,50,50],center=true);
        }
            rotate(180,[1,0,0])
            union(){
        path_extrude(points=shape_U, path=sPath);

        translate(sPathMain[0])
        connector();

        translate(sPathMain[len(sPathMain)-1])
        rotate(180-SP_A,[0,0,1])
        connector();
        }
    }
}


module support() {
s_off=-.5;
SW=.8;
S=U_W/2-1;
shape_S= [
            [ -S,            0   ],
            [ S,            0   ],
            [ S,            -SP_H*2 ],
            [ S-SW,         -SP_H*2 ],
            [ S-SW,         -SW ],
            [ -S+SW,         -SW ],
            [ -S+SW,         -SP_H*2 ],
            [ -S,            -SP_H*2 ],
];

    rotate(180,[1,0,0])
path_extrude(points=shape_S, path=sPath);
}


ramp();

difference() {
    
    union() {
//        render() support();
    }
//    translate([-500,-500,-1000-SP_H-4.65])
  //  cube(1000);
}


//path_extrude(points=myPoints, path=sPath);



