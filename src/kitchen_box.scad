use <syms.scad>

W=18;

function prop(k,v)=[k,v];
function sublist(l,start)=start<len(l) ? [for(i=[start:len(l)-1])  l[i]] : undef;
function getProp(props,k)= (props[0][0] == k) ? props[0][1] : (props == undef ? 
    undef : getProp(sublist(props,1), k)
);


INSET=10;
BACKSET=10;
BACKPLANE_W=1.6;
BACKPLANE_NUT_W=2;

module bBox(e) {
    
    $inner_w=$width-2*W;
    
//    backplaneCenter=[0,depth-3,height/2+W-INSET]
    
    sidePos=-[$width/2-W/2,-$depth/2,-$height/2];

    module element(piece) {
        
        difference() {
            union() {
                if(piece=="R" || piece=="A")
                translate(sidePos)
                cube([W,$depth,$height],center=true);
                if(piece=="L" || piece=="A")
                mirror([1,0,0])
                translate(sidePos)
                cube([W,$depth,$height],center=true);
                if(piece=="B" || piece=="A")
                translate([0,$depth/2,W/2])
                cube([$inner_w,$depth,W],center=true);
                
                if(piece=="A") {
                    $mode="PREVIEW";
                    translate([0,$depth,$height])
                        children();
                }
            }
            
            
            translate([0,BACKSET,$height/2+W-INSET])
            cube([$inner_w+INSET*2,3,$height],center=true);

            $mode="HOLES";
            symX([$width/2,$depth,$height])
                children();
            
        }
    }
    
    if(e=="L") 
        rotate(90,[0,1,0])
        translate(sidePos)
        element(e)
            children();
    if(e=="R") 
        rotate(-90,[0,1,0])
        translate(-sidePos)
        element(e)
            children();
    if(e=="B")
        translate([0,0,-W/2])
        element(e)
            children();
    if(e=="A")
        translate([$width/2,0*$depth,0])
        element(e)
            children();
 //   element(e);
    
}

function abs(x) = x<0?-x:x;
function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

module maximera(sizes) {
    HOLE_D=5;
    C0=[    20,
            32,
            224,
            224
    ];
    
    C1=prefix(0,C0);
    
    x=prefix(0,[for(i=sizes) abs(i)]);
    for(i=[0:len(sizes)-1]) {
        off=x[i];
        size=sizes[i];
        
        if($mode=="HOLES") {
            for(x=C1)
                translate([0,-x,-off+50]) {
                rotate(90,[0,1,0])
                cylinder(d=HOLE_D,h=100,center=true);
            }
        }else{
            D=$depth-40;
            o_y=($drawerState=="CLOSED" ? 0 : D-50);
            translate([0,o_y,0]) {
            color([0,1,0])
                hull()
                symX([$width/2,0,0])
                translate([-W/4-2,W/2+1,-off+size-size/2])
                cube([W/2,W,size-4],center=true);

            color([1,0,0])
                hull()
                symX([$width/2-2*W,-D/2,-off+size/2])
                cube([W/2,D,size-10],center=true);
            }
            
//            cube(100);
            // front
        }
        
        
    }
}


module m60(pos,sizes) {
    $width=600;
    $drawerState="CLOSED";
    translate(pos)
    translate([$width/2,$depth,0])
//    posNeg()
    m60_0(sizes);
}

FRONT_SP=2;


module posNeg() {
    difference() {
        union(){
            $positive=true;
            children();
        }
        union(){
            $positive=false;
            children();
        }
    }
}


module m60i(size) {
    echo(str("F-A_",size));
    $depth=D37;
    m60(    $internal=true, $fronts=false,[0,0,0],[size]);

    translate([0,0,0])
    children();
}



module m60a(size) {
    echo(str("F-A_",size));
    $depth=D37;
    m60([0,0,0],[size]);
    
    translate([0,0,-size])
    children();
}

module m60b(size) {
    echo(str("F-A_",size));
    $depth=D60;
    m60([0,0,0],[size]);
    
    translate([0,0,-size])
    children();
}

module m60_0(sizes) {
    HOLE_D=5;
    HANDLE_HW=128;
    HANDLE_Y=125/2;
    
    C0=[    20,
            32,
            224,
            224
    ];
    
    C1=prefix(0,C0);
    
    x=prefix(0,[for(i=sizes) abs(i)]);
    for(i=[0:len(sizes)-1]) {
        off=x[i];
        size=sizes[i];
        
            D=$depth-40;
        o_y=($drawerState=="CLOSED" ? 0 : D-50);
        translate([0,0,-off])
        
        if(!$positive) {
            for(x=C1)
                symX([$width/2,0,0])
                translate([0,-x,50]) {
                rotate(90,[0,1,0])
                cylinder(d=HOLE_D,h=100,center=true);
                    
                }
                if(!$internal)
            translate([0,o_y,0]) 
                rotate(90,[1,0,0]) {
                    dx=(3-FRONT_SP)/2;
                    H1=dx+39;
                    H2=dx+58;
                    H3=dx+117;
                    H4=dx+136;
                    J=533/2;
                    D=5;
                    
                    symX([J,H1,0])
                    cylinder($fn=16,d=D,h=3*W,center=true);
                    symX([J,H2,0])
                    cylinder($fn=16,d=D,h=3*W,center=true);
                    
                    if(size>200) {
                        symX([J,H3,0])
                        cylinder($fn=16,d=D,h=3*W,center=true);
                        symX([J,H4,0])
                        cylinder($fn=16,d=D,h=3*W,center=true);
                    }
                    
                    //x
                    symX([HANDLE_HW/2,size-HANDLE_Y,0])
                    cylinder($fn=16,d=D,h=3*W,center=true);
                    
                }
        }else{
            if($fronts)
            translate([0,o_y,0]) {
            color([0,1,0]) {
//                translate([-W/4-2,W/2+1,-off+size-size/2])
                translate([0,W/2+1,size/2])
                cube([$width-FRONT_SP,W,size-FRONT_SP],center=true);
                if(false)
                hull() {
                    OFF_L=0;//$thinL? W/2:0;
                    OFF_R=0;//$thinR? W/2:0;
                    symX([$width/2,0,0])
                    translate([-W/4-2,W/2+1,size-size/2])
                    cube([W/2,W,size-4],center=true);
                }
                
            }
            if($machines)
            color([1,0,0])
            hull()
            symX([HANDLE_HW/2,W+W,size-HANDLE_Y]) {
                cylinder($fn=16,d=3,h=W,center=true);
            }

            if($machines)
            color([1,0,0])
                hull()
                symX([$width/2-2*W,-D/2,size/2])
                cube([W/2,D,size-10],center=true);
            }
            
//            cube(100);
            // front
        }
        
        
    }
}


module z() {
    children();
}

D60=590;
D37=366;

mode="A";
bBox($width=600,$height=800,$depth=D37,mode) {
$fronts=true;
$machines=true;

    $drawerState="CLOSED";
    sizes=[125];
    posNeg()
    m60([-$width/2,-$depth,0],[125,125,800-250]);
}

