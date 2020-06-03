use <syms.scad>
W=1.6;

$fn=64;

    R1=35/2;
    C1=[48.8,5.6+R1,0];

    Q=[C1[0]*2,45,W];

module m() {
difference() {
    //translate([-W,-W,0])
    translate([0,0,-W/2])
    cube(Q);
    
//    translate([0,0,W])
  //  cube(Q);

    translate(C1)
    cylinder(r=R1,h=30,center=true);
    
    translate(C1)
    symX([45/2,9.5,0])
    cylinder(d=8,h=30,center=true);
    
}
}

mode="project";
if(mode=="project") {
    projection(cut=true) m();
}else{
    m();
}