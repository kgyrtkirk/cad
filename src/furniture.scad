use <hulls.scad>
use <kitchen_box.scad>

function sublist(l,start)=start<len(l) ? [for(i=[start:len(l)-1])  l[i]] : undef;
function prefix(s,p)=(p==undef || len(p)==0)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

module posNeg() {
    $close="";
    $closeBack=false;
    $closeFront=false;
    $closeTop=false;
    $closeBottom=false;
    $closeLeft=false;
    $closeRight=false;

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
    if($part==undef || $part==name) {
        children();
    }
}


module ppp2(name,dims="") {
    if($positive)
        echo(name,dims);
    if($positive)
    if($part==undef || $part==name) {
        children();
    }
}



module plain(name,w0,h0,closeL,closeR,closeU,closeD) {
    a=2;
    x = closeL;
    y = closeD;
    w = w0 - x - closeR;
    h = h0 - y - closeU;
    translate([x,y,0]) {
        cube([w,h,$W]);
        color([1,0,0]) {
            if(closeL>0) {
                translate([-closeL,0,0])
                cube([closeL,h,$W]);
            }
            if(closeR>0) {
                translate([w,0,0])
                cube([closeR,h,$W]);
            }
            if(closeD>0) {
                translate([0,-closeD,0])
                cube([w,closeD,$W]);
            }
            if(closeU>0) {
                translate([0,h,0])
                cube([w,closeU,$W]);
            }
        }
    }
}

function toBool(v)=(v==undef? false : v );

module eXY(name, dX, dY) {
    ppp2(str(name,"XY"),str(dX,"x",dY))
    //    cube([dX,dY,$W]);
      plain(str(name,"XY"),dX,dY,cLookupR(),cLookupL(),cLookupF(),cLookupA());
//      plain(str(name,"XY"),dX,dY,toBool($closeRight),toBool($closeLeft),toBool($closeFront),toBool($closeBack));
}



function cLookup(s,key,value) = len(search(key, s))>0 ? value : 0;

function cLookup2(s,k1,v1,k2,v2) = cLookup(s,k1,v1) + cLookup(s,k2,v2);

function cLookupX(s, k1, k2) = cLookup2(s,k1,.4,k2,2);

function cLookupL() = cLookupX($close, "l", "L");
function cLookupR() = cLookupX($close, "r", "R");
function cLookupF() = cLookupX($close, "f", "F");
function cLookupA() = cLookupX($close, "b", "B");
function cLookupT() = cLookupX($close, "o", "O");
function cLookupB() = cLookupX($close, "u", "U");

module eYZ(name, dY, dZ) {
    ppp2(str(name,"YZ"),str(dY,"x",dZ)){
        rotate(90,[0,0,1])
        rotate(90,[1,0,0])
        plain(str(name,"YZ"),dY,dZ,cLookupA(),cLookupF(),cLookupT(),cLookupB());
//        plain(str(name,"YZ"),dY,dZ,toBool($closeBack),cLookupF(),toBool($closeTop),toBool($closeBottom));
//        cube([$W,dY,dZ]);
    }
}
module eXZ(name, dX, dZ) {
    ppp2(str(name,"XZ"),str(dZ,"x",dX))
        translate([0,$W,0])
        rotate(90,[1,0,0])
        plain(str(name,"XZ"),dX,dZ,cLookupR(),cLookupL(),cLookupT(),cLookupB());
//        plain(str(name,"XZ"),dX,dZ,toBool($closeRight),toBool($closeLeft),toBool($closeTop),toBool($closeBottom));
//        cube([dX,$W,dZ]);
}

module eXY2(name, dX, dY, dY2=undef) {
    dY2=dY2==undef ? dY:dY2;
    ppp(str(name,"XY"),str(dX,"x",dY))
        linear_extrude($W)
        polygon([[0,0],[dX,0],[dX,dY],[0,dY2]]);
//        cube([dX,dY2,$W]);
}


module eXYp(name, dims) {
//    dY2=dY2==undef ? dY:dY2;
    ppp(str(name,"-XY"))
        linear_extrude($W)
        polygon(dims);
//        cube([dX,dY2,$W]);
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
                translate($openDoors?[0,-W,0]:[0,0,0])
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

module doors(name,h,cnt=2,clips=[50,-50],glass=false,spacing=0) {
    
    
    translate([spacing>0?spacing:0,0,-h])
        doors0(str($name,name),$w-abs(spacing),h,$d,cnt,clips,glass);
    
    translate([0,0,-h])
        children();
    
}

module space(h) {
    translate([0,0,-h])
        children();
}

module cabinet(name,w,h,d,foot=0,fullBack=false,extraHL=0,extraHR=0) {
    dBack=fullBack?$W:0;

    $name=name;
    $w=w;
    $h=h+foot;
    $d=d-dBack;

    if(fullBack) {
        translate([0,-100])
        eXZ($closeLeft=true,$closeRight=true,$closeTop=true,$closeBottom=true,
            str(name,"-Fback"),w,h+foot);
    }else {
        if($positive) {
            bw=w-15;
            bh=h-15;
            color([1,0,0])
            translate([7.5,3,foot+7.5])
            cube([bw,1,bh]);
            echo(str(name,"-back"),str(bh,"x",bw));
        }
    }

    translate([0,dBack,0]) {
        {
            $closeTop=true;
            $closeBottom=true;
            $closeFront=true;
            eYZ(name,$d,h+foot+extraHR);
            translate([w-$W,0,0])
            eYZ(name,$d,h+foot+extraHL);
            
            
            if(foot>0) {
                translate([$W,d-2*$W,0])
                eXZ(name,w-2*$W,foot);
            }
            
            translate([$W,0,foot])
            eXY(name,w-2*$W,$d);
        }

        translate([0,0,$h])
        children();
    }
}


// width in dims are inner
module cabinet2(name,w,h,dims) {
    
    $name=name;
    $h=h;
    
    widths=[ for(x=dims) x[0] ];
    depths=[ for(x=dims) x[1] ];
    x=prefix(-$W,widths + [ for(i=widths) $W]);
    n=len(x)-1;

    echo(widths);
    echo(depths);
    echo(x);
    echo(n);
    

//    $w=w;   // FIXME
//    $d=d;   // FIXME
    
    eYZ(str(name,0),depths[0],h);
    translate([x[n],0,0])
    eYZ(str(name,n),depths[n],h);
    
    for(i=[0:n]) {
        inner=(0<i && i<n);
        off=inner?$W:0;
        translate([x[i],0,off])
        eYZ(str(name,i),depths[i],h-2*off);
    }
    
    for(z=[0,h-$W])
        translate([0,0,z])
    eXYp(
        str(name,"t"),
            [
                [$W,0],
                for(i=[1:2*n]) 
                    if(i%2 == 0)
                        [x[i/2],depths[i/2]]
                    else
                        [x[i/2]+$W,depths[i/2]],
                [x[n],0]
            ]
    );
    
    for(idx=[1:n]) {
        $d=depths[idx-1];
        $w=widths[idx];
        translate([x[idx-1]+$W,0,0])
        children(idx);
    }
    if(false){ 
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
}


module orient(mode) {
    if(mode[2]=="X" && mode[3] =="Y") {
        children();
    } else if(mode[2]=="X" && mode[3] =="Z") {
        rotate(99,[0,1,0])
        children();
    } else if(mode[2]=="Y" && mode[3] =="Z") {
        rotate(180,[0,0,1])
        rotate(90,[0,1,0])
        children();
    } else {
        error("x");
    }
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

//        translate([0,100,0])
        translate([x-$W,0,-h+$W])
        translate([0,BACK_WIDTH,0])
        eYZ(str($name,"partA",x),$d-BACK_WIDTH,h-$W-$W);

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

module frame(name, w, l, h) {
    eYZ(str(name,"-F"),w+2*$W,h);
    
    translate([l+$W,0,0])
    eYZ(str(name,"-F"),w+2*$W,h);
    
    translate([$W,0,0])
    eXZ(str(name,"-S"),l,h);
    translate([$W,w+$W,0])
    eXZ(str(name,"-S"),l,h);
    
    
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

    
module shelf(h,SHELF_INSET=12,external=false,alignTop=false) {

    BACK_WIDTH=4;
    
    depth=$d-BACK_WIDTH-(external?0:SHELF_INSET);
    w=$w-2*$W;
    color([0,1,1])
    translate([$W,BACK_WIDTH,-h-(alignTop?$W:0)])
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


module hanger(h) {

    BACK_WIDTH=4;
    
    depth=$d-BACK_WIDTH;
    
    if($machines) {
        color([0,1,0])
        translate([0,depth/2,-h])
            cube([$w,10,20]);
    }
    
    children();
}


module drawer(h) {
    
    name=str($name,"d");
    
    FRONT_SP=2;

    ww=$w-FRONT_SP;
    hh=h-FRONT_SP;
    
    qx=$W+12.7;
    qz=2*$W;
    
    ix=$w-2*qx;
    iz=h-2*qz;
    id=$d-10;
    
    o_y=($drawerState=="CLOSED" ? 0 : id-50);
    
    translate([0,$d+o_y,-h])
    if($positive) {
        
        echo("__FRONT", ww, hh);

        if($fronts) {            
            color([0,1,1]){
                translate([FRONT_SP/2,0,FRONT_SP/2])
                eXZ("DF",ww,hh);
//                translate([$w/2,$d,-h/2])
  //                cube([ww,$W,hh],center=true);
            }
//                translate([0,$d,-h+$W])
  //          eXZ("DF",ww,hh);
        }
        if($drawerBoxes) {
        translate([qx,-$W,qz])
        eXZ(str(name,"A"),ix,iz);
        translate([qx,-id,qz])
        eXZ(str(name,"A"),ix,iz);

        translate([qx,-id+$W,qz])
        eYZ(str(name,"B"),id-2*$W,iz);
//        color([0,1,0])
        translate([$w-$W-qx,-id+$W,qz])
        eYZ(str(name,"B"),id-2*$W,iz);
        
//        color([1,0,0])
        translate([qx,-id,qz-3])
        cube([ix,id,3]);
        echo(str(name,"Fl"),str(ix,"x",id));
        }
        
        
    }
    
    translate([0,0,-h])
        children();
    
}


//mode="zigzag";
mode="zigzag";

function substr(data, i, length=0) = (length == 0) ? _substr(data, i, len(data)) : _substr(data, i, length+i);
function _substr(str, i, j, out="") = (i==j) ? out : str(str[i], _substr(str, i+1, j, out));

//function substr(s,n)= [ for(i=[n:len(s)-1] ) s[i] ];

if(mode[0] == "P" && mode[1]=="-") {
    $fronts=false;
    $machines=false;
    
    $part=substr(mode,5);
//    $part=str([ for(i=[5:len(mode)-1] ) mode[i] ]);
    
    projection(false)
    orient(mode)
    zigzag();
    echo(mode,$part);
}

module zigzag(){
//    module cabinet(name,w,h,d,foot=0) {
    
    posNeg()
    cabinet2( name = "C",    $closeFront=true,$closeLeft=true,$close="f",
        h= 400,
        dims=[ [0,500] , [ 300,500 ] , [400,200] ]) {
            
        doors("D1",300);
        doors("d2",200);
        doors("D3",300);
            
    }
}

if(mode=="zigzag") {
    $W=18;
    $part=undef;
    $fronts=true;
    $openDoors=true;

//mode="P-XY-Ct-XY";
    zigzag();
}


