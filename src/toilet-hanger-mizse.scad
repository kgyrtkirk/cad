MD=1;
a=14;
b=4;
s=8+MD;
A=120;
W=1.6-MD;

function    circleSlice2radius(a,b) = (a/2)*(a/2)/(2*b);

mode="preview";
SS=(mode=="def") ? 16 : 6;
//r=circleSlice2radius(165,35);
r=30;
echo(r);

//translate([0,-r,0])
//cylinder($fn=

difference() { 
translate([-r,0,0])
minkowski()
{
rotate(-A/2)
rotate_extrude(angle=A,$fn=SS*8) {
    W0=-2*W;
    translate([r,0])   {
        polygon([
            [2*W0,W0],
            [a,W0/2],
            [a,0],
            [0,0],
            [0,s],
            [b,s],
            [b,s+W],
            [2*W0,s+W],
        
                ]);
    }
}
sphere($fn=SS,d=MD);
}

    translate([0,0,-100-W])
    cube(200,center=true);
}
