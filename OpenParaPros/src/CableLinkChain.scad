
cableDiameter=5;

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
	tubSectionLen = linkLength/2;
	innerSectionLen = cablePullRadius* sqrt(2);
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
		
			rotate([inOrentation,0,0]){	// rotate the joint to the specified orentation	
				union(){
					knotch(inPos,inNeg){
						translate([-.5,1,0])
							cube([linkLength*1.1,linkWidth*1.1,linkThickness*1.1]);
						
					}
					translate([-.1,0,0])
					rotate([0,90,0]){
						
						cylinder(h=linkLength,d=cableDiameter,center=true);
						
						
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
				basicLeg(input, depth+1,cablePullRadius=cablePullRadius,
		                  linkThickness=linkThickness,
		                  linkWidth=linkWidth);
		}
	}
	
}

linkLength = 100;
linkThickness=25;
linkWidth=25;
cablePullRadius=8;
basicLeg(input = [ [0,-45,45,linkLength/2],
                   [90,-45,45,linkLength/2],
                   [90,0,90,linkLength]
                  ],
                  cablePullRadius=cablePullRadius,
                  linkThickness=linkThickness,
                  linkWidth=linkWidth); 