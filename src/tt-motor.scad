
// copied from: https://www.thingiverse.com/thing:2832714/files
// and then modified...

module at_tt_motor_mount_holes() {
rotate(-90,[1,0,0])
//    translate([0,0,-8.3]) 
  for(p=[(20.2-3)/2,-(20.2-3)/2])
    translate([-20.5,p,0])
        children();

}

function ttMotorH() = 22.5;
function ttMotorHoleO() = -20.5;
function ttMotorNippleO() = -11;

module tt_motor_scad(backmount=true){
   $fn=32;
    off=backmount?20:0;
 
  color([0,1,0])
rotate(-90,[1,0,0])
    translate([0,0,-8.3-off]) {
  //#tt_motor();
  translate([-48/2+11.9,0,8.7+(18.5+1)/2]) {
     cube([48,22.5,18.5+1],center=true);
      MH=16;
    translate([-48/2-MH/2,0,0]) 
      rotate(90,[0,1,0])
      cylinder(h=MH,d=20,center=true);
  }
//     Cube636(48,22.5,18.5+1,r=1.3,rz=2);
    
  cylinder(d=6,h=11);
  translate([0,0,8.3])
     cylinder(d=7.6,h=11);
    
  // nipple
  
  translate([-11,0,6.5+off])
     cylinder(d=4.2,h=4);
    
  translate([-31,0,6.5])
    translate([0,0,2])
     cube([8,13,4],center=true);
  translate([-31,0,6.5+18.5+2])
    translate([0,0,2])
     cube([8,13,4],center=true);
    
  translate([14,0,6.5+18.5/2])
    translate([0,0,5/2])
     cube([5.5,7,5],center=true);  
   
}
  //mounthole
  at_tt_motor_mount_holes() 
    cylinder(d=2.9,h=22);  
}

tt_motor_scad();