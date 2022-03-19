
module m() {

    for(y=[0:3])
        translate([0,y,0]*50)
for(x=[-46,0,46]) {
    
    
    for(y=[0,10,20]) {
    translate([x,y*sqrt(2),0])
    rotate(45)
    cube(10,center=true);
    }
}
}

projection()
m();