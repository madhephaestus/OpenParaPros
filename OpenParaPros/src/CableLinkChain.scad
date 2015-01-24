

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
module knotch(orentation, negative){
	knotchHalf(orentation, negative)
		children(0);
	// this is the center line of the joint
	mirror([0,0,1])
			knotchHalf(orentation, negative)
				translate([0,0,-.1])
					children(0);
			
}


module cableLink(input=[0,-45,45,25,10,15]){
	echo(input);
	linkWidth = input[5];
	linkThickness = input[4];
	linkLength= input[3];
	inOrentation =  input[0];
	inNeg=input[1];
	inPos=input[2];
	
	difference(){
		cube([linkLength,linkWidth,linkThickness],center=true);// finger joint brick
		
			rotate([inOrentation,0,0]){	// rotate the joint to the specified orentation	
				knotch(inPos,inNeg)
					translate([-.15,.1,0])
						cube([linkLength*1.1,linkWidth*1.1,linkThickness*1.1]);
				
			
		}
	}
	
}

module basicLeg(input, depth=0){
	echo("Link #",depth);
	translate([input[depth][3]/2,0,0]){
		if(depth ==1){
			color("blue"){
				cableLink(input[depth]);
			}
		}else{
			color("green"){
				cableLink(input[depth]);
			}
		}
		if(depth < (len(input)-1)){
			translate([input[depth][3]/2,0,0])
				basicLeg(input, depth+1);
		}
	}
	
}

linkLength = 25;
linkThickness=10;
linkWidth=15;

basicLeg(input = [ [0,-45,45,linkLength/2,linkThickness,linkWidth],
                   [90,-45,45,linkLength/1.5,linkThickness,linkWidth],
                   [90,0,90,linkLength,linkThickness,linkWidth]
                  ]); 