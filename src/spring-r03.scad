// Device to produce PLA springs in openscad
// http://www.thingiverse.com/thing:188285/
// REFACTORED (well, prettied up) by sfinktah
//////////////////////////////////
// PARAMETERS
//////////////////////////////////
springLength = 50;              //  length of spring [mm]
springDiameter = 20;            //  spring outer diameter [mm]
filamentDiameter = 2;           //  spring wire diameter [mm] 
springWindings = 10;            //  number of active windings
padLength = 5;                  //  top/bottom padding [mm]
resolution = 10;                //  resolution (nfi)
//////////////////////////////////

$fn=resolution;

difference() {
	cylinder(h = springLength + 2 * padLength, 
			r = springDiameter/2 + filamentDiameter/2, 
			$fn = 32);
    spring();
}

function mirrorXY(v) = [-v[0],-v[1],v[2]];

module spring() {
    R=springDiameter/2+filamentDiameter/2;
    x0=[ for( a=[0:15:springWindings*360] ) 
        [   sin(a)*R,
            cos(a)*R,
            a/360*springLength/springWindings
        ]
    ];
    
    f=mirrorXY(x0[0]);

    x=  concat(
        [mirrorXY(x0[0])],
        x0,
        [mirrorXY(x0[len(x0)-1])]
            );

    translate(v = [0, 0,padLength] ) 
	for (j = [0:len(x)-2] ) {
        hull() {
            translate(x[j+0])
                sphere(d=filamentDiameter );
            translate(x[j+1])
                sphere(d=filamentDiameter );
        }
    }
}

/* vim: set ts=4 sts=0 sw=4 noet: */