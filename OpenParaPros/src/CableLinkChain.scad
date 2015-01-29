
use <../../../Vitamins/Vitamins/Fasteners/Screws/High_Low_Screw_Vitamin.scad>
use <../../../Vitamins/Vitamins/Actuators/MiniServo_Vitamin.scad>

cableDiameter=6;
cablePullRadius=calculateHornHoleRadius(2)-cableDiameter/2;

linkLength = 60;
linkThickness=27;

minkowskiSphere=6;

minimumLinkLength=40;
hingeThickness=2;


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
	//linkLength=30;
	tubSectionLen = 32;
	innerSectionLen = cablePullRadius* sqrt(2);
	cablePathCorner = [0,cablePullRadius-cableDiameter/2,tubSectionLen/2];
	difference(){
		union(){
			translate([0,cablePullRadius,0]){
				cylinder(h=linkLength,d=cableDiameter,center=true,$fn=6);
			}
			translate(cablePathCorner){
				rotate([-90,0,0])
					translate([0,0,tubSectionLen/2])
						cylinder(h=tubSectionLen,d=cableDiameter,center=true,$fn=6);// cable out-put tube
			}
			
			translate([0,cablePullRadius,-(tubSectionLen/2-cableDiameter/4)]){
				rotate([-90,0,0])
					translate([0,0,-innerSectionLen/2.5])
						cylinder(h=linkLength*2,d=cableDiameter,center=true,$fn=6);
			}
			//tab for screw holes
			translate(cablePathCorner){
				
				// void for flap
				//cube([cableDiameter,cableDiameter*3,cableDiameter*3]);
				translate([HiLoScrewLength(),+HiLoScrewDiameter()/2+cableDiameter/2,-cableDiameter/2+HiLoScrewDiameter()/2])
					rotate([0,90,0])
						HiLoScrew();
			}
			
		}
//		translate(cablePathCorner){
//			//flap
//			translate([1,-.1,0])
//				#cube([cableDiameter-2,cableDiameter*3-2,cableDiameter*3-2]);
//		}
//		
	}
}

module knotch(orentation, negative,linkThickness){
	difference(){
		union(){
			knotchHalf(orentation, negative){
				children(0);
			}
			
			mirror([0,0,1])
					knotchHalf(orentation, negative){
						translate([0,0,-.1])
							children(0);
					}
			// hinge keep-away //TODO make these no longer magic numbers
			cube([5,8,linkThickness+1], center=true);		
		}
		// THis is the hinge shape itself //TODO make these no longer magic numbers
		cube([10,hingeThickness,linkThickness+1.1], center=true);		
	}
}

function getLinkLengthBounded(a) = (a[3]<minimumLinkLength?minimumLinkLength:a[3]);

module cableLink(input=[0,-45,45,25,10,15],cablePullRadius=5,linkThickness){
	echo(input);
	linkLength=getLinkLengthBounded(input);

	
	inOrentation =  input[0];
	inNeg=input[1];
	inPos=input[2];
	
	translate([0,0,linkThickness/2])

	difference(){
		intersection(){
			minkowski(){
				cube([linkLength-minkowskiSphere/2,linkThickness-minkowskiSphere,linkThickness-minkowskiSphere+.2],center=true);// finger joint brick
				sphere(minkowskiSphere/2);
			}
			cube([linkLength,linkThickness,linkThickness],center=true);// finger joint brick
		}
		union(){// all the cut outs
			translate([-linkLength/2+minimumLinkLength/2,0,0])
			rotate([inOrentation,0,0]){	// rotate the joint to the specified orentation	
				
				knotch(inPos,inNeg,linkThickness){// hinge section
					translate([-.5,1,0])
					
					
						cube([linkThickness*1.1,linkThickness*1.1,linkThickness*1.1]);// hinge cutter, this could be more elegant...
					
				}
				translate([-.1,0,0])
				rotate([0,90,0]){
					
					cylinder(h=linkLength+minkowskiSphere,d=cableDiameter,center=true);// center tube
					
					// string lines
					guideTubes(cablePullRadius=cablePullRadius,linkLength = linkLength  );
					mirror([0,1,0])
						guideTubes(cablePullRadius=cablePullRadius,linkLength = linkLength  );
				}
				
			}
			
		}
	}

	
}

function getCurlOrentation(input) = (input[0]==0?input[2]/2:0);

function getCurlTranslateVector(input) =(sin(getCurlOrentation(input))*(getLinkLengthBounded(input)/2-minimumLinkLength/2));

//TODO this function is not yet working
module moveFromLinkCenterToJointCenter(input){
	linkCurlVector=[0,0,getCurlOrentation(input)];
	translationOffset = (getLinkLengthBounded(input)-minimumLinkLength)/2;
	translate([translationOffset,0,0])
	rotate(linkCurlVector)
	{
		translate([0,translationOffset,0])
		children();
	}
}

module curlLink(linkCurlVector,input,linkThickness){
	cubeVector=[getLinkLengthBounded(input),linkThickness,linkThickness];
	curlTranslate=getCurlTranslateVector(input);
	if(getCurlOrentation(input) != 0){
		difference(){
			children(0);
			translate([-getLinkLengthBounded(input)/2+minimumLinkLength/2,-linkThickness/2,0])
				cube([getLinkLengthBounded(input)-minimumLinkLength/2+.1,linkThickness,linkThickness]);
		}
		
		moveFromLinkCenterToJointCenter(input){
				difference(){
					children(0);
					translate([-getLinkLengthBounded(input)/2+minimumLinkLength/4,0,linkThickness/2])
						cube([minimumLinkLength/2+.1,linkThickness,linkThickness], center=true);
				}
				
			}
	}else{
		children(0);
	}
}

module basicLeg(input, depth=0,cablePullRadius=5,linkThickness){
	
	echo("Link #",depth," thicness ",linkThickness);
	sphereOffset=15;
	linkCurlVector=[0,0,getCurlOrentation(input[depth])];
	translate([getLinkLengthBounded(input[depth])/2,0,0]){
		curlLink(linkCurlVector,input[depth],linkThickness){
			cableLink(input[depth],cablePullRadius=cablePullRadius,
		            linkThickness=linkThickness);
		}
		rotate(linkCurlVector)
			translate([getLinkLengthBounded(input[depth])/2,0,0]){
				if(depth < (len(input)-1)){				
							basicLeg(	input, 
										depth+1,// increment the depth to walk down the list
										cablePullRadius=cablePullRadius,
										linkThickness=linkThickness);
				}else{
					translate([-getCurlTranslateVector(input[depth])*2,getCurlTranslateVector(input[depth]),linkThickness/2])
						difference(){
						
							translate([input[depth][3]/2-sphereOffset,0,0])
								sphere(5+sphereOffset, but);
							cube([linkLength,linkThickness*5,linkThickness*5],center=true);
						}
				}
			}
	}
	
}

module placePilarBlock(thickness){
	translate([-4,-(10+cableDiameter)/2,0]){
		children(0);
	}
	translate([-4,(10+cableDiameter)/2,0]){
		children(0);
	}
}

module pilarBlock(thickness){
	placePilarBlock(thickness)
		cylinder(thickness-.1,d=10);// cable pilar
	
}


function calcServoDistanceForBoltOverlap(incrementAngle) = (MiniServoRestrainingScrewDistance()/2)/tan(incrementAngle/2);


module radialServoBlock(numberOfServos=3, thickness){
	rangeOfSweep=230;
	startAngle=(-rangeOfSweep/2);
	increment=rangeOfSweep/numberOfServos;
	retainingDiskDiameter = calcServoDistanceForBoltOverlap(increment)*3-2;
	difference(){
		union(){
			translate([-retainingDiskDiameter/3+1,0,0])
				cylinder(thickness/2-cableDiameter,d=retainingDiskDiameter);// base circle
			pilarBlock(thickness);

		}
		placePilarBlock(thickness){
			translate([0,0,HiLoScrewLength()-.2])
				HiLoScrew();
		}
		translate([-MiniServoRestrainingScrewDistance()/2,0,0])
		for (i = [startAngle+(increment/2):increment:(rangeOfSweep+startAngle)-1]) { 
			echo("Servo at ",i, " at distance ",calcServoDistanceForBoltOverlap(increment));
			rotate([0,0,-i+180])
				translate([calcServoDistanceForBoltOverlap(increment),-MiniServoBaseLength()/2,thickness/2-MiniServoHeight()+MiniServoWingsHeight()])
					MiniServoMotor(true, 2, true, .2);
		}
		translate([0,-thickness/2+minkowskiSphere/2,-.1])
		cube([thickness,thickness-minkowskiSphere,thickness+.2]);// finger joint brick
	}
}


difference(){
	translate([-40,0,0]){
		basicLeg(input = [ [90,-45,45,linkLength/2],
		                   [0,-45,45,linkLength/2],
		                   [0,0,90,linkLength]
		                  ],
		                  cablePullRadius=cablePullRadius,
		                  linkThickness=linkThickness
		                  );
		radialServoBlock(3,linkThickness);
	}
	//#cube([180,180,.1],center=true);
}