
D=[8,44,2];
Q=4;
H=18;
BY=20;
BH=3;
BD=1;

module m() {
    
    cube(D,center=true);
    
    
    translate([0,-D[1]/2+Q/2,0])
    difference() {
        cylinder($fn=4,d=Q,h=H,center=true);
        translate([0,50,0])
        cube(100,center=true);
    }
    translate([0,BY,0])
    cylinder($fn=16,d=BD,h=BH,center=true);
}

module o() {
translate(-D/2+[0,0,1])
import("/home/kirk/Downloads/Roló-csúszka-2.stl");
}

difference() {
//  o();
   m();

}

