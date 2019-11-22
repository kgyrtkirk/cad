

module turnHandle(r=5,R=20,N=5,h=5,cd=1){
    translate([0,0,-h/2]){
        cylinder(r=R,h=h,center=true);
        for(i=[1:N]){
            a=i*360/N;
            translate([R*sin(a),R*cos(a),0]) {
                
                for(mZ=[0,1]) {
                    mirror([0,0,mZ])
                    translate([0,0,h/2-cd/2])
                    cylinder(r1=r,r2=r-cd,h=cd,center=true);
                }
                cylinder(r=r,h=h-2*cd,center=true);
            }
        }
    }
}




module thumbWheel(X=5.5,D_AXLE=3.5,PD=2.3,H=3.6) {
    

    D=sqrt( (X/2)*(X/2) +(X/4)*(X/4))*2;

    difference() {
        turnHandle(R=10,N=7,h=H);
        cylinder($fn=6,d=D,h=2*PD,center=true);
        cylinder($fn=32,d=D_AXLE,h=3*H,center=true);
    }
}
mode="m3";

if(mode=="m3") {
    thumbWheel();
}