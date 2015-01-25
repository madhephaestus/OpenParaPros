
cableDiameter=3;

linkLength = 60;
linkThickness=linkLength/3;
linkWidth=linkLength/3;
cablePullRadius=5;

function HiLoScrewDiameter(3dPrinterTolerance=.4)= 3.6+3dPrinterTolerance;  
function HiLoScrewLength(3dPrinterTolerance=.4)= linkWidth+3dPrinterTolerance;
function HiLoScrewHeadDiameter(3dPrinterTolerance=.4)= 6.7+3dPrinterTolerance;
function HiLoScrewHeadHeight(3dPrinterTolerance=.4)= 2.5+3dPrinterTolerance;

//err on the side of smaller tolerances for screws

module HiLoScrew(3dPrinterTolerance=.4)
{
	union()
	{
		translate([0,0,-HiLoScrewLength(3dPrinterTolerance)])
		{
			cylinder(HiLoScrewLength(3dPrinterTolerance), HiLoScrewDiameter(3dPrinterTolerance)/2, HiLoScrewDiameter(3dPrinterTolerance)/2);
		}
		cylinder(HiLoScrewHeadHeight(3dPrinterTolerance), HiLoScrewHeadDiameter(3dPrinterTolerance)/2,HiLoScrewHeadDiameter(3dPrinterTolerance)/2);
	}
}



module knotchHalf(orentation, negative)
{
	intersection(){
		rotate([0,0,orentation/2])
			children(0);
		
		mirror([1,0,0])
			rotate([0,0,orentation/2])
				children(0);
		
	}
	intersection(){
		rotate([0,0,negative/2])
			mirror([0,1,0])
				children(0);
		
		mirror([1,0,0])
			rotate([0,0,negative/2])
				mirror([0,1,0])
					children(0);
		
	}
	
}

module guideTubes(cablePullRadius=5,linkLength=50){
	tubSectionLen = linkLength/1.5;
	innerSectionLen = cablePullRadius* sqrt(2);
	difference(){
		union(){
			translate([0,cablePullRadius,0]){
				cylinder(h=tubSectionLen,d=cableDiameter,center=true);
			}
			translate([0,cablePullRadius,tubSectionLen/2-cableDiameter/2]){
				rotate([-45,0,0])
					translate([0,0,tubSectionLen/2])
						cylinder(h=tubSectionLen,d=cableDiameter,center=true);
			}
			
			translate([0,cablePullRadius,-(tubSectionLen/2-cableDiameter/4)]){
				rotate([-45,0,0])
					translate([0,0,-innerSectionLen/2.5])
						cylinder(h=innerSectionLen,d=cableDiameter,center=true);
			}
			//tab for screw holes
			translate([cableDiameter/3-1.8,cablePullRadius/2-1,tubSectionLen/2-2]){
				
				// void for flap
				cube([cablePullRadius,cablePullRadius*2,cablePullRadius*2]);
				translate([HiLoScrewLength()+cablePullRadius-1,cablePullRadius,4])
				rotate([0,90,0])
					#HiLoScrew();
			}
			
		}
		translate([cableDiameter/3-2,cablePullRadius/2,tubSectionLen/2-2]){
			//flap
			translate([1,-.1,2.1])
				cube([cablePullRadius-2,cablePullRadius*2-2,cablePullRadius*2-2]);
		}
		
	}
}

module knotch(orentation, negative){
	
	knotchHalf(orentation, negative){
		children(0);
	}
	
	mirror([0,0,1])
			knotchHalf(orentation, negative){
				translate([0,0,-.1])
					children(0);
			}
			
}


module cableLink(input=[0,-45,45,25,10,15],cablePullRadius=5,linkThickness,linkWidth){
	echo(input);
	linkLength= input[3];
	inOrentation =  input[0];
	inNeg=input[1];
	inPos=input[2];
	translate([0,0,linkThickness/2])
	difference(){
		cube([linkLength,linkWidth,linkThickness],center=true);// finger joint brick
		union(){// all the cut outs
			rotate([inOrentation,0,0]){	// rotate the joint to the specified orentation	
				knotch(inPos,inNeg){// hinge section
					translate([-.5,1,0])
						cube([linkLength*1.1,linkWidth*1.1,linkThickness*1.1]);// hinge cutter, this could be more elegant...
					
				}
				translate([-.1,0,0])
				rotate([0,90,0]){
					
					cylinder(h=linkLength,d=cableDiameter,center=true);// center tube
					
					// string lines
					guideTubes(cablePullRadius=cablePullRadius,linkLength = linkLength  );
					mirror([0,1,0])
						guideTubes(cablePullRadius=cablePullRadius,linkLength = linkLength  );
				}
				
			}
			
		}
	}
	
}

module basicLeg(input, depth=0,cablePullRadius=5,linkThickness,linkWidth){
	echo("Link #",depth);
	translate([input[depth][3]/2,0,0]){
		if(depth ==1){
			color("blue"){
				cableLink(input[depth],cablePullRadius=cablePullRadius,
		                  linkThickness=linkThickness,
		                  linkWidth=linkWidth);
			}
		}else{
			color("green"){
				cableLink(input[depth],cablePullRadius=cablePullRadius,
		                  linkThickness=linkThickness,
		                  linkWidth=linkWidth);
			}
		}
		if(depth < (len(input)-1)){
			translate([input[depth][3]/2,0,0])
				basicLeg(	input, 
							depth+1,// increment the depth to walk down the list
							cablePullRadius=cablePullRadius,
							linkThickness=linkThickness,
							linkWidth=linkWidth);
		}else{
			translate([0,0,linkThickness/2])
				difference(){
					translate([input[depth][3]/2,0,0])
						sphere(linkThickness/2);
					cube([linkLength,linkWidth,linkThickness],center=true);
				}
		}
	}
	
}


basicLeg(input = [ [0,-45,45,linkLength/2],
                   [90,-45,45,linkLength/2],
                   [90,0,90,linkLength]
                  ],
                  cablePullRadius=cablePullRadius,
                  linkThickness=linkThickness,
                  linkWidth=linkWidth);