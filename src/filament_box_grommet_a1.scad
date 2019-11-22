//use <threads.scad>
use <quickthread.scad>


//isoThread(d=20,h=30,pitch=3,angle=40,internal=false,$fn=60);



module thread(D=10,L=10,I=true) {
    isoThread(d=D,h=L,pitch=3,angle=40,internal=I,$fn=60);
/*
metric_thread (
    diameter=D,
    pitch=1,
//    groove=true,
    length=L,
    internal = I
    );
*/
}

$fn=16;

difference() {

    union() {
        difference() {
            cube([20,20,10],center=true);
            thread(I=true);
        }

        thread(I=false);
    }
  cube(100);
    
}
