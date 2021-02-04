use <hulls.scad>
use <kitchen_box.scad>

function sublist(l,start)=start<len(l) ? [for(i=[start:len(l)-1])  l[i]] : undef;
function prefix(s,p)=(len(p)==0 || p==undef)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

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

module ppp(name,dims="") {
    if($positive)
        echo(name,dims);
    if($positive)
    if($part==undef || $part==name) 
        children();
}


module eXY(name, dX, dY) {
    ppp(str(name,"-XY"),str(dX,"x",dY))
        cube([dX,dY,$W]);
}

module eYZ(name, dY, dZ) {
    ppp(str(name,"-YZ"),str(dY,"x",dZ))
        cube([$W,dY,dZ]);
}
module eXZ(name, dX, dZ) {
    ppp(str(name,"XZ"),str(dZ,"x",dX))
        cube([dX,$W,dZ]);
}


use <syms.scad>

module hinges(name,ww,hh) {
    assert(ww<600,str("wider door hinge count calc missing"," ",name," ",ww));

    echo("__HINGE",name,2);
}

module doors0(name,w,h,d,cnt=2,clips=[50,-50],glass=false) {
    W=$W;
    module cube1(dim,glass) {
        difference() {
            E=2*80;
            cube(dim,center=true);
            if(glass)
            cube(dim+[-E,1,-E],center=true);
        }
    }
    FRONT_SP=2;
    
    cL=[w/4,W/2,h/2];
    cR=cL+[w/2,0,0];
    translate([0,d,0])
    if($positive) {
        
        doorLabel=glass?"__GLASSDOOR: ":"__DOOR: ";
        
        if($fronts)
            
        color([0,1,1]){
            if(cnt==2) {
                ww=w/2-FRONT_SP;
                hh=h-FRONT_SP;
                hinges(name,ww,hh);
                hinges(name,ww,hh);
                rotate($openDoors?90:0)
                translate(cL)
                cube1([ww,W,hh],glass);
                translate(cR)
                cube1([ww,W,hh],glass);
                echo(doorLabel,name,ww,hh);
                echo(doorLabel,name,ww,hh);
            }else{
                ww=w-FRONT_SP;
                hh=h-FRONT_SP;
                hinges(name,ww,hh);
                rotate($openDoors?90:0)
                translate((cL+cR)/2)
                cube1([ww,W,hh],glass);
                echo(doorLabel,name,ww,hh);
            }
        }
    }else{
        
            C0=[    20,
                    32,
            ];
            
            C1=prefix(0,C0);
        
        HOLE_D=5;
        for(y0 =clips) {
            y=(y0<0) ? y0+h  : y0;
        translate([w/2,0,0])
            for(x=C1)
                symX([w/2-W/2,0,0])
                translate([0,-x,y]) {
                rotate(90,[0,1,0])
                cylinder(d=HOLE_D,h=W+.1,center=true);
                    
                }
            }
        
        
    }
}

module doors(name,h,cnt=2,clips=[50,-50],glass=false) {
    
    translate([0,0,-h])
        doors0(str($name,name),$w,h,$d,cnt,clips,glass);
    
    translate([0,0,-h])
        children();
    
}

module space(h) {
    translate([0,0,-h])
        children();
}

module cabinet(name,w,h,d,foot=0) {
    $name=name;
    $w=w;
    $h=h+foot;
    $d=d;
    
    eYZ(name,d,h+foot);
    translate([w-$W,0,0])
    eYZ(name,d,h+foot);
    
    if(foot>0) {
        translate([0,d-2*$W,0])
        eXZ(name,w,foot);
    }
    
    translate([$W,0,foot])
    eXY(name,w-2*$W,d);
    
    if($positive) {
        bw=w-15;
        bh=h-15;
        color([1,0,0])
        translate([7.5,3,foot+7.5])
        cube([bw,1,bh]);
        echo(str(name,"-back"),str(bh,"x",bw));
    }
    
    translate([0,0,$h])
    children();
}

module cBeams() {
    W=$W;
    translate([W,0,-W])
    eXY(str($name,"-beam"),$w-2*W,100);
    translate([W,$d-100,-W])
    eXY(str($name,"-beam"),$w-2*W,100);
    children();
}
module partition2(x,h) {

    BACK_WIDTH=4;

        translate([x-$W,0,-h+$W])
        translate([0,BACK_WIDTH,0])
        eYZ(str($name,"partA",x),$d-BACK_WIDTH,h-$W);

    $oldw=$w;
    {
        $w=x;
        children(0);
    }
    translate([x-$W,0,0]) {
        $w=$oldw-x+$W;
        children(1);
    }

    if($children > 2) {
        $w=$oldw;
        translate([0,0,-h])
        children(2);
    }
}

module partitionBeams(x,fullH) {
    
    beamH=$h-2*$W - fullH;
    BACK_WIDTH=4;

    
    D=100;
    if(beamH>0)
    translate([x-D/2,D,-$W])
    eXY(str($name,"partC",x),D,$d-BACK_WIDTH-2*D);
    
    translate([x-$W,0,-$h+$W]) {
        translate([0,BACK_WIDTH,0])
        eYZ(str($name,"partA",x),$d-BACK_WIDTH,fullH);

        translate([0,0,fullH]) 
        color([0,0,1]) {
            if(beamH>0)
            translate([0,0,0])
            eYZ(str($name,"partB",x),D,beamH);
            
            if(beamH>0)
            translate([0,$d-D,0])
            eYZ(str($name,"partB",x),D,beamH);
        }
    }
    
    $oldw=$w;
    {
        $w=x;
        children(0);
    }
    translate([x-$W,0,0]) {
        $w=$oldw-x+$W;
        children(1);
    }
}


module             slideDoors() {

    $oldd=$d;
    {
        $d=$oldd-$W;
        children();
    }
}

module cTop() {
    W=$W;
    translate([W,0,-W])
    eXY(str($name,"cb"),$w-2*W,$d);
    children();
}


module m60_0(sizes) {
    FRONT_SP=2;
    HOLE_D=5;
    W=$W;
    HANDLE_HW=128;
    HANDLE_Y=125/2;
    
    C0=[    20,
            17,
            32-17,
            224-32,
            17,
            32-17,
            224
    ];
    
    C1=prefix(0,C0);
//    echo("C1",C1);
    
    x=prefix(0,[for(i=sizes) abs(i)]);
    for(i=[0:len(sizes)-1]) {
        off=x[i];
        size=sizes[i];
        
            D=$d-40;
        o_y=($drawerState=="CLOSED" ? 0 : D-50);
        translate([0,0,-off])
        
        if(!$positive) {
            for(x=C1)
                symX([$w/2,0,0])
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
                cube([$w-FRONT_SP,W,size-FRONT_SP],center=true);
                if(false)
                hull() {
                    OFF_L=0;//$thinL? W/2:0;
                    OFF_R=0;//$thinR? W/2:0;
                    symX([$w/2,0,0])
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
                symX([$w/2-2*W,-D/2,size/2])
                cube([W/2,D,size-10],center=true);
            }
            
        }
    }
}

    
module shelf(h,SHELF_INSET=12,external=false) {

    BACK_WIDTH=4;
    
    depth=$d-BACK_WIDTH-(external?0:SHELF_INSET);
    w=$w-2*$W;
    color([0,1,1])
    translate([$W,BACK_WIDTH,-h])
    eXY(str($name,"-S",external?"-EX":"-IN",w),w,depth);
    
    translate([0,0,external?-h:0])
    children();
}

module maximera1(h) {
    assert(len(search($w,[600,800]))>0,str("not supported maximera width:",$w));
//    cube(1000);
    
    if($positive)
    echo("__DOOR ","maximera",$w-2,h-2);

    
    translate([$w/2,$d,0])
    m60_0([h]);
    translate([0,0,-h])
        children();
}



