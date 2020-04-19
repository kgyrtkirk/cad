// downloaded from: htps://www.thingiverse.com/thing:4031757/files
// modified a bit
//
//  28byj-48 stepper motor from datasheet and measurements
//  Russ Hughes, russ@owt.com
//  Attribution 4.0 International (CC BY 4.0)
//

module stepper_28byj48(segments=32) {
	translate(-[0,8,0])
	stepper_28byj48_0(segments);
}

module stepper_28byj48_shaft(off) {
    difference() {
        cylinder(d=5+off, h=10+off);

        // shaft cutouts
        translate([1.5+off,-2.5,-0.1])
            cube([2,5,4.5+0.1]);

        translate([-2-1.5-off,-2.5,-0.1])
            cube([2,5,4.5+0.1]);
    }
}

module stepper_28byj48_0(segments=32) {
    $fn = segments;
    module mount_tabs() {
        difference() {
            hull() {
                translate([35/2,0,0])
                    cylinder(d=7, 0.8);

                translate([-35/2,0,0])
                    cylinder(d=7, 0.8);
            }
            translate([35/2,0,-0.1])
                cylinder(d=3.5, 0.8+0.2);

            translate([-35/2,0,-0.1])
                cylinder(d=3.5, 0.8+0.2);
        }
    }

    // main body
    color("Silver")
        cylinder(d=28, h =19, $fn=$fn*2);

    // wire cover
    color("DeepSkyBlue")
        translate([-14.6/2,-17,0])
            cube([14.6,5.8, 16.5]);

    color("Silver")
        mount_tabs();

    // shaft and flange
    translate([0,0,-1.5]) {
        // flange
        translate([0,8,0])
            color("Silver")
                cylinder(d=9,h =1.5);

        color("Goldenrod") {
            // shaft
            translate([0,8,-5]) {
                stepper_28byj48_shaft(0);
            }
        }
    }
}

stepper_28byj48();
