
use <../../../Vitamins/Vitamins/Fasteners/Screws/High_Low_Screw_Vitamin.scad>
use <../../../Vitamins/Vitamins/Actuators/MiniServo_Vitamin.scad>

cableDiameter=3;
cablePullRadius=calculateHornHoleRadius(2);

linkLength = 60;
linkThickness=cablePullRadius*2.7;





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
	cablePathCorner = [cableDiameter/3-1.8,cablePullRadius - cableDiameter,tubSectionLen/2 -cableDiameter];
	difference(){
		union(){
			translate([0,cablePullRadius,0]){
				cylinder(h=tubSectionLen,d=cableDiameter,center=true);
			}
			translate([0,cablePullRadius,tubSectionLen/2-cableDiameter/2]){
				rotate([-70,0,0])
					translate([0,0,tubSectionLen/2])
						cylinder(h=tubSectionLen,d=cableDiameter,center=true);
			}
			
			translate([0,cablePullRadius,-(tubSectionLen/2-cableDiameter/4)]){
				rotate([-45,0,0])
					translate([0,0,-innerSectionLen/2.5])
						cylinder(h=innerSectionLen,d=cableDiameter,center=true);
			}
			//tab for screw holes
			translate(cablePathCorner){
				
				// void for flap
				cube([cableDiameter,cableDiameter*3,cableDiameter*3]);
				translate([HiLoScrewLength()-1,cableDiameter,cableDiameter])
					rotate([0,90,0])
						HiLoScrew();
			}
			
		}
		translate(cablePathCorner){
			//flap
			translate([1,-.1,0])
				#cube([cableDiameter-2,cableDiameter*3-2,cableDiameter*3-2]);
		}
		
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
			// hinge keep-away
			cube([cableDiameter,cableDiameter+5,linkThickness+1], center=true);		
		}
		// THis is the hinge shape itself
		cube([cableDiameter+.1,cableDiameter-1,linkThickness+1.1], center=true);		
	}
}


module cableLink(input=[0,-45,45,25,10,15],cablePullRadius=5,linkThickness){
	echo(input);
	linkLength= input[3];
	inOrentation =  input[0];
	inNeg=input[1];
	inPos=input[2];
	minkowskiSphere=6;
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

module basicLeg(input, depth=0,cablePullRadius=5,linkThickness){
	echo("Link #",depth);
	sphereOffset=15;
	translate([input[depth][3]/2,0,0]){
		if(depth ==1){
			color("blue"){
				cableLink(input[depth],cablePullRadius=cablePullRadius,
		                  linkThickness=linkThickness);
			}
		}else{
			color("green"){
				cableLink(input[depth],cablePullRadius=cablePullRadius,
		                  linkThickness=linkThickness);
			}
		}
		if(depth < (len(input)-1)){
			translate([input[depth][3]/2,0,0])
				basicLeg(	input, 
							depth+1,// increment the depth to walk down the list
							cablePullRadius=cablePullRadius,
							linkThickness=linkThickness);
		}else{
			translate([0,0,linkThickness/2])
				difference(){
				
					translate([input[depth][3]/2-sphereOffset,0,0])
						sphere(5+sphereOffset, but);
					cube([linkLength,linkThickness*5,linkThickness*5],center=true);
				}
		}
	}
	
}

module placePilarBlock(thickness){
	translate([-cableDiameter-4,-(15+cableDiameter)/2,0]){
		children(0);
	}
	translate([-cableDiameter-4,(15+cableDiameter)/2,0]){
		children(0);
	}
}

module pilarBlock(thickness){
	placePilarBlock(thickness)
		cylinder(thickness-.1,d=15);// cable pilar
	
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
	#cube([180,180,.1],center=true);
}