use <hulls.scad>
use <kitchen_box.scad>

JOINT_LEN=80;
function sublist(l,start)=start<len(l) ? [for(i=[start:len(l)-1])  l[i]] : undef;
function prefix(s,p)=(p==undef || len(p)==0)?[]:concat([s+p[0]], prefix(s+p[0],sublist(p,1)) );

module posNeg() {
    $front=false;
    $close="";
    $handle="";

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

function isProjection() = $part != undef;

module ppp(name,dims="") {
    if($positive)
        echo(str("custom PLANAR?-", elementTypeName(), ": ", name),dims);
    if($positive)
    if($part==undef || $part==name) {
        children();
    }
}


module ppp2(name,dims="") {
    if($positive)
    if($part==undef || $part==name) {
        children();
    }
}



module closeColor(v) {
    if(v>0.4)
    {
        if(v>1.1)
            color([1,.5,0])
            children();
        else
            color([0,.5,0])
            children();
    }
    else
        color([1,0,0])
    children();
        
}

function elementTypeName() = ($W<5)?"BACK":($front?"FRONT":str("M",$W));

// </> change connect orientation to left right

module makeContact(len,mode) {
      if(mode == "" || mode == undef) {
        
      }
 else if(mode[0] == "<" || mode[0] == ">") {

        m=substr(mode,1);
//        cube(10);
        if(mode[0]=="<") 
        rotate(90,[1,0,0])
        translate([0,0,-$W]) {
        jointsX(len, m);
    }
        else 
//        translate([0,$W,18]) 
        rotate(-90,[1,0,0])
    translate([0,-$W,0]) {
        jointsX(len, m);
    }

}else {

translate([0,-$W,0]) 
    jointsX(len, mode);
  }
}

function mapGet(arr, key) = search(key, arr) != [] ? arr[search(key, arr)[0]][1] : undef;

function drawPositive(n) = $positive && ($part == undef || $part == n);

module plain(name,w0,h0,closeL,closeR,closeU,closeD,rot=false) {
    if(!rot) {
        translate([0,h0,0])
        rotate(-90)
        plain(name,h0,w0,closeU,closeD,closeR,closeL,rot=!rot);
    } else  if($connect!=undef) {
        modeL=mapGet($connect, "r");
        modeR=mapGet($connect, "l");
        modeU=mapGet($connect, "f");
        modeD=mapGet($connect, "b");
        makeContact(w0,modeL);
        translate([0,h0,0]) 
        mirror([0,1,0]) 
        makeContact(w0,modeR);

        translate([0,h0,0]) 
        rotate(-90, [0,0,1]) 
        makeContact(h0,modeU);

        translate([w0,0,0]) 
        rotate(90, [0,0,1]) 
        makeContact(h0,modeD);
        plain(name,w0,h0,closeL,closeR,closeU,closeD,rot,$connect=undef);
    }else 
    if(true && $part == name && $W>1) {
        // drill plan for selected part is evaluated at the center
        // not perfect ; but something
        W0=$W;
        W1=.1;
        $W=W1;
        translate([0,0,18/2-W1/2])
        plain(name,w0,h0,0,0,0,0,rot);
    }else  {



    a=2;
    x = closeL;
    y = closeD;
    w = w0 - x - closeR;
    h = h0 - y - closeU;
    if(drawPositive(name)) 
    translate([x,y,0]) {
        color($front?[.4,.6,1]:[1,.8,.4])
        cube([w,h,$W]);
        //color([1,0,0]) 
        {
            E=.1;
            if(closeL>0) {
                closeColor(closeL)
                translate([-closeL,0,0])
                cube([closeL-E,h,$W]);
            }
            if(closeR>0) {
                closeColor(closeR)
                translate([w+E,0,0])
                cube([closeR-E,h,$W]);
            }
            if(closeD>0) {
                closeColor(closeD)
                translate([0,-closeD,0])
                cube([w,closeD-E,$W]);
            }
            if(closeU>0) {
                closeColor(closeU)
                translate([0,h+E,0])
                cube([w,closeU-E,$W]);
            }
            color([0,0,1]) 
            translate([0,h/2-$W/2,-1])
            cube([w,$W,$W+2]);
        }
    }
    
        if($positive) {
            s=elementTypeName();
            echo(str("PLANAR: ",s," ",name, " ", w,"*", h, " ",
            closeD,";",closeU,";",
            closeL,";",closeR
            ));
        }
    }
}

function toBool(v)=(v==undef? false : v );

module eXY(name, dX, dY, rot=false) {
//    ppp2(str(name,"XY"),str(dX,"x",dY))
    //  cube([dX,dY,$W]);
      plain(str(name,"XY"),dX,dY,cLookupR(),cLookupL(),cLookupF(),cLookupA(),rot=rot);
//      plain(str(name,"XY"),dX,dY,toBool($closeRight),toBool($closeLeft),toBool($closeFront),toBool($closeBack));
}



function cLookup(s,key,value) = len(search(key, s))>0 ? value : 0;

function cLookup2(s,k1,v1,k2,v2) = cLookup(s,k1,v1) + cLookup(s,k2,v2);
function cLookup3(s,k1,v1,k2,v2,k3,v3) = cLookup(s,k1,v1) + cLookup(s,k2,v2) + cLookup(s,k3,v3);

function cWidth1() = $front ? $closeWFront[0] : $closeWMain[0];
function cWidth2() = $front ? $closeWFront[1] : $closeWMain[1];


function cLookupX(s, k1, k2) = cLookup2(s,k1,cWidth1(),k2,cWidth2());

function cLookupL() = cLookupX($close, "l", "L");
function cLookupR() = cLookupX($close, "r", "R");
function cLookupF() = cLookupX($close, "f", "F");
function cLookupA() = cLookupX($close, "b", "B");
function cLookupT() = cLookupX($close, "o", "O");
function cLookupB() = cLookupX($close, "u", "U");

module eYZ(name, dY, dZ, rot=false) {
    //ppp2(str(name,"YZ"),str(dY,"x",dZ))
    {
        rotate(90,[0,0,1])
        rotate(90,[1,0,0])
        plain(str(name,"YZ"),dY,dZ,cLookupA(),cLookupF(),cLookupT(),cLookupB(),rot=rot);
//        plain(str(name,"YZ"),dY,dZ,toBool($closeBack),cLookupF(),toBool($closeTop),toBool($closeBottom));
//        cube([$W,dY,dZ]);
    }
}

module eFRONT(name, dX, dZ, rot=false) {
    O=26;
    if($handle=="top") {
        if($positive) {
            translate([0,0,dZ-O])
            %cube([dX,$W,O]);
        }

        translate([0,0,0])
        eXZ($close="oULR",name,dX,dZ-O,rot);
    } else {
        eXZ($close="OULR",name,dX,dZ,rot);
    }
}

module eXZ(name, dX, dZ, rot=false) {
//    ppp2(str(name,"XZ"),str(dZ,"x",dX))
        translate([0,0,dZ])
        rotate(-90,[1,0,0])
        plain(str(name,"XZ"),dX,dZ,cLookupR(),cLookupL(),cLookupB(),cLookupT(),rot=rot);
}

module eXY2(name, dX, dY, dY2=undef) {
    dY2=dY2==undef ? dY:dY2;
    ppp(str(name,"XY"),str(dX,"x",dY))
        linear_extrude($W)
        polygon([[0,0],[dX,0],[dX,dY],[0,dY2]]);
//        cube([dX,dY2,$W]);
}


module mlinear_extrude(w) {
    if($part == undef) {
        linear_extrude($W)
            children();
    } else {
        W1=.01;
        translate([0,0,($W-W1)/2]) 
        linear_extrude(W1)
            children();
    }
}


module eXYp(name, dims) {
//    dY2=dY2==undef ? dY:dY2;
    ppp(str(name,"XY"),dims)
        mlinear_extrude($W)
        polygon(dims);
//        cube([dX,dY2,$W]);
}


module eYZp(name, dims) {
    ppp(str(name,"YZ"),dims)
        rotate(90,[0,0,1])
        rotate(90,[1,0,0])
        mlinear_extrude($W)
        polygon(dims);
//        cube([dX,dY2,$W]);
}

module eXZp(name, dims) {
    ppp(str(name,"XZ"),dims)
        rotate(-90,[1,0,0])
        mlinear_extrude($W)
        polygon(dims);
//        cube([dX,dY2,$W]);
}


use <syms.scad>

module hinges(name,ww,hh) {
    assert(ww<750,str("wider door hinge count calc missing"," ",name," ",ww));

    echo("__HINGE",name,2);
}

module doors0(name,w,h,d,cnt=2,clips=[50,-50],glass=false) {
    W=$W;
    module cube1(dim,glass) {
        if(glass) {
            difference() {
                E=2*80;
                cube(dim,center=true);
                if(glass)
                cube(dim+[-E,1,-E],center=true);
            }
        }else{
            translate(-dim/2)
            eFRONT($front=true,$close="LROU",str($name,"Door"),dim[0],dim[2]);
        }
    }
    FRONT_SP=2;
    
    cL=[w/4,W/2,h/2];
    cR=cL+[w/2,0,0];
    translate([0,d,0])
    if($positive) {
        doorLabel=glass?"__GLASSDOOR: ":"__DOOR: ";
        
        if($fronts)
            
        //color([0,1,1])
        {
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


    if($d != undef) {
        translate([spacing>0?spacing:0,$d,-h])
            doors0(str($name,name),$w-abs(spacing),h,0,cnt,clips,glass);
    }else {

        dL = ($d == undef) ? $dL : $d;
        dR = ($d == undef) ? $dR : $d;

        a=atan2($dR-$dL,$w);
        w=$w/cos(a);
        echo("TAN",tan(a))


        translate([spacing>0?spacing:0,dL,-h])
        rotate(a,[0,0,1])
            doors0(str($name,name),w-abs(spacing),h,0,cnt,clips,glass);

    }
    

    translate([0,0,-h])
        children();
    
}

module space(h) {
    translate([0,0,-h])
        children();
}


module cutCornerShelf(name,w,d,cR=0,cL=0,rot=false,type="straight") {

    n2=cL>0?str(name, "L",cL):name;
    n3=cR>0?str(n2, "R",cR):n2;
    eXY(n3,w,d,rot=rot);
    if(!$positive) {
        
        if(type == "straight") {
            if(cR>0) {
                //echo("cutCronerShelfR ",name," dc ",cR);
                s=cR*sqrt(2);
                translate([0,d,$W/2])
                rotate(45)
                cube([s,s,$W+.1],center=true);
            }
            if(cL>0) {
                //echo("cutCronerShelfL ",name," dc ",cL);
                s=cL*sqrt(2);
                translate([w,d,$W/2])
                rotate(-45)
                cube([s*2,s,$W+.1],center=true);
            }
        }else if(type=="round") {
            if(cR>0) {
                r=cR;
                // echo("cutCronerShelfR ",name," dc ",cR);
                translate([0,d,$W/2]) {
                    difference() {
                        translate([r/2,-r/2])
                        cube([r+.1,r+.1,$W+.1],center=true);
                        translate([r,-r])
                        cylinder($fn=64,r=r,h=$W+.2,center=true);
                    }
                }

                // rotate(45)
                // cube([s*2,s,$W+.1],center=true);
            }
            if(cL>0) {
                r=cL;
                //echo("roundCornerShelfL ",name," dc ",cL);
                translate([w,d,$W/2]) {
                    difference() {
                        translate([-r/2,-r/2])
                        cube([r+.1,r+.1,$W+.1],center=true);
                        translate([-r,-r])
                        cylinder($fn=64,r=r,h=$W+.2,center=true);
                    }
                }
//                rotate(-45)
//                cube([s*2,s,$W+.1],center=true);
            }
        } else {
            assert(false,"unknown cornertype");
        }
    }
}

module cutCornerShelf0(name,w,d,c) {
    eXY(name,w,d);
}

function internalOff(back) = is_list(back) && back[0]=="internal" ? back[1] : -1;

module cabinet(name,w,h,d,foot=0,back=["internal",0],extraHL=0,extraHR=0,extraDL=0,extraDR=0,sideClose="oUF",bottom=true) {

    dBack = (back=="full") ? $W : 0;
    internalDepthLoss=internalOff(back)>=0?internalOff(back)+3:0;

    $name=name;
    $w=w;
    $h=h+foot;
    $d=d-dBack;

    individNames = (extraHL!=extraHR) || (extraDL!=extraDR);

    if(back=="full") {
        eXZ($close="LROU",
            str(name,"-Fback"),w,h+foot);
    } else if(internalOff(back)>=0) {
        bw=w-15;
        bh=h-15;
        color([1,0,0])
        translate([7.5, internalOff(back), foot+7.5])
        if($positive) {
            eXZ($W=3,str(name,"-back"),bw,bh);
            echo(str(name,"-back"),str(bh-1,"x",bw-1));
        } else {
            cube([bw,3,bh]);
        }
    } else {
        assert(false, str("cabinet: unknown back type: ", back));
    }

    translate([0,dBack,0]) {
        {
            translate([0,-extraDR,0])
            eYZ($close=sideClose,str(name,individNames?"r":""),$d+extraDR,h+foot+extraHR);
            translate([w-$W,-extraDL,0])
            eYZ($close=sideClose,str(name,individNames?"l":""),$d+extraDL,h+foot+extraHL);
            
            
            if(foot>0) {
                // foot front element
                translate([$W,d-2*$W,0])
                eXZ($close="oU",name,w-2*$W,foot);
            }
            
            if(bottom)
            translate([$W,0,foot])
            eXY($close=sideClose,str(name,"Bot"),w-2*$W,$d, $connect=[["l",":sTET"],["r",":sTET"]]);
        }

        $internalDepthLoss=internalDepthLoss;
        translate([0,0,$h]) {
            children();
        }
    }
}

module skyFoot(h,w=undef,sideL=false,sideR=false) {
    inset=50;

    width=(w==undef)? $w : w;

    translate([0,$d-inset,-h])
    eXZ($close="oulr",str($name,"Foot"),width,h);
    
    if(sideL) {
        translate([$w-$W,0,-h])
        eYZ($close="oulr",str($name,"FootL"),$d-inset,h);
    }
    if(sideR) {
        translate([0,0,-h])
        eYZ($close="oulr",str($name,"FootR"),$d-inset,h);
    }

}

// width in dims are inner
module cabinet2(name,w,h,dims,foot=0) {
    
    $name=name;
    $h=h+foot;
    
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

/*    
    translate([0,0,foot])
    eYZ(str(name,0),depths[0],h);
    translate([x[n],0,foot])
    eYZ(str(name,n),depths[n],h);
  */  

    for(i=[0:n]) {
        inner=(0<i && i<n);
        off=inner?$W:0;
        translate([x[i],0,off+foot])
        eYZ($close="oU",str(name,i),depths[i],h-2*off);
    }
    
    for(z=[0,h-$W])
        translate([0,0,z+foot])
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
        $d=undef;
        $dL=depths[idx-1];
        $dR=depths[idx];
        $w=widths[idx];
        translate([x[idx-1]+$W,0,$h]) {
            children(idx);
        }
        if(foot>0) {
            a=atan2($dL-$dR,$w);
            translate([x[idx-1],$dL-50,0])
            rotate(-a,[0,0,1])
            eXZ($close="oU",str(name,"Foot",idx),($w+2*$W)/cos(a),foot);
        }

    }


        if($positive) {
//                bw=widths[n]+$W-15;
                bw=x[n]+$W-15;
                bh=h-15;
                color([1,0,0])
                translate([7.5,3,foot+7.5])
                cube([bw,1,bh]);
                echo(str(name,"-back"),str(bh,"x",bw));
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

function tail(n,s) = (n>0) ? str(s[len(s)-n],tail(n-1,s)) : "";

module orient(mode) {

    o=tail(2,mode);

    if(o[0]=="X" && o[1] =="Y") {
        children();
    } else if(o[0]=="X" && o[1] =="Z") {
        rotate(90,[1,0,0])
//        rotate(90,[0,1,0])
        children();
    } else if(o[0]=="Y" && o[1] =="Z") {
         rotate(180,[0,0,1])
         rotate(90,[0,1,0])
        //rotate(90,[1,0,0])
        children();
    } else {
        assert(false, str("orient failed",":",mode,";",tail(2,mode)));
    }
}

module cBeams() {
    W=$W;
    translate([W,0,-W])
    cBeams0($w-2*W,$d);
    children();
}

module cBeams0(w,d) {
    W=$W;
    k=100;
    if(d<3*k) {
        translate([0,0,0])
        eXY(str($name,"-beamF"),w,d);
    }else {
        translate([0,0,0])
        eXY(str($name,"-beam"),w,100);
        translate([0,d-100,0])
        eXY(str($name,"-beam"),w,100);
    }
}

module cBeams2() {

    d=min($dL,$dR);

    translate([0,0,-$W])
    cBeams0($w,d);
    children();
}


module partition2(x,h) {

    BACK_WIDTH=$internalDepthLoss;

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

module partition3(x1,x2,h) {
    partition2(x1,h) {
        children(0);
        partition2(x2,h) {
            children(1);
            children(2);
        }
        children(3);
    }


}


module partitionBeams(x,fullH) {
    
    beamH=$h-2*$W - fullH;
    BACK_WIDTH=$internalDepthLoss;

    
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

module cTop(outer=false) {
    W=$W;
    if(!outer) {
        translate([W,0,-W])
        eXY(str($name,"Top"),$w-2*W,$d,$connect=[["l","sTET"],["r","sTET"]]);
    }else {
//        translate([0,-W,-0])
        eXY($close="LRF",str($name,"OuterTop"),$w,$d+W,$connect=[["l",">:sTET"],["r",">:sTET"]]);
    }
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

module frameExt(name, w, l, h) {
    frame(name,w-2*$W,l-2*$W,h);
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

    
module shelf(h,SHELF_INSET=12,external=false,alignTop=false,rot=false) {

    BACK_WIDTH=$internalDepthLoss;
    
    depth=$d-BACK_WIDTH-(external?0:SHELF_INSET);
    w=$w-2*$W;
//    color([0,1,1])
    translate([$W,BACK_WIDTH,-h-(alignTop?$W:0)])
    eXY(str($name,"Shelf",external?"Ex":"",w),w,depth,rot=rot);
    

    translate([0,0,external?-h:0])
    children();
}

module fullBottom(h,external=false,alignTop=false,rot=false) {

    
    depth=$d-(external?0:SHELF_INSET);
    w=$w-2*$W;
//    color([0,1,1])
    translate([$W,0,-h-(alignTop?$W:0)])
    eXY(str($name,"Shelf",external?"Ex":"",w),w,depth,rot=rot, $connect=[["l","sTCT"],["r","sTET"]]);
    

    translate([0,0,-h])
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


// cloth hanger rod
module hanger(h) {

    BACK_WIDTH=4;
    
    depth=$d-$internalDepthLoss;
    
    if($machines) {
        color([0,1,0])
        translate([0,depth/2,-h])
            cube([$w,10,20]);
    }
    
    children();
}


function smartSlideLen(l) =  
    (l>603) ? 600 : 
    (l>403) ? 400 : 
    (l>353) ? 350 : 
    (l>303) ? 300 :
    (l>253) ? 250 :
    -1;

module jointYP(type="TET") {
    joint(type);
}

module jointYN(type="TET") {
    mirror([0,0,1])
    joint(type);
}

module toFLB() {
    mirror([0,0,1])
    children();
}
module toFLT() {
    children();
}
module toFRT() {
    mirror([1,0,0])
    children();
}

module toFRB() {
    mirror([1,0,0])
    mirror([0,0,1])
    children();
}

module toBRT() {
    mirror([0,1,0])
    toFRT()
    children();
}
module toBRB() {
    mirror([0,0,1])
    toBRT()
    children();
}

module toBLT() {
    mirror([0,1,0])
    children();
}
module toBLB() {
    mirror([0,0,1])
    toBLT()
    children();
}

function xor(a,b) = (a && !b) || (!a && b);

module jointI() {
    L=80;
    translate([L/2,0,0])
    if(xor(!$positive,$jointsVisible)) {

        translate([0,$W/2,0])
        cylinder(d=6,h=2*34,center=true);

            for(k=[-1,1]) {
            translate([k*28,$W/2,0])
            cylinder(d=8,h=40,center=true);

                translate([0,$W+$W/4,k*34])
                rotate(90,[1,0,0])
                cylinder(d=15,h=$W*3/2);
            }
    }
}



module jointT() {
    if(xor(!$positive,$jointsVisible)) {

            translate([$W/2,$W/4,L/2+0*28])
            rotate(-90,[1,0,0])
            cylinder(d=8,h=40);
        if($positive) {
            cube(100,center=true);
        }
    }
}



module jointPartC(off) {
        echo(str("PART:CONFIRMATOR"));

            translate([$W/2,-$W/4,off]) {
            rotate(-90,[1,0,0])
            cylinder(d=5,h=70);
            }

            translate([$W/2,-$W/4,off]) {
            rotate(-90,[1,0,0])
            cylinder(d=7,h=$W+$W/4+5);
            }


        if($machines)
        translate([$W/2,$W+20,off+0*28])
        %cube([2*$W,4,4],center=true);

}

module jointPartE() {
        echo(str("PART:EXCENTER"));
    L=80;
            translate([$W/2,$W/4,L/2]) {
            rotate(-90,[1,0,0])
            cylinder(d=6,h=50);
            }
            translate([$W,$W+34,L/2])
            rotate(90,[0,1,0])
            cylinder(d=15,h=1.5*$W,center=true);

        if($machines)
        translate([$W/2,$W+20,L/2+0*28])
        %cube([2*$W,4,2],center=true);

}
module jointPartT() {
        echo(str("PART:DUBEL"));
        echo(str("PART:DUBEL"));
    L=80;
    for(k=[-1,1]) {
        translate([$W/2,$W/4,L/2+k*28])
        rotate(-90,[1,0,0])
        cylinder(d=8,h=40);
        // marker
        if($machines)
        translate([$W/2,$W+20,L/2+k*28])
        %cube([2*$W,2,2],center=true);
    }
}


module joint(orient="XY",type="TET",center=false) {

    $fn=8;
    L=80;
    orient(orient)
    translate([0,0,center?-L/2:0])
    if(xor(!$positive,$jointsVisible)) {
        if(type == "TET") {
            jointPartE();
            jointPartT();

        } else 
        if(type == "TCT") {
            jointPartC(L/2);
            jointPartT();

        } else 
        if(type == "CC") {
            jointPartC(L/2-28);
            jointPartC(L/2+28);
        } else 
        if(type == "TIT") {
                    echo(str("PART:DUBEL"));
        echo(str("PART:DUBEL"));
            translate([$W,$W,0]) 
            rotate(90,[1,0,0])
            rotate(90,[0,0,1])
            jointI();

            //if($machines)
            for(k=[-1:1]) {
                translate([$W/2,$W+20,L/2+k*28])
                %cube([2*$W,2,2],center=true);
                translate([$W/2,-$W+20,L/2+k*28])
                %cube([2*$W,2,2],center=true);
            }
        } else 
        if(type == "TT") {
            jointPartT();
        } else {
            assert(false, str("joint type unknwon:",type)            );
        }

//        cube(100);
    }
}

module joints(len,mode="TET") {
    jointsZ(len);
}

module jointsX(len,mode="TET") {
//    translate([len,0,0])
    mirror([0,0,1])
    rotate(90,[0,1,0])
    jointsZ(len,mode=mode);
}


module jointsY(len) {
//    translate([len,0,0])
    mirror([1,0,0])
    rotate(90,[0,0,1])
    jointsX(len);
}

module jointsXZ(len) {
    mirror([1,0,0])
    rotate(90,[0,0,1])
    jointsZ(len);
}
module jointsZX(len,center=false) {
//    mirror([1,0,0])
    rotate(90,[0,1,0])
    rotate(90,[0,0,1])
    jointsZ(len,center=center);
}

module jointsZY(len,center=false) {
    rotate(90,[1,0,0])
//    mirror([1,0,0])
    jointsZ(len,center=center);
}

// b: begin
// e: end
// c: center
// s: sides = b+e

module jointsZ(len,center=false,mode="TET") {
        L=80;
    if(mode[0] == "-") {
        m=substr(mode,1);
        PROTECT_LEN=50;
        translate([$W,0,0])
        mirror([1,0,0])
        jointsZ(len=len,center=center,mode=m);
    } else
    if(mode[0] == ":") {
        m=substr(mode,1);
        PROTECT_LEN=50;
        translate([0,0,PROTECT_LEN])
        jointsZ(len=len-2*PROTECT_LEN,center=center,mode=m);

    } else
    if(mode[0] == "c"||mode[0] == "b"||mode[0] == "e"||mode[0] == "s") {
        s=mode[0];
        m=substr(mode,1);
        if(s=="c") {
        translate([0,0,len/2])
        joint(center=true,type=m);
        }
        if(s=="b" || s=="s") {
        translate([0,0,L/2])
        joint(center=true,type=m);
        }
        if(s=="e" || s=="s") {
        translate([0,0,len-L/2])
        joint(center=true,type=m);
        }
    } else {
    PROTECT_LEN=50;
    if($cornerProtect) {
        $cornerProtect=false;
        translate([0,0,PROTECT_LEN])
        jointsZ(len-2*PROTECT_LEN,center=center,mode);
    } else {
        //n=len<800?floor(len/230):floor(len/300);
        if("0" < mode[0] && mode[0] <="9") {
            n=toInt(mode[0]);
            for(i=[0:n-1]) {
                translate([0,0,L/2+i*(len-L)/(n-1)])
                joint(center=true,type=substr(mode,1));
            }
        } else {

        n0=floor(len/230);
        n=n0>5?5:n0;

        if(len<190){
            joint(center=center,type=mode);
        } else if (n<=2){
            joint(center=center,type=mode);
            translate([0,0,len-L])
            joint(center=center,type=mode);
        } else {
            for(i=[0:n-1]) {
                translate([0,0,L/2+i*(len-L)/(n-1)])
                joint(center=true,type=mode);
            }
        }


        }
    }
    }
}


module drawer(h,type1="def") {
    name=str($name,"H",h);

    FRONT_SP=2;

    ww=$w-FRONT_SP;
    hh=h-FRONT_SP;

    type=(type1=="def")?$defaultDrawer:type1;

    // go with $W=19 for internal sizing - instead of smalle
    qx=(type=="smart"?$W+5.0:$W+12.7);
    qz=$W;
    ix=$w-2*qx;
    iz=h-(3*$W-6);  //  -4W

    id0=( (type=="smart") ?smartSlideLen($d-$internalDepthLoss)-10:$d-10-$internalDepthLoss);
    id=( (type=="smart" && $smartOverdrive==undef  ) ?id0:$d-5-$internalDepthLoss);
    shimD= id - id0;

    nBeams=($d>500)? 2 : 0;

    if($positive ) {
        echo(str("PART:SLIDE:",type,":",id0));
    }

    if(id < 0) {
        echo($d);
        echo(smartSlideLen($d));
        assert(false, "id undef");
    }

    o_y=($drawerState=="CLOSED" ? 0 : id-50);
    
    translate([0,$d+o_y,-h])
    if($positive) {
        
        if($fronts) {            
//            color([0,1,1])
            {
                translate([FRONT_SP/2,0,FRONT_SP/2])
                eFRONT($front=true,$close="OULR",str("DF",h),ww,hh);
//                translate([$w/2,$d,-h/2])
  //                cube([ww,$W,hh],center=true);
            }
//                translate([0,$d,-h+$W])
  //          eXZ("DF",ww,hh);
        }
        if($drawerBoxes) {
            floorW=is_undef($floorW) ? 3 : $floorW;
            floorOff=12+floorW;
            nut_depth=floorW>3 ? 0 : 6;
            if(type=="smart") {
                // smart
                $W=is_undef($DRAWER_WALL_W) ? $W : $DRAWER_WALL_W;
                $close="O";
                translate([qx+$W,-$W,qz+floorOff])
                eXZ(str(name,"A"),ix-2*$W,iz-floorOff);
                translate([qx+$W,-id,qz+floorOff])
                eXZ(str(name,"A"),ix-2*$W,iz-floorOff);

if(nBeams>0)
                for(i=[0:nBeams-1]) {
                translate([qx+$W,-$W-(i+1)*(id/(nBeams+1)),qz+floorOff])
                eXZ(str(name,"AR"),ix-2*$W,min(iz-floorOff,50));
                }

                
                nameB=str("B", nut_depth>0?str("m",floorOff-floorW):"");
                translate([qx,-id,qz])
                eYZ(str(name,nameB),id,iz);
                translate([$w-$W-qx,-id,qz])
                eYZ(str(name,nameB),id,iz);
            
//                nut_depth
                
                o=$W-nut_depth;
                translate([qx+o,-id,qz+floorOff-floorW])
                eXY($W=floorW,str(name,"Floor"),ix-2*o,id);
                //echo(str(name,"-dback"),str(ix-15,"x",id));


                if($smartOverdrive!=undef) {
                    translate([qx+o,-shimD,qz])
                    eXY($W=10,str(name,"OvrDrv"),ix-2*$W,shimD);
                }

            }else {
                $close="Olru";
                translate([qx,-$W,qz])
                eXZ(str(name,"A"),ix,iz);
                translate([qx,-id,qz])
                eXZ(str(name,"A"),ix,iz);

                translate([qx,-id+$W,qz])
                eYZ(str(name,"B"),id-2*$W,iz);
                translate([$w-$W-qx,-id+$W,qz])
                eYZ(str(name,"B"),id-2*$W,iz);
            
                translate([qx,-id,qz-3])
                union() {
   //                 cube([ix,id,3]);
                    eXY(str(name,"-floor"),$W=3,ix,id);
                }
                //echo(str(name,"-dback"),str(ix,"x",id));
            }
        }
        
    }
    if(xor(!$positive, $jointsVisible)) {
        if(type=="smart") {
            pos0=[19,18,32,96-9,96,32+9];
            pos=concat(prefix(0,pos0), prefix(shimD, pos0), prefix(96,pos0));
            pos2=concat(prefix(96,pos0));
            echo(str("sc0:",prefix(0, pos0)));
            echo(str("scD:",prefix(shimD,pos0)));
            echo(str("scDA:",prefix(96 ,pos0)));
            echo(str("scM:",prefix(822 ,-pos0)));
            translate([$w/2,$d+o_y,-h]) 
            symX([$w/2,0,41]) 
            {
                translate([0,0,0]) 
                euroscrews(pos);

//                translate([0,9,-3]) 
//%                euroscrews(pos2);


            }
        }
    }
    
    translate([0,0,-h])
        children();
    
}


module euroscrews(pos) {

    for(x = pos) {
        translate([0,-x,0]) 
        rotate(90,[0,1,0])
        cylinder(h = $W*1.5, d = 5,center=true);
    }
}

//mode="zigzag";
//mode="zigzag";
mode="planar";

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



module bedFrame(name,l,w,h,sink,xh2=-1,leftOversize=0,backOversize=0) {
    $close=str($close,"LROU");
    h2=(xh2<0)?h:xh2;
    q=h2-h;
    
    translate([0,$W,-q])
    eYZ( str(name,"-FR"),w,h2,$connect=[["l","eTET"],["r","eTET"]]);
    
    translate([0,$W,-q])
    translate([l+$W,0,0])
    eYZ(str(name,"-FL"),w,h2+leftOversize, $connect=[["l","eTET"],["r","eTET"]]);
    
    if(xh2>0) {
        translate([0,0,-q])
        translate([(l+$W)/2,$W,0])
        eYZ(str(name,"-C"),w,q+h-sink-$W);
    }
    

    translate([0,0,0])
    eXZ(str(name,"-SB"),l+2*$W,h+backOversize);
    translate([0,w+$W,0])
    eXZ(str(name,"-SF"),l+2*$W,h);
    
    translate([$W,$W,h-$W-sink]) {
       $connect=[["l","cTET"], ["r","cTET"],["f","TET"],["b","TET"]];
    
        eXY($close="",str(name,"-Bot"),l,w,$cornerProtect=true);
        if(false) {
        translate([0,-$W,0])
        jointsX(l);

        translate([0,w+$W,0])
        toBLT()
        jointsX(l);

        jointsY(w);
        translate([l,0,0])
        toFRT()
        jointsY(w);

        }
        
        
        
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

if(mode=="planar") {
    $W=18;
    $part=undef;
    posNeg() {
        for(x=[0,150])
        translate([x,0,0]) {
            $close="oU";
            rot=x>0;
            
            translate([$W,$W,0])
            eXY("a",100,200, rot=rot);
            translate([$W,0,$W])
            eXZ("b",100,200, rot=rot);
            translate([0,$W,$W])
            eYZ("c",100,200, rot=rot);
        }
    }  
}



function search2(key, arr) = (!is_list(arr) || len(arr) == 0) ? undef : arr[0][0] == key ? arr[0][1] : search2(key, sublist(arr, 1));
arr=[["f", "1"]];
echo(search2("f", arr));
echo(search2("X", arr));


posNeg() {
    cube(20,center=true);
    $W=18;
    $jointsVisible=true;
joint(center=true);
}