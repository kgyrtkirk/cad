use <threads.scad>

trial=false;
module bj_thread(internal) {
    translate([0,0,-.1]) {
    if(trial)
    cylinder(d=BJ_R*2+BJ_W+BJ_W,h=6);
        else
    metric_thread (diameter=BJ_R*2+BJ_W+BJ_W, pitch=1, length=6,internal=internal);
    }
}


W=1;
$fn=32;

R=[1,1.5,2,2.5,3,3.2,3.5,4,4.5,4.8,5,5.5,6,6.5];

P=  [
[6.500000, [0.153550, 0.332129, 0.000000]],
[6.000000, [13.633618, 1.065443, 0.000000]],
[5.500000, [7.952262, -10.068837, 0.000000]],
[5.000000, [-3.439691, -11.640117, 0.000000]],
[4.800000, [-11.276963, -4.209692, 0.000000]],
[4.500000, [-10.395121, 6.052163, 0.000000]],
[4.000000, [-2.608649, 11.494604, 0.000000]],
[3.500000, [6.298204, 9.448991, 0.000000]],
[3.200000, [13.779614, 11.263957, 0.000000]],
[3.000000, [20.397305, 8.430303, 0.000000]],
[2.500000, [23.025674, 2.487033, 0.000000]],
[2.000000, [21.731688, -2.857066, 0.000000]],
[1.500000, [18.239563, -6.073382, 0.000000]],
[1.000000, [14.828170, -6.842763, 0.000000]],
];
//X=["a"=1];
//echo X.a;

for( e= P ) {
//    echo(e);
    d=e[0]; // diameter
    p=e[1]; // center point
    echo(p);
    translate(p)
    cylinder(r=d);
    
}

