use <syms.scad>

M_L=74;
M_W=32;
M_H=6;

W=2;

//30-36
SCREWHOLE_I1=25.4;
SCREWHOLE_I2=35.3;
SCREWHOLE_D=3;
SCREWHOLE_D2=5.8;



module decorationCuts(xSpace,ySpace){
    CUTW0=W;
    N=floor((ySpace-CUTW0) / (2*CUTW0) );
    //N=3;
    CUTW=ySpace / (2*N+1);
    echo(CUTW);
    
    for(z=[CUTW+CUTW/2:2*CUTW:ySpace])
    translate([0,0,z])
    cube([CUTW,xSpace-2*CUTW,CUTW],center=true);
}


difference() {
    E_L=M_L+2*W;
    E_W=M_W+2*W;
    E_H=M_H+2*W;
    translate([0,0,M_H/2-W])
    cube([M_L+2*W,M_W+2*W,M_H+2*W],center=true);

    translate([0,0,M_H/2+1])
    cube([M_L,M_W,M_H+2],center=true);


    symY([-E_L/2,E_W/2,E_H/2-W-W])
    rotate(90)
    rotate(90,[1,0,0])
    decorationCuts(E_H,E_L);

    symX([-E_L/2,E_W/2,E_H/2-W-W])
    rotate(0)
    rotate(90,[1,0,0])
    decorationCuts(E_H,E_W);

    symY([-M_L/2,E_W/3-W,0])
    rotate(90,[1,0,0])
    rotate(90)
    rotate(90,[1,0,0])
    decorationCuts(E_W/3,M_L);
    
    symX([SCREWHOLE_I1/2,0,-W]) {
        $fn=16;
        hull()
        symX([(SCREWHOLE_I2-SCREWHOLE_I1-SCREWHOLE_D)/4,0,0])
        cylinder(d=SCREWHOLE_D,h=10,center=true);
        hull()
        symX([(SCREWHOLE_I2-SCREWHOLE_I1)/4,0,0])
        cylinder(d=SCREWHOLE_D2,h=10);
    }

}


