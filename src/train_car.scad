use <syms.scad>

ROD_R=3.2/2;
RAIL_DEPTH=3;
SP=1;
W=1.6;

WHEEL_R=RAIL_DEPTH+SP+W+ROD_R;

module wheel() {
    H1=W/4;
    H2=W/2;
    E=.3;
    DECOR_R=WHEEL_R-RAIL_DEPTH-W;
    rotate_extrude($fn=64) {
        polygon([    
            [ROD_R,-H2],
            [ROD_R,H1],
            [ROD_R*2,H1],
            [ROD_R*2,H2],
            [WHEEL_R,H2],
            [WHEEL_R,H1],
            [WHEEL_R-E,H1],
            [WHEEL_R-E,-H1],
            [WHEEL_R,-H1],
            [WHEEL_R,-H2],

            ]);
    }
}

module frame() {
}


frame();