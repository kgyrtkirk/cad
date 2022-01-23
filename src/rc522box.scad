
PCB=[59.84,39.51,2]; //

D=3.07;
HOLES=[ 
        for (i = [[ 5.47,5.66 ], [42.66 ,0.96]])  i+[D,D]/2
    ] ;

module atHoles() {
    for(p=HOLES) {
        
        translate([p[0],p[1],0])
            children();
        translate([p[0],PCB[1]-p[1],0])
            children();
        
    }
    
    
}

module pcb() {
    color([0,1,0]) {
    translate([PCB[0]-10,0,0])
    cube([10,PCB[1],8]);
    difference() {
        cube(PCB);
        atHoles() {
            cylinder(d=D,center=true,h=10);
        }
    }
}
    
}

    pcb();
        
difference() {
    
    
}
        
