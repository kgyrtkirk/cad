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
