


A=35;
    ST_U=19.5;
    ST_V=12.5;

B=ST_U+ST_V;
W=2;

SW_BOTTOM_Z=-17-2;    //  trigger dist is 17.1
SW_A=20+.5;
SW_D=6.5+.2;
SW_H=10+2;


S_D=4.5; //4.2 measured
S_L=10;  // compressed length


// switch lays on XY plane

module springCage() {
    
    
        translate([-W,-W,-W])
    difference() {
        cube([S_D+2*W,S_D+2*W,S_L]);
        translate([W,W,W])
        cube([S_D,S_D,S_L]);
    }
    
}

module switchCage() {
    difference() {
        translate([-W,-W,-W])
        cube([SW_A+2*W,SW_D+2*W,SW_H]);
        cube([SW_A,SW_D,SW_H]);
        for(x = [W,10,SW_A-W]) {
        translate([x,0,0])
            translate([-W,0,-50])
            cube([2*W,SW_D,100]);
        }
    }
}

module main() {
    
    SP=3*W;
    
    translate([-A/2+SP,W,SW_BOTTOM_Z])
    switchCage();
    
    translate([A/2,W,-S_L])
    mirror([1,0,0])
    springCage();
    
    translate([-A/2,0,-B])
    cube([A,W,B-W]);
    
    for(x=[-A/2,A/2-W]) 
        translate([x,0,-B*2/3])
        cube([W,3*W,8]);
    
    translate([-A/2,-W,-B]){
        cube([A,W,ST_V]);
    }
    
}
mode="r";
if(mode=="l") {
mirror([1,0,0])
main();
}

if(mode=="r") {
main();
}