

module atLeftWall(x) {
    translate();
}

module walls() {
    WALL_THICK=50;
    WALL_H=2630;
    HW_H=1000;
    HW_WIDTH=2000;
    FWL_WIDTH=600;
    
    module fullWall(WIDTH) {
        cube([WALL_THICK,WIDTH,WALL_H]);
    }
    module halfWall(WIDTH) {
        cube([WALL_THICK,WIDTH,HW_H]);
    }

    
    rotate(-90) {
        translate([0,FWL_WIDTH,0])
        halfWall(HW_WIDTH);
        fullWall(FWL_WIDTH);
    }
    
}



function prop(k,v)=[k,v];
function sublist(l,start)=start<len(l) ? [for(i=[start:len(l)-1])  l[i]] : undef;
function getProp(props,k)= (props[0][0] == k) ? props[0][1] : (props == undef ? 
    undef : getProp(sublist(props,1), k)
    );

mode="preview";
//walls();
module bBox(spec) {
    
    x=getProp(spec,"aa");
    echo(x);
//    prop
    DEPTH=598;
    W=19;
    cube();
}


bBox([prop("a",1),prop("x",2)]);
//echo(sublist([prop("a",1)],0));

if(mode=="projtest") {
    projection() {
        difference() {
            cube([20,20,10],center=true);
            cylinder(d=10,h=20,center=true);
        }
    }
}