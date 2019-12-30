use<syms.scad>;
$fn=64;

module theNumber() {
    text("9",
    size=30,
    font="Times",
    halign="center",valign="center");

}


color("black")
linear_extrude(height=4)
text("Haindrich",
    size=10,
    font="DejaVu Sans:style:Bold",
    halign="center",valign="center");

color("orange")
linear_extrude(height=3) 
theNumber();

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
offset(r=-2)
base();

color("orange")
linear_extrude(height=3) 
difference(){
    offset(r=-1)
    base();
    offset(r=-2)
    base();
}