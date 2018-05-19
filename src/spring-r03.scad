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


// INTERNAL PARAMETERS (DO NOT CHANGE)
//////////////////////////////////////
innerRadius = springDiameter / 2;
filamentRadius = filamentDiameter / 2;
outerRadius = innerRadius + filamentRadius;
windingHeight = springWindings / springLength;
step = 1 / windingHeight;
epsilon = 0.01;
//////////////////////////////////////

difference() {
	cylinder(h = springLength + 2 * padLength, 
			r = outerRadius, 
			$fn = 32);
	union () {
//		start();
		spring();
	//	end();
	}
}

module start() {
	translate(v = [-epsilon, outerRadius - 2 * filamentRadius, padLength] ) {
		rotate(a = 270, v = [0, -1, 0] ) {
			for (i = [0:90] ) {
				rotate(a = i, v = [1, 0, 0] ) {
					translate(v = [0, filamentRadius * 2, 0] ) {
						rotate(a = i, v = [0, 0, 1] ) {
							if (i == 90) {
								cylinder(
										h = 2 * outerRadius, 
										r = filamentRadius, 
										$fn = resolution, 
										center = false);
							} else {
								cylinder(h = 1, 
										r = filamentRadius, 
										$fn = resolution, 
										center = true);
							}
						}
					}
				}
			}
		}
	}
}

module end() {
	translate(v = [0, outerRadius - 2 * filamentRadius, padLength + springLength] ) {
		rotate(a = 270, v = [0, 1, 0] ) {
			for (i = [0:90] ) {
				rotate(a = i, v = [1, 0, 0] ) {
					translate(v = [0, filamentRadius * 2, 0] ) {
						rotate(a = i, v = [0, 0, 1] ) {
							if (i == 90) {
								cylinder(h = 2 * outerRadius, 
										r = filamentRadius, 
										$fn = resolution, 
										center = false);
							} else {
								cylinder(h = 1, 
										r = filamentRadius, 
										$fn = resolution, 
										center = true);
							}
						}
					}
				}
			}
		}
	}
}

function mirrorXY(v) = [-v[0],-v[1],v[2]];

module spring() {
    R=springDiameter/2+filamentDiameter/2;
    x0=[ for( a=[0:15:springWindings*360] ) 
        [   sin(a)*R,
            cos(a)*R,
            a/360*step
        ]
    ];
    $fn=10;
//    echo(x);
    
    f=mirrorXY(x0[0]);
    //e=x0[len(x0)-1]);

    x=concat(
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
        
    
    
    if(false)
	for (j = [0:(springWindings - 1)] ) {
		translate(v = [0, 0, j * step + padLength] ) {
			rotate(a = 270, v = [0, 1, 0] ) {	// flip it to basis plane[x,y]
				for (i = [0:360] ) {
					rotate(a = i, v = [1, 0, 0] ) {
						translate(v = [(i / (360 * windingHeight)), outerRadius, 0] ) {
							cylinder(h = 1, 
									r = filamentRadius, 
									$fn = resolution, 
									center = true);
						}
					}
				}
			}
		}
	}
}
/* vim: set ts=4 sts=0 sw=4 noet: */