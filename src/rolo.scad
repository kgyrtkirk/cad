
D=[8,44,2];
Q=4*4/3.3;
H=18;
BY=20;
BH=4;
BD=1;

module m() {
    
    cube(D,center=true);
    
    
    translate([0,-D[1]/2+Q/2,0])
    difference() {
        cylinder($fn=4,d=Q,h=H,center=true);
        translate([0,50,0])
        cube(100,center=true);
    }
    if(false) {
        translate([0,BY,0])
        cylinder($fn=16,d=BD,h=BH,center=true);
    }else{
        hull() {
            translate([0,BY+BD,0])
            cylinder($fn=16,d=BD,h=D[2],center=true);
            translate([0,BY-BD,0])
            cube([6,.1,BH],center=true);
//            cylinder($fn=16,d=BD,h=BH,center=true);
        }
    }
}

module o() {
translate(-D/2+[0,0,1])
import("/home/kirk/Downloads/Roló-csúszka-2.stl");
}

mode="print";
if(mode=="preview") {
    difference() {
        //  o();
        m();
    }
}
if(mode=="print"){
    rotate(90,[0,1,0])
    m();
}


