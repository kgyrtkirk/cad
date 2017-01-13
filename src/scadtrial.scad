$fn=32;

WT=2;
spaceH=3;
deviceH=18;
BoxW=74;
BoxD=60;
BoxH=WT+spaceH + deviceH;
BoardSpaceN=5;
BoardSpaceS=5;
BoardSpaceE=37 - 29.82;
DC_X=10;
DC_Y=10;



module stand(){
    holeSize=1.9;
    difference(){
        translate([0,0,-.1]) cylinder(d=holeSize+2,h=spaceH+.1);
        translate([0,0,-1]) cylinder(d=holeSize,h=spaceH+2);
    }
    rotate(90,[1,0,0]) 
        for( i = [0:8] ){
//            rotate(45*i,[0,1,0]) 
  //          cylinder(d1=1,d2=0,h=10);
        }
}


module atCorners0(){
    children();
    translate([BoxW,BoxD,0]) rotate(180,[0,0,1]) children();
}

module atCorners1(){
    translate([BoxW,0,0]) rotate(90,[0,0,1]) children();
    translate([0,BoxD,0]) rotate(270,[0,0,1]) children();
}

module atCorners(){
    atCorners0()  children() ;
    atCorners1()  children() ;
}


module filletEdge(len){
    linear_extrude(height=len) {
        intersection() {
            circle(r=WT);
            square(WT);
        }
    }
}

module union1(){
    union(){
        union(){
            union(){
            union(){
                if($children>0)children(0);
                if($children>1)children(1);
            }
            union(){
                if($children>2)children(2);
                if($children>3)children(3);
            }
            }
            union(){
            union(){
                if($children>4)children(4);
                if($children>5)children(5);
            }
            union(){
                if($children>6)children(6);
                if($children>7)children(7);
            }
            }
        }
        union(){
            union(){
            union(){
                if($children>8)children(8);
                if($children>9)children(9);
            }
            union(){
            }
            }
            union(){
            union(){
            }
            union(){
            }
            }
        }
    }
    if($children>10){
        echo("BAJ");
    }
}
    
difference() {
    union() {
        // bottom
        translate([-1,-1,0])
        color("green") cube([BoxW+2,BoxD+2,WT]);
        // walls
        translate([0,-WT,0]) cube([BoxW,WT,BoxH]);
        translate([0,BoxD,0]) cube([BoxW,WT,BoxH]);
        translate([-WT,0,0]) cube([WT,BoxD,BoxH]);
        translate([BoxW,0,0]) cube([WT,BoxD,BoxH]);
        
        translate([BoxW-BoardSpaceE,BoxD-BoardSpaceN,WT]) 
            rotate(180,[0,0,1]) {
                translate([14.55,40,0] ) stand();
                translate([44.8,22,0] ) stand();
            }


        atCorners(){
            linear_extrude(height=BoxH) {
                circle(r=WT);
                translate([1,1,0]) circle(r=WT+1);
            }
        }

        //cover
        translate([0,0,BoxH])
        #difference() {
            cube([BoxW,BoxD,WT]);
            translate( [37,BoxD-BoardSpaceN-19.5,-1 ]) {
                cylinder(h=10,d=23,center=true);
                cylinder(h=WT/2+1,d1=23+WT,d2=23-0.001);
            }
            
        }

        atCorners0(){
            translate([0,0,BoxH]) 
            rotate(90,[1,0,0]) {
            union(){
                rotate(180,[0,1,0])
                filletEdge(BoxD);
                rotate(90,[0,1,0])
                rotate(90,[0,0,1])
    //            filletEdge(BoxD);
                sphere(WT);
            }
            }
        }
        
        atCorners1(){
            translate([0,0,BoxH]) 
            rotate(90,[1,0,0]) {
            union(){
                rotate(180,[0,1,0])
                filletEdge(BoxW);
//                filletEdge(BoxD);
    //            rotate(90,[0,1,0])
  //              rotate(90,[0,0,1])
//                filletEdge(BoxD);
                sphere(WT);
            }
            }
        }

        

    }
    // dcPlugHole
    translate([BoxW,BoxD,0]) rotate(90,[0,0,1]) {
        translate([ -BoardSpaceN-DC_X,
                    0,
                    WT+spaceH+DC_Y])
            rotate(90,[1,0,0]) cylinder(h=10,d=8,center=true);
    }
    // front holes
    translate([BoxW/2,0,9]) {
        // dht large hole
        translate([25/2,0,0]) rotate(90,[1,0,0]){
            translate([0,1.5*2.54,0])
            #cylinder(d=3,h=10,center=true);
        }
        // dht pins
        translate([-25/2,0,0]) rotate(90,[1,0,0]){
            for( i = [0:3] )
            translate([0,i*2.54,0])
            #cylinder(d=1,h=10,center=true);
        }
        translate([0,0,-4-2.5])
        rotate(90,[1,0,0]) {
            for( i=[-2:4:2 ])
            translate([i,0,0])
            #cylinder(d=1,h=10,center=true);
        }
            
    }

}



//!text("OpenSCAD");

/*
linear_extrude(	height=50 )
intersection() {
		circle(d=10);
		square(10);
}
*/


