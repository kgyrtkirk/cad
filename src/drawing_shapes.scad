

W=1.2;
C=3;

module edge(d1,d2) {
    echo(d1,d2);
    difference(){
        cylinder(d=d1,h=$W,center=true);
        cylinder(d=d2,h=2*$W,center=true);
    }
}


module edges(r) {
    for(i=[0:1:len(r)-1]){
        echo(i);
        edge(r[i+1],r[i]+$C);
    }
    
}



module piece(N,nHold=6) {

union() {
    $W=W;
    $fn=N;
    $C=C/cos(360/N/2);
    r=[2,3,4,5,6,7]*10;
    edges(r);
    intersection() {
        union() {
            for(deg=[180/nHold:360/nHold:360-1])
                rotate(deg,[0,0,1])
            translate([150,0,0])
            cube([300,$W,$W],center=true);
        }
        edge(r[len(r)-1],r[0]+$C);
    }
}

}


mode="a360";
if(mode=="a6") {
    piece(6);
}
if(mode=="a5") {
    piece(5,5);
}
if(mode=="a4") {
    piece(4,4);
}
if(mode=="a3") {
    piece(3,3);
}
if(mode=="a360") {
    piece(120);
}
