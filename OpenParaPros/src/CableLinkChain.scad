

module cableLink(input=[0,-45,45,90,0,90,25,10,15]){
	echo(input);
	linkWidth = input[8];
	linkThickness = input[7];
	linkLength= input[6];
	inOrentation =  input[0];
	inNeg=input[1];
	inPos=input[2];
	outOrentation =  input[3];
	outNeg=input[4];
	outPos=input[5];
	
	
	translate([0,-linkWidth/2,0]){
		cube([linkLength,linkWidth,linkThickness]);
	}
}

module basicLeg(input, depth=0){
	echo("Link #",depth);
	if(depth ==1)
		#cableLink(input[depth]);
	else
		cableLink(input[depth]);
	if(depth < (len(input)-1)){
		translate([input[depth][6],0,0]){
			basicLeg(input, depth+1);
		}
	}
}

linkLength = 25;
linkThickness=10;
linkWidth=15;

basicLeg(input = [ [0,-45,45,90,0,90,linkLength/2,linkThickness,linkWidth],
                   [90,0,90,90,0,90,linkLength,linkThickness,linkWidth],
                   [90,0,90,90,0,90,linkLength,linkThickness,linkWidth]
                  ]); 