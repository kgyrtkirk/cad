

module attachment(type="plug",extraL=0) {
    dim_x=10;
    dim_y=5;
    dim_z=2;
    e=.1;
    plug_z=dim_z+2;
    W=1.2;
    plug_w=1.2;
    plug_mid=dim_z+2*e;
    
    module pole(){
        translate([plug_w,0,extraL])
        rotate(90,[1,0,0])
        color([0,1,0]){
            linear_extrude(height=dim_y-2*W-e,  slices=20, twist=0,center=true)
          polygon(points=[[0,-extraL],[0,plug_mid],[plug_w,plug_mid],
                    [plug_w,plug_z+e],
                    [-plug_w,plug_z+e],
                    [-plug_w,-extraL]
                ]);
            }
    }

    if(type == "plug"){
        k=dim_x/2-W-e-plug_w;
        translate([k,0,0])
        pole();
        translate([-k,0,0])
        rotate(180,[0,0,1])
        pole();
    }else{
        color([1.0,0,0])
        translate([0,0,dim_z/2])
        difference() {
            cube([dim_x,dim_y,dim_z],center=true);
            cube([dim_x-2*W,dim_y-2*W,dim_z*2],center=true);
        }
    }
    
}

//attach_O();
//a=2;

module testAttach() {
translate([0,0,1])
cube([10,4,2],center=true);
translate([0,0,2])
attachment("plug",0);

translate([0,5,0])
attachment(2);
translate([0,-5,0])
attachment(2);
}

testAttach();