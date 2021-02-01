// original source: https://www.thingiverse.com/thing:1401060



holder_radius = 46;
holder_thickness = 1.2;
W=1.2;
holder_height = 30;
tube_bottom_thickness = 1;
pen_count = 16;
pen_radius = 4.5;
pen_length = 150;
rotx = 30;
rotz = -60;

$fn=64;


{ // pen model for editor preview
    for (a=[1:360/pen_count:360]) {
        rotate([0,0,a])
        translate([holder_radius,0,0])
        rotate([rotx,0,rotz])
        %cylinder(h=pen_length, r = pen_radius);
    }
}

//intermediate variables
r = pen_radius+holder_thickness;
bot_shift = tan(rotx)*r;
cutoff_h = 2*sin(rotx)*r;
//cylinder_length = cutoff_h*2 + holder_height;
cylinder_length = 2*tan(rotx)*r + 1/cos(rotx)*holder_height;
cutoff_r = cylinder_length + holder_radius + r; //upper bound of each var

module p(a){
          rotate([0,0,a]) 
      translate([holder_radius,0,0])
      rotate([rotx,0,rotz])
      translate([0,0,-bot_shift]) 
    children();

}

difference() {
  { //material part of the tubes
      union() {
            for (a=[1:360/pen_count:360]) {
                p(a)
                cylinder(h=cylinder_length, r = pen_radius + holder_thickness);
            }
            if(false)
            for (a=[1:360/pen_count:360]) {
                hull() {
                    p(a)
                    rotate(45)
                    cube([W,W,cylinder_length]);
                    p(a+360/pen_count)
                    rotate(45)
                    cube([W,W,cylinder_length]);
                }
            }
            A=holder_radius;
            B=A+W-16;
            rotate_extrude($fn=128)
            polygon([[A,0],[A+W,0],[B+W,holder_height],[B,holder_height]]);
        
        }
    
  }
  difference() {
    {//hole part of the tubes
      for (a=[1:360/pen_count:360]) {
        rotate([0,0,a])
        translate([holder_radius,0,0])
        rotate([rotx, 0, rotz])
        translate([0,0,-bot_shift])
        cylinder(h=cylinder_length, r = pen_radius);
      }
    }
    //stop drilling that hole before hitting the bottom
    cylinder(h=tube_bottom_thickness, r=cutoff_r);
  }
  //cut out the bottom
  translate([0,0,-cutoff_h])
  cylinder(h=cutoff_h, r = cutoff_r);
  //cut out the top
  translate([0,0,holder_height])
  cylinder(h=cutoff_h, r = cutoff_r);
  
  
}
