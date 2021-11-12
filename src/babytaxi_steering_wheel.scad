inner_d=55;
W=3;
H=10;
K=8;

outer_d=128;

$fn=128;

module main() {
    difference() { 
        union() {
            for(a = [0:60:180-1] )
                rotate(a)
                intersection() {
                    cube([K,outer_d,H],center=true);
                    s=30;
                    rotate(s,[0,1,0])
                    cube([K,outer_d,H],center=true);
                    rotate(-s,[0,1,0])
                    cube([K,outer_d,H],center=true);
                }
            cylinder(d=inner_d+2*W,h=H,center=true);
            
            
            rotate_extrude(convexity = 10, $fn = 100)
            translate([outer_d/2, 0, 0])
            circle(d = H, $fn = 100);
        }
        
        cylinder(d=inner_d,h=H*4,center=true);

    }
}
mode="def";
if(mode=="def") {
    main();
}

if(mode=="preview") {
    intersection() {
        main();
        cylinder(d=inner_d+4*W,h=4,center=true);
    }
}