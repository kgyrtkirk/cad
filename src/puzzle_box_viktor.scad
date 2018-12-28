// Puzzle box by Adrian Kennard www.me.uk
// /75/15/5
p=2;	// Paths
m=0.2;	// Margin/clearance
s=5;	// Spacing (unit)
h=13;	// Height in units
w=14;	// Width in units
bs=4;	// Base sides
bh=8;	// Base height
bd=30;	// Base diameter
ih=75;	// Inside height
eh=5;	// Extra height
id=15;	// Inside diameter
wt=3;	// Wall thickness
iw=2;	// Inside wall thickness
st=0;	// Start point
ex=1;	// Exit point
lid=1;	// Print lid
base=1;	// Print base
is=0;	// Inside Russian
os=0;	// Outside Russian
k=0;	// Skew
i=0;	// Inside (maze inside lid)
maze=[
[3,1,2,2,1,1,2,3,1,2,2,1,1,2],
[1,0,2,2,3,2,2,1,0,2,2,3,2,2],
[2,2,1,1,0,2,1,2,2,1,1,0,2,1],
[2,2,1,2,2,3,1,2,2,1,2,2,3,1],
[1,1,0,1,1,1,2,1,1,0,1,1,1,2],
[2,1,2,1,2,3,2,2,1,2,1,2,3,2],
[1,1,2,2,2,2,3,1,1,2,2,2,2,3],
[2,3,1,0,2,2,3,2,3,1,0,2,2,3],
[2,0,3,2,2,0,0,2,0,3,2,2,0,0],
[1,1,0,1,2,3,2,1,1,0,1,2,3,2],
[1,2,3,1,0,2,1,1,2,3,1,0,2,1],
[0,2,2,2,1,1,1,0,2,2,2,1,1,1],
[1,0,1,1,1,1,1,1,0,1,1,1,1,1]];

mode="lid";
if(mode=="base")translate([lid?(id+s*4+iw*2+wt*2)/2:0,0,0])makebase();
if(mode=="lid")translate([base?-(id+s*4+iw*2+wt*2)/2:0,0,0])makelid();

module knob()
{
    rotate([0,0,-90])
    rotate([90,0,0])
    rotate([0,0,45])
    hull()
    {
        cylinder(d=sqrt(2),h=(s-1)/2,$fn=4);
        translate([0,0,-1])
        cylinder(d=(s-1)*sqrt(2),h=1,$fn=4);
    }
}

module right()
{
    q=3.6;
    for(a=[0:q:360/w])
    hull()
    {
        rotate([0,0,a])
        translate([id/2+iw+s/2-m,0,0])
        knob();
        rotate([0,0,min(a+q,360/w)])
        translate([id/2+iw+s/2-m,0,0])
        knob();
    }
}

module up(q,d=id+iw*2+s)
{
        translate([d/2-m,0,0])
        hull()
        {
            knob();
            translate([0,0,q])
            knob();
        }
}

module outer(h)
{
    r=bd/2+m;
    minkowski()
    {
       cylinder(r=(r-wt)/cos(180/bs),h=h-wt,$fn=bs);
       cylinder(r1=0,r2=wt,h=wt,$fn=100);
    }
}

module aa(w=100,white=0,$fn=100)
{   // w is the 100%, centre line of outer ring, so overall size (white=0) if 1.005 times that
    scale(w/100)
    {
        if(!white)difference()
        {
            circle(d=100.5);
            circle(d=99.5);
        }
        difference()
        {
            if(white)circle(d=100);
            difference()
            {
                circle(d=92);
                for(m=[0,1])
                mirror([m,0,0])
                {
                    difference()
                    {
                        translate([24,0,0])
                        circle(r=22.5);
                        translate([24,0,0])
                        circle(r=15);
                    }
                    polygon([[1.5,22],[9,22],[9,-18.5],[1.5,-22]]);
                }
            }
        }
    }
}

module makebase()
{
    mm=(ih+wt-bh-s*h)/2+s/2+m*2;
    difference()
    {
        if(os)
	difference()
	{
   	   cylinder(d=bd-m*2,h=bh,$fn=100);
	   translate([0,0,-0.01])
	   difference()
	   {
		   cylinder(d=bd+2-m*2,h=2);
		   cylinder(d1=bd-2-m*2,d2=bd+4-m*2,h=3,$fn=100);
	   }
	}
	else
        outer(bh);
	hull()
	{
           translate([0,0,wt-1])
           cylinder(d=id+m*2-2,h=bh,$fn=100);
           translate([0,0,wt])
           cylinder(d=id+m*2,h=bh,$fn=100);
	}
	if(os)
	{
           for(a=[0:360/p:359])
           rotate([0,0,a])
	   up(bh,bd);
	}
    }
    rotate([0,0,-st*360/w])
    difference()
    {
        translate([0,0,bh-0.01])
        cylinder(d=id+iw*2+s-m*2,h=wt+ih-bh,$fn=100);
	difference()
	{
           translate([0,0,wt])
           cylinder(d=id+m*2,h=ih+1,$fn=100);
	   if(is)
	   {
              for(a=[0:360/p:359])
              rotate([0,0,a+ex*360/w])
              translate([id/2+m,0,wt+ih-s/2])
              knob();
	   }
	}
	if(!is)
	{
           translate([0,0,wt+ih-id/2-1])
           cylinder(d1=0,d2=id+m*2+4,h=id/2+2,$fn=100);
           difference()
            {
                translate([0,0,wt+ih-1])
                cylinder(d=id+iw*2+s*2,h=2);
                translate([0,0,wt+ih-3])
                cylinder(d1=id+iw*2+s-m*2+4,d2=0,h=(id+iw*2+s-m*2)/2+2,$fn=100);
            }
	}
        for(a=[0:360/p:359])
        rotate([0,0,a])
        {
            rotate([0,0,st*360/w])
            {
                translate([0,0,bh+s/2])
                up(0);
		o=s/2+2+(p==1?m:0);
                if(mm>o)
                translate([0,0,bh+o])
                up(mm-o);
            }
            rotate([0,0,ex*360/w])
            translate([0,0,bh+mm+s*(h-1)])
            up(mm);
        }
        // Maze
        for(y=[0:1:h-1])
        translate([0,0,bh+mm+y*s])
        render()
        for(x=[0:1:w-1])
        rotate([0,0,x*360/w])
        {
            if(maze[y][x]==1 || maze[y][x]==3)
                right();
            if(maze[y][x]==2 || maze[y][x]==3)
                up(s);
        }
    }
}

module makelid()
mirror([1,0,0])
{
    difference()
    {
        outer(ih-bh+wt*2+eh);
        difference()
        {
	    hull()
	    {
               translate([0,0,wt-1])
               cylinder(d=id+s+iw*2+m*2-2,h=ih+eh,$fn=100);
               translate([0,0,wt])
               cylinder(d=id+s+iw*2+m*2,h=ih+eh,$fn=100);
	    }
            translate([0,0,wt])
            for(a=[0:360/p:359])
            rotate([0,0,a])
            translate([id/2+iw+s/2+m,0,ih-bh-s/2+wt+eh])
            knob();
        }
        translate([0,0,wt-2])
        linear_extrude(height=wt)
        aa((id+s+iw*2+m*2-2)/1.1,white=1);
    }
}
