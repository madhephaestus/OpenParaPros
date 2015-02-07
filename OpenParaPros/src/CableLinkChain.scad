
use <../../../Vitamins/Vitamins/Fasteners/Screws/High_Low_Screw_Vitamin.scad>
use <../../../Vitamins/Vitamins/Actuators/MiniServo_Vitamin.scad>

cableDiameter=5;
cablePullRadius=calculateHornHoleRadius(2)-cableDiameter/2;

linkLength = 60;
linkThickness=22;

minkowskiSphere=6;

minimumLinkLength=40;
hingeThickness=2;
ballendoffset=7;


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

module moveFromCenterToCablePathCorner(){
	
}


module guideTubes(cablePullRadius=5,linkLength=50){
	//linkLength=30;
	tubSectionLen = 32;
	innerSectionLen = cablePullRadius* sqrt(2);
	cablePathCorner = [0,cablePullRadius,tubSectionLen/2];
	filletDiameter=cableDiameter/2;
	difference(){
		union(){
			translate([0,cablePullRadius,minimumLinkLength/4]){
				cylinder(h=linkLength*2,d=cableDiameter,center=true,$fn=6);
			}
			translate(cablePathCorner){
				rotate([-90,0,-90])
					translate([0,0,tubSectionLen/2])
						cylinder(h=tubSectionLen,d=HiLoScrewDiameter()-1,center=true,$fn=6);// cable out-put tube
			}
			
			translate([0,cablePullRadius,-(tubSectionLen/2-cableDiameter/4)]){
				rotate([-90,0,0])
					translate([0,0,-innerSectionLen/2.5])
						cylinder(h=linkLength*2,d=cableDiameter,center=true,$fn=6);// cable adjustment hole
				difference(){
					translate([0,-cablePullRadius/2-.1,-(minimumLinkLength-tubSectionLen)/2]){
						cube([cableDiameter,cablePullRadius,(minimumLinkLength-tubSectionLen)+6], center=true);// Pull path
					}
					translate([0,-cablePullRadius/4-filletDiameter/2-.2,cablePullRadius/4+filletDiameter/2+.2])
						rotate([0,90,0])
							cylinder(h=cableDiameter+.1,d=filletDiameter,center=true,$fn=100);// cable adjustment hole
				}
				
			}
			//tab for screw holes
			translate(cablePathCorner){
				
				// void for flap
				//cube([cableDiameter,cableDiameter*3,cableDiameter*3]);
				rotate([0,0,90])
				translate([HiLoScrewLength(),-HiLoScrewDiameter(),0])
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
			translate([0,0,-minkowskiSphere/2])
			minkowski(){
				cube([linkLength-minkowskiSphere/2,linkThickness-minkowskiSphere,linkThickness],center=true);// finger joint brick
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
					
					translate([0,0,(getLinkLengthBounded(input)-minimumLinkLength)/2]){
						// center tube
						cylinder(h=linkLength+.3,d=hingeThickness+1,center=true);
						translate([0,0,3])
						cylinder(h=getLinkLengthBounded(input)/2+.2-3,d1=hingeThickness+1,d2=cablePullRadius*2-1);
					}
					
					// string lines
					guideTubes(cablePullRadius=cablePullRadius,linkLength = linkLength  );
					mirror([0,1,0])
						guideTubes(cablePullRadius=cablePullRadius,linkLength = linkLength  );
				}
				
			}
			
		}
	}

	
}


function getCurlOrentation(input) = (input[0]==0?(input[2]==45?input[2]/1.5:input[2]/1.5):0);
//function getCurlOrentation(input) = (input[0]==0?0:0);

function getCurlTranslateVector(input) =((getLinkLengthBounded(input)/2-minimumLinkLength/2));

//TODO this function is not yet working
module moveFromLinkCenterToJointCenter(input){
	linkCurlVector=[0,0,getCurlOrentation(input)];
	translationOffset = (getLinkLengthBounded(input)-minimumLinkLength)/2;
	translate([-translationOffset,0,0])
		rotate(linkCurlVector)
			translate([translationOffset,0,0])
				children();
	
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
				// ading a tube to round out the joint
				translate([-getCurlTranslateVector(input),0,linkThickness/2])
					difference(){
						cylinder(h=linkThickness,d=hingeThickness,center=true,$fn=100);// center tube of joint
						cylinder(h=cableDiameter,d=hingeThickness+.1,center=true,$fn=100);// center tube of joint
					}
		}
		
	}else{
		children(0);
	}
}

module basicLeg(input, depth=0,cablePullRadius=5,linkThickness){
	
	echo("Link #",depth," thicness ",linkThickness);

	linkCurlVector=[0,0,getCurlOrentation(input[depth])];
	sphereDiameter = linkThickness*1.5;
	translate([getLinkLengthBounded(input[depth])/2,0,0]){

		curlLink(linkCurlVector,input[depth],linkThickness){
			cableLink(input[depth],cablePullRadius=cablePullRadius,
		            linkThickness=linkThickness);
		}

		if(depth < (len(input)-1)){		
			moveFromLinkCenterToJointCenter(input[depth])
				translate([minimumLinkLength/2+(getLinkLengthBounded(input[depth])-minimumLinkLength)/2,0,0])
						basicLeg(	input, 
									depth+1,// increment the depth to walk down the list
									cablePullRadius=cablePullRadius,
									linkThickness=linkThickness);
		}else{
			moveFromLinkCenterToJointCenter(input[depth]){
				translate([0,0,linkThickness/2])
					difference(){
						translate([getCurlTranslateVector(input[depth])+ballendoffset,0,0])
							sphere(d=sphereDiameter, center= true);
						cube([getLinkLengthBounded(input[depth]),linkThickness*5,linkThickness*5],center=true);
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
	rangeOfSweep=200;
	startAngle=(-rangeOfSweep/2);
	increment=rangeOfSweep/numberOfServos;
	retainingDiskDiameter = calcServoDistanceForBoltOverlap(increment)*3-2;
	difference(){
		union(){

			cylinder(thickness/2-cableDiameter,d=retainingDiskDiameter);// base circle
			pilarBlock(thickness);

		}
		placePilarBlock(thickness){
			translate([0,0,HiLoScrewLength()-.2])
				HiLoScrew();
		}

		for (i = [startAngle+(increment/2):increment:(rangeOfSweep+startAngle)-1]) { 
			echo("Servo at ",i, " at distance ",calcServoDistanceForBoltOverlap(increment));
			//#cylinder(h=thickness,d=10);// base circle
			rotate([0,0,-i+180])
				translate([calcServoDistanceForBoltOverlap(increment),-MiniServoBaseLength()/2,thickness/2-MiniServoHeight()+MiniServoWingsHeight()])
					MiniServoMotor(true, 2, true, .2);
		}
		translate([0,-(thickness/2)-2.5,-.1])
		cube([minimumLinkLength,thickness+.2+5,thickness+.2]);// finger joint brick
		translate([thickness-10,-(retainingDiskDiameter/2),-.1])
		cube([thickness+10,retainingDiskDiameter,thickness+.2]);// finger joint brick
	}
}


difference(){
	translate([-50,0,0]){
		basicLeg(input = [ [90,-45,45,minimumLinkLength],
		                   [0,-45,45,minimumLinkLength],
		                   [0,0,45,minimumLinkLength],
		                   [0,0,45,minimumLinkLength]
		                  ],
		                  cablePullRadius=cablePullRadius,
		                  linkThickness=linkThickness
		                  );
		radialServoBlock(3,linkThickness);
	}
	#cube([180,180,.1],center=true);
}
