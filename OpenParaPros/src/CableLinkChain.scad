

module cableLink(input=[0,-45,45,90,0,90,25,10,15]){
	echo(input);
	linkWidth = input[5];
	linkThickness = input[4];
	linkLength= input[3];
	inOrentation =  input[0];
	inNeg=input[1];
	inPos=input[2];
	
	translate([0,-linkWidth/2,0]){
		difference(){
			cube([linkLength,linkWidth,linkThickness]);
			rotate([inOrentation,0,0]){
				intersection(){
					cube([linkLength,linkWidth,linkThickness]);
				}
			}

		}
	}
}

module basicLeg(input, depth=0){
	echo("Link #",depth);
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
		translate([input[depth][3],0,0]){
			basicLeg(input, depth+1);
		}
	}
}

linkLength = 25;
linkThickness=10;
linkWidth=15;

basicLeg(input = [ [0,-45,45,linkLength/2,linkThickness,linkWidth],
                   [90,0,90,linkLength,linkThickness,linkWidth],
                   [90,0,90,linkLength,linkThickness,linkWidth]
                  ]); 