use<syms.scad>

HALL_WIDTH=1080;
HALL_LENGTH=2700;
HALL_HEIGHT=26;

DOOR1_X=1160;
DOOR2_X=HALL_LENGTH-1000;
    DOOR_D=DOOR2_X-DOOR1_X;
DOOR_W=800;

module wall() {
    symX([HALL_WIDTH/2,0,0]) {
        cube([10,HALL_LENGTH,HALL_HEIGHT]);
    }
    
    
    translate([-HALL_WIDTH/2,DOOR1_X,0])
    cube([40,DOOR_W,1]);
    translate([HALL_WIDTH/2,DOOR2_X,0])
    cube([40,DOOR_W,1]);
}

wall();

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
            [ 1,0,0],
            [-1,1,0],
            [ 1,2,0],
            [-1,3,0],
            [ 1,4,0],
        ]),[sqrt(3)/2,1,1]*2/3*DOOR_D);
    echo(points);

    points1=sx(uu([
            [ 1,0,0],
            [-1,1,0],
            [ 1,2,0],
            [-1,3,0],
            [ 1,4,0],
        ]),[sqrt(3)/2+.0,1,1]*2/3*DOOR_D);
    
    
    module w() {
        difference() {
            hullPairs(points1) {
                cylinder(d=WW,center=true);
            }
            for(p=points) {
                translate(p) {
                cylinder(d=57,h=100,center=true);
                cylinder(d=88,h=100);
                }
            }
        }
    }
    
    if(part>=0) {
        
        y0=(part==0)?-1000:points[0][1];
        y1=points[1][1];
        intersection() {
            w();
            
            translate([0,y0+(y1-y0)/2,0])
            cube([HALL_WIDTH,y1-y0,100],center=true);
        }
        
    }else{
        w();    
    }
    
    
}

//translate([0,DOOR1_X+DOOR_W/2-DOOR_D*6/3,0])
worm(-1);
















