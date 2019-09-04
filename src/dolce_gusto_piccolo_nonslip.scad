use <syms.scad>


W=1.6;          // reality ~2.0
GRID_H=19;    // reality ~17.5 
//cube([100,100,1],center=true);



module cutShape() {
    SHAVE=10;  // shave away from borders
    D=105;    // bottom diameter
    S=32;     // centerline to bottom dist
    RD=circleSlice2radius2(D,S);
    echo(RD);
    $fn=64;
    MUCH=GRID_H*3;
    difference() {
        intersection() {
            cylinder(d=D-2*SHAVE,center=true,h=MUCH);
            translate([0,S-RD,0])
            cylinder(r=RD-SHAVE,center=true,h=MUCH);
        }
        // cut out center line 
        translate([0,0,MUCH/2+9.5])
        cube([D,5,MUCH],center=true);
        // cut out "drain"
        hull() {
            D1=14.6+5.4;
            D1=27;
            cylinder(d=D1,h=MUCH,center=true);
            translate([0,116,0])
            cylinder(d=D1,h=MUCH,center=true);
        }
    }

}

module centerGrid() {
    DEPTH=1.5;
    dist=70/12;
    cnt=6;
    BASE_Y0=2;
    BASE_Y1=-18;
    difference() {
        // blades
        for(i=[-cnt-.5:cnt+.5]){ 
            
            hull() {
                translate([i*dist,0,0]) {
                translate([0,-10,GRID_H-W/2])
                cube([W,70,W],center=true);
                translate([0,-100-BASE_Y0,W/2])
                cube([W,W,W],center=true);
                translate([0,100+BASE_Y1,W/2])
                cube([W,W,W],center=true);
                }
            }
        }
        //top-cuts

        for(i=[-50:2*W:50]){ 
            translate([0,i,GRID_H])
            cube([200,W,2*DEPTH],center=true);
        }
    }
    translate([0,BASE_Y0,W/2])
    cube([(2*cnt+1)*dist,W,W],center=true);

    translate([0,BASE_Y1,W/2])
    cube([(2*cnt+1)*dist,W,W],center=true);

    translate([0,-33,W/2])
    cube([(2*cnt+1)*dist,W,W],center=true);
    
}

module product() {
    intersection() {
        difference() {
            centerGrid();
        }
        cutShape();
    }
}

mode="preview";
if(mode=="def") {
    rotate(90) // rotate to reduce y axis usage
    product();
}
if(mode=="preview"){
    product();
}

//cutShape();

//cylinder