module symY(t) {
    translate(t)
        children();
    mirror([0,1,0])
        translate(t)
            children();
}
module symX(t) {
    translate(t)
        children();
    mirror([1,0,0])
        translate(t)
            children();
}

module symZ(t) {
    translate(t)
        children();
    mirror([0,0,1])
        translate(t)
            children();
}

module	symXY(t) {
	tx=t[0];
	ty=t[1];
	tz=t[2];
	symX([tx,0,0])
	symY([0,ty,tz])
		children();
}

module magnetCut(D,S) {
    cylinder(d=D,h=10);
    for(d=[45,-45])
    rotate(d)
    cube([2*D,S,30],center=true);
}


// calculates the radius from "segment" paramers:
// https://en.wikipedia.org/wiki/Circular_segment
function    circleSlice2radius2(c,h) = (c*c/8/h)+ h/2;

function toInt(str) = 
    let(d = [for (s = str) ord(s) - 48], l = len(d) - 1)
    [for (i = 0, a = d[i];i <= l;i = i + 1, a = 10 * a + d[i]) a][l];
        

