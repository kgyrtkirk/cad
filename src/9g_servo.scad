//9g_motor();

//function    

function servo_9g_dim() =     [12.5,15.5,23+1];
function servo_9g_hole_off()=(27.4-servo_9g_dim()[2])/2;
function servo_9g_pin_off() = [23/2,12.5/2*0,22/2]+[5.5,0,3.65];

module 9g_motor(){
	translate([23/2,12.5/2*0,22/2])
//	translate([23/2,12.5/2,22/2])
	difference(){			
		union(){
			color("lightblue") cube([23,12.5,22], center=true);
			color("lightblue") translate([0,0,5]) cube([32,12,2], center=true);
			color("lightblue") translate([5.5,0,2.75]) cylinder(r=6, h=25.75, $fn=20, center=true);
			color("lightblue") translate([-.5,0,2.75]) cylinder(r=1, h=25.75, $fn=20, center=true);
			color("lightblue") translate([-1,0,2.75]) cube([5,5.6,24.5], center=true);		
			color("white") translate([5.5,0,3.65]) cylinder(r=2.35, h=29.25, $fn=20, center=true);		
          translate([10,0,-10+4.7])  
            color("red") cube([10,5,2],center=true);
		}
		translate([10,0,-11]) rotate([0,-30,0]) cube([8,13,4], center=true);
		for ( hole = [14,-14] ){
			translate([hole,0,5]) cylinder(r=2.2, h=4, $fn=20, center=true);
		}
	}
}

9g_motor();