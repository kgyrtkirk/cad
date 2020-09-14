use<syms.scad>

HALL_WIDTH=1080;
HALL_LENGTH=2700;
HALL_HEIGHT=26;

DOOR1_X=1160;
DOOR2_X=HALL_LENGTH-1000;
    DOOR_D=DOOR2_X-DOOR1_X;
DOOR_W=740;

module wall() {
    symX([HALL_WIDTH/2,0,0]) {
        cube([10,HALL_LENGTH,HALL_HEIGHT]);
    }
    
    
    translate([-HALL_WIDTH/2,DOOR1_X,0])
    cube([40,DOOR_W,1]);
    translate([HALL_WIDTH/2,DOOR2_X,0])
    cube([40,DOOR_W,1]);
}

module hullPairs(pos){
    for(i=[0:len(pos)-2]){
        hull() {
            translate(pos[i+0]) children();
            translate(pos[i+1]) children();
        }
    }
}



WW=128;

function sx(li,s)=[for(i=li) [i[0]*s[0],i[1]*s[1],i[2]*s[2]]];

function uu(li) = [for(p=li) [p[0]*pow((1+p[1])/len(li),0),p[1],p[2]]];
module worm(part) {
    points=sx(uu([
            [-1,1,0],
            [ 1,2,0],
            [-1,3,0],
            [ 1,4,0],
            [-1,5,0],
        ]),[.5,1,1]*DOOR_D);
    echo(points);

    
    module w() {
        difference() {
            hullPairs(points) {
                cylinder(d=WW,center=true);
            }
            for(p=points) {
                translate(p) {
                cylinder(d=70,h=100,center=true);
                cylinder(d=88,h=100);
                } 
            }
            for(i=[0:len(points)-2:len(points)-2]) {
                p=(points[i]+points[i+1])/2;
                translate(p)
                cylinder(d=44,h=100,center=true);
            }
        }
    }
    
    if(part>=0) {
        
        
        y0=(part==0)?-1000:points[0][1];
        y1=points[1][1];
        
        d=points[1]-points[0];
        echo(norm(d));
        
        
        a=atan2(d[0],d[1]);
        
        rotate(a)
        translate(-points[0])
        intersection() {
            w();
            
            translate([0,y0+(y1-y0)/2,0])
            cube([HALL_WIDTH,y1-y0,100],center=true);
        }
        
    }else{
        w();    
    }
    
    
}

mode="pr";

if(mode=="preview"){
    wall();
    translate([0,DOOR1_X+DOOR_W/2-DOOR_D*9/3,0])
    worm(-1);
}


if(mode=="p0"){
    projection()
    worm(0);
}
if(mode=="p1"){
    projection()
    worm(1);
}


if(mode=="pr"){

//    translate([DOOR_D*3/2/2,0,0])
  //  cube([10,3000,10]);
    
    projection() {
    wall();
    translate([0,DOOR1_X+DOOR_W/2-DOOR_D*9/3,0])
    worm(-1);
    }
}


echo(DOOR_D);
DOOR_K=DOOR_D*3/2;
echo((HALL_WIDTH-DOOR_K)/2);