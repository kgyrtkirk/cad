use <syms.scad>;
$fn=64;

function toInt(str) = 
    let(d = [for (s = str) ord(s) - 48], l = len(d) - 1)
    [for (i = 0, a = d[i];i <= l;i = i + 1, a = 10 * a + d[i]) a][l];
        
D_DIA=8;
mode="89";// ext dist 89.5, 91, 70
D_DIST=toInt(mode)-D_DIA; // center dist 
H=3;
D=4;

// FIXME move to a common place
module hullLine() {
    echo($children);
    for(o = [0:$children-2])  {
        hull() {
            children(o+0);
            children(o+1);
        }
    }
}

module hullPairs(pos){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
    
}


%symX([D_DIST/2,0,0])
cylinder(d=D_DIA,h=10,center=true);
AMP=10;
R=D_DIA/2+D/2;
p=[
        for(i=[270:-10:90])   ([cos(i),sin(i),0]*R - [D_DIST/2,0,0]),
        for(a=[-1:.01:1])
            ([0,cos(a*(90+180*3))* cos(a*(90))*AMP,0] +[a*D_DIST/2,R,0]),
        for(i=[90:-10:-90])   ([cos(i),sin(i),0]*R + [D_DIST/2,0,0])
    ];
        
hullPairs(p) {
    cylinder($fn=8,d=D,h=H);
}