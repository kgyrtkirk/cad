
H=2;
D=3;
L=200;
HOOK_I_D=5;
HOOK_R=(HOOK_I_D+D)/2;

$fn=16;
//circle(d=D);

x0=[ for( a=[0:15:260] ) 
        [   L/2+sin(a)*HOOK_R,
            cos(a)*HOOK_R,
            0
        ]
    ];
    
function mirrorXY(v) = [-v[0],-v[1],v[2]];
f=mirrorXY(x0[0]);

x=  concat(
    x0,
    [0,0,0]
        );

for(r=[0:180:180])
    rotate(r)
        for (j = [0:len(x)-2] ) {
        hull() {
            translate(x[j+0])
                cylinder(d=D,h=H);
            translate(x[j+1])
                cylinder(d=D,h=H);
        }
    }


