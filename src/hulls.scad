module hullPairs(pos,close=true){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
    if(close)
    hull() {
        translate(pos[0]) children();
        translate(pos[len(pos)-1]) children();
    }
    
}


