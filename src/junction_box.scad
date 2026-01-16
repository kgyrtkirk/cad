$fn=64;


//@OUTPUT:lid
//@OUTPUT:box

xmode="box";

/* [Box configuration:] */
//external Length
    Length = 90;
//external Width
    Width= 90;
//external Height
    Height = 20;
//Box and lid corner radius
    CornerRadius = 4;
//lid Height
    LidAndBottomHeight = 2;
//lid shrink factor to ease the fit. 1 = no shrink
    EasyFit=1; //[0.8:0.01:1]


  
/* [Fixing holes configuration:] */
    FixingHolesDiameter = 4;
    
    EnableTopLeftFixationHole = true;
    TopLeftFixationHolePosition = [15,12.5];

    EnableTopRightFixationHole = true;
    TopRightFixationHolePosition = [13,12.5];

    EnableBottomLeftFixationHole = false;
    BottomLeftFixationHolePosition = [0,0];
    
    EnableBottomRightFixationHole = false;
    BottomRightFixationHolePosition = [0,0];



/* [Cable holes configuration:] */
    CableHolesDiameter=8;

    EnableTopLeftHoleFaceE = false;
    EnableTopCenterHoleFaceE = false;
    EnableTopRightHoleFaceE = false;

    EnableBottomLeftHoleFaceE = false;
    EnableBottomCenterHoleFaceE = true;
    EnableBottomRightHoleFaceE = false;

    EnableMiddleRightHoleFaceE = false;
    EnableMiddleLeftHoleFaceE = false;

    EnableLeftHoleFaceA = true;
    EnableRightHoleFaceA = true;

    EnableLeftHoleFaceB = true;    
    EnableRightHoleFaceB = false;

    EnableLeftHoleFaceC = false;    
    EnableRightHoleFaceC = false;

    EnableLeftHoleFaceD = true;
    EnableRightHoleFaceD = true;

/* [Screws configuration:] */
    TopScrewDiameter=3.5;  //[0:0.1:10]
    TopScrewHeadDiameter=6.5; //[0:0.1:10]
    TopScrewHeadHeight=3; //[0:0.1:10]
    TopScrewLength=15; //[0:0.1:100]

//box drawing
if(is_undef(mode) || mode == "box")
    difference(){
        //box and central pilar
        union(){
            //central pilar
            difference(){
                color("red")cylinder(h = Height-LidAndBottomHeight, d = 2*TopScrewDiameter);
                translate([0,0,Height-LidAndBottomHeight-(TopScrewLength-2*LidAndBottomHeight)]){
                    color("blue")cylinder(h = TopScrewLength-2*LidAndBottomHeight, d = 0.8*TopScrewDiameter);
                }
            }
            //end central pilar

            //main box
            translate([0,0,Height/2]){
                difference(){
                    roundedBox(Length, Width, Height, CornerRadius);
                    translate([0,0,LidAndBottomHeight/2]){
                        roundedBox(Length-CornerRadius, Width-CornerRadius, Height, CornerRadius);
                    }
                }
            }
            //main box end
        }
        //end box and central pilar
        //cable holes config
        union(){
            //face E holes
            union(){
                
                if(EnableTopLeftHoleFaceE){
                    translate([Width/4,Length/4]){
                        cylinder(h = LidAndBottomHeight, d= CableHolesDiameter);
                    }
                }

                if (EnableTopCenterHoleFaceE){
                    translate([0,Length/4]){
                        cylinder(h = LidAndBottomHeight, d = CableHolesDiameter);
       
                    }
                }
                
                if (EnableTopRightHoleFaceE){
                    translate([-Width/4,Length/4]){
                        cylinder(h = LidAndBottomHeight, d = CableHolesDiameter);
                    }
                }

                
                if(EnableMiddleLeftHoleFaceE){
                    translate([Width/4,0]){
                        cylinder(h = LidAndBottomHeight, d= CableHolesDiameter);
                    }
                }
                
                if(EnableMiddleRightHoleFaceE){
                    translate([-Width/4,0]){
                        cylinder(h = LidAndBottomHeight, d = CableHolesDiameter);
                    }
                }                
     
                if(EnableBottomLeftHoleFaceE){
                    translate([Width/4,-Length/4]){
                        cylinder(h = LidAndBottomHeight, d = CableHolesDiameter);
                    }
                }
       
                if (EnableBottomCenterHoleFaceE){
                    translate([0,-Length/4]){
                        cylinder(h = LidAndBottomHeight, d = CableHolesDiameter);
       
                    }
                }
                
                if (EnableBottomRightHoleFaceE){
                    translate([-Width/4,-Length/4]){
                        cylinder(h = LidAndBottomHeight, d = CableHolesDiameter);
       
                    }
                }
                      
            }
            //face A holes
            union(){
                 if (EnableLeftHoleFaceA){
                    translate([Height>=Width?0:Width/4,Length/2,Height>=Width?Height/4:Height/2]){
                        rotate([90,0,0]){
                        cylinder(h = CornerRadius, d = CableHolesDiameter);}
       
                    }
                }
                
                if (EnableRightHoleFaceA){
                    translate([Height>=Width?0:-Width/4,Length/2,Height>=Width?3/4*Height:Height/2]){
                        rotate([90,0,0]){
                        cylinder(h = CornerRadius, d = CableHolesDiameter);}
                    }
                } 
            }
            
            //face B holes
            union(){
                 if (EnableLeftHoleFaceB){
                    translate([-Width/2,Height>=Length?0:Length/4,Height>=Length?3*Height/4:Height/2]){
                        rotate([90,0,90]){
                            cylinder(h = CornerRadius, d = CableHolesDiameter);
                        }
                    }
                }
                
                if (EnableLeftHoleFaceB){
                    translate([-Width/2,Height>=Length?0:-Length/4,Height>=Length?Height/4:Height/2]){
                        rotate([90,0,90]){
                            cylinder(h = CornerRadius, d = CableHolesDiameter);
                        }
                    }
                }
            }
            
             //face C holes
            union(){
                 if (EnableLeftHoleFaceC){
                    translate([Height>=Width?0:-Width/4,-Length/2+CornerRadius,Height>=Width?Height/4:Height/2]){
                        rotate([90,0,0]){
                        cylinder(h = CornerRadius, d = CableHolesDiameter);}
       
                    }
                }
                
                 if (EnableRightHoleFaceC){
                    translate([Height>=Width?0:Width/4,-Length/2+CornerRadius,Height>=Width?3/4*Height:Height/2]){
                        rotate([90,0,0]){
                        cylinder(h = CornerRadius, d = CableHolesDiameter);}
       
                    }
                }
            }
            
            
            //face B holes
            union(){
                 if (EnableRightHoleFaceD){
                    translate([Width/2-CornerRadius,Height>=Length?0:Length/4,Height>=Length?3*Height/4:Height/2]){
                        rotate([90,0,90]){
                            cylinder(h = CornerRadius, d = CableHolesDiameter);
                        }
                    }
                }
                
                if (EnableLeftHoleFaceD){
                    translate([Width/2-CornerRadius,Height>=Length?0:-Length/4,Height>=Length?Height/4:Height/2]){
                        rotate([90,0,90]){
                            cylinder(h = CornerRadius, d = CableHolesDiameter);
                        }
                    }
                }
            }
            
            
    }
    
            //fixing holes config
        union(){
            
                if (EnableTopLeftFixationHole){
                    translate(TopLeftFixationHolePosition==[0,0]?[Width/2-CornerRadius,Length/2-CornerRadius, LidAndBottomHeight/2]:[Width/2-TopLeftFixationHolePosition[0], Length/2-TopLeftFixationHolePosition[1],LidAndBottomHeight/2]){
                        rotate([0,0,0]){
                        roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                        rotate([0,0,90]){
                            roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                    }
                }   
                
              
                if (EnableTopRightFixationHole){
                    translate(TopRightFixationHolePosition==[0,0]?[-Width/2+CornerRadius,Length/2-CornerRadius, LidAndBottomHeight/2]:[-Width/2+TopRightFixationHolePosition[0], Length/2-TopRightFixationHolePosition[1], LidAndBottomHeight/2]){
                        rotate([0,0,0]){
                            roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                        rotate([0,0,90]){
                            roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                    }
                }   
                
              
                
                if (EnableBottomLeftFixationHole){
                    translate(BottomLeftFixationHolePosition==[0,0]?[Width/2-CornerRadius,-Length/2+CornerRadius, LidAndBottomHeight/2]:[Width/2-BottomLeftFixationHolePosition[0], -Length/2+BottomLeftFixationHolePosition[1],LidAndBottomHeight/2]){
                        rotate([0,0,0]){
                            roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                        rotate([0,0,90]){
                            roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                        
                    }
                }                      
                
                
                if (EnableBottomRightFixationHole){
                    translate(BottomRightFixationHolePosition==[0,0]?[-Width/2+CornerRadius,-Length/2+CornerRadius, LidAndBottomHeight/2]:[-Width/2+BottomRightFixationHolePosition[0], -Length/2+BottomRightFixationHolePosition[1],LidAndBottomHeight/2]){
                        rotate([0,0,0]){
                            roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                        rotate([0,0,90]){
                            roundedBox(3*FixingHolesDiameter, FixingHolesDiameter, LidAndBottomHeight,FixingHolesDiameter-0.01 );
                        }
                    }
                }                   
        }




}
//end box drawing

//lid drawing
if(is_undef(mode) || mode == "lid")
translate([Width*2, 0, LidAndBottomHeight/2]){
    difference(){
        //main lid
        union(){
            roundedBox(Length, Width, LidAndBottomHeight, CornerRadius);
            translate([0,0,LidAndBottomHeight]){
                roundedBox(EasyFit*(Length-CornerRadius), EasyFit*(Width-CornerRadius), LidAndBottomHeight, CornerRadius);

            }
        }
        //end main lid
        
        //lid holes
        union(){
            translate([0, 0, -LidAndBottomHeight/2]){
                color("blue")cylinder(h = TopScrewHeadHeight, d1 = TopScrewHeadDiameter, d2=TopScrewDiameter);
                translate([0,0,TopScrewHeadHeight]){
                    color("green")cylinder(h = 2*LidAndBottomHeight-TopScrewHeadHeight+0.01, d = TopScrewDiameter);    
                }  
            }
        }
        //end lid holes
    } 
}

//end lid

//Face Legends
    Legends("Lid",0,0,0,2*Width,-Length/2,-Height/2,0);
    Legends("A",0,0,0,0,0,0,90);
    Legends("B",0,0,90,Length/2-Width/2,0,0,90);
    Legends("C",0,0,180,0,0,0,90);
    Legends("D",0,0,270,-Length/2+Width/2,0,0,90);
    Legends("E",0,0,0,0,-Length/2,-Height/2,0);
//end Face Legends


module Legends(letter, legendsRotateX, legendsRotateY, legendsRotateZ, translateX, translateY, translateZ,letterRotateX)
{
    translate([translateX, translateY, translateZ]){
        rotate([legendsRotateX,legendsRotateY,legendsRotateZ]){
            translate([0,Length/2,Height/2]){
                mirror(){
                    rotate([letterRotateX,0,0]) {           
                        %text(str(letter), halign="center", valign="center", font = "Liberation Sans:style=Bold Italic"); 
                    }
                }
            }
        }
    }
}
  
module roundedBox(Length, Width, Height, radius)
{
    minkowski() {
        cube(size=[Width-radius,Length-radius, Height],center=true);
        cylinder(r=radius/2, h=0.01);
    }
    

}