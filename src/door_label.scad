use<syms.scad>;
$fn=64;

module theNumber() {
    text("9",
    size=30,
    font="Times",
    halign="center",valign="center");

}


module doorLabel(){

    color("black")
    linear_extrude(height=3)
    text("Haindrich",
        size=10,
        font="DejaVu Sans:style:Bold",
        halign="center",valign="center");

    /*color("orange")
    linear_extrude(height=3) 
    theNumber();
    */
    module base(){
        offset(r=5) {
            theNumber();
            hull()
            symX([35,0,0])
            circle(d=10);
        }
    }

    color("white")
    linear_extrude(height=2)
    difference(){
    offset(r=-2)
    base();
    theNumber();
    }

    color("orange")
    linear_extrude(height=1) 
    difference(){
        offset(r=-1)
        base();
    }
}

s=2;
scale([s,s,.9])
doorLabel();


