use <hulls.scad>

function sublist(l,start)=start<len(l) ? [for(i=[start:len(l)-1])  l[i]] : undef;
function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

module posNeg() {
    difference() {
        union(){
        $positive=true;
        children();
        }
        union(){
        $positive=false;
        children();
        }
    }
}

module ppp(name,dims="") {
    echo(name,dims);
    if($positive)
    if($part==undef || $part==name) 
        children();
}


module eXY(name, dX, dY) {
    ppp(str(name,"-XY"),str(dX,"x",dY))
        cube([dX,dY,$W]);
}

module eYZ(name, dY, dZ) {
    ppp(str(name,"-YZ"),str(dY,"x",dZ))
        cube([$W,dY,dZ]);
}
module eXZ(name, dX, dZ) {
    ppp(str(name,"XZ"),str(dX,"x",dZ))
        cube([dX,$W,dZ]);
}


