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

module bBox(spec,e) {
    
    width=getProp(spec,"WIDTH");
    depth=getProp(spec,"DEPTH");;
    height=800;
    inner_w=width-2*W;
    
//    backplaneCenter=[0,depth-3,height/2+W-INSET]
    
    sidePos=-[width/2-W/2,-depth/2,-height/2];
    
    
    module element(piece) {
        
        difference() {
            union() {
                if(piece=="R" || piece=="A")
                translate(sidePos)
                cube([W,depth,height],center=true);
                if(piece=="L" || piece=="A")
                mirror([1,0,0])
                translate(sidePos)
                cube([W,depth,height],center=true);
                if(piece=="B" || piece=="A")
                translate([0,depth/2,W/2])
                cube([inner_w,depth,W],center=true);
                
  //              hull()
                translate([0,depth,height])
                    children(1);
            }
            
            
            translate([0,BACKSET,height/2+W-INSET])
            cube([inner_w+INSET*2,3,height],center=true);

            symX([width/2,depth,height])
                
                children(0);
            
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
//        translate([width/2,0*depth,0])
        element(e) {
            children(0);
            children(1);
        }
 //   element(e);
    
}

function abs(x) = x<0?-x:x;
function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );
//function prefix(p)=prefix(0,p);
//function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], [prefix(s+p[0],sublist(p,1))] );
//function prefix(s,p)=(p.length==0)?[]:concat([s+p[0]],prefix(s+p[0],p[1:]));

module maximera(width,sizes,type,mode) {
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
//        echo(off);
    // holes
        if(type=="H") {
            for(x=C1)
                translate([0,-x,-off+50]) {
                rotate(90,[0,1,0])
                cylinder(d=HOLE_D,h=100,center=true);
            }
        }else{
            o_y=(type=="X" ? 0 : 500);
            color([0,1,0])
            translate([0,o_y,0]) {
                hull()
                symX([width/2,0,0])
                translate([-W/4-2,W/2+1,-off+size-size/2])
                cube([W/2,W,size-4],center=true);

                D=500;
                hull()
                symX([width/2-2*W,-D/2,-off+size/2])
                cube([W/2,D,size/2],center=true);
            }
            
//            cube(100);
            // front
        }
        
        
    }
}
module z() {
    children();
}

mode="A";
bBox([prop("WIDTH",600),prop("DEPTH",590)],mode) {
    sizes=[100,200];
    maximera(600,sizes,"H",mode);
    maximera(600,sizes,"S",mode);
}

