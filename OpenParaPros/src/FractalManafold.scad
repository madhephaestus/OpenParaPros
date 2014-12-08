

module link(length=20,scaleFactor=.9,minimumLength=30,branchingAngle=60,branchingOrder=2){
	children();
	for(i = [-branchingAngle:(branchingAngle*2)/(branchingOrder-1):branchingAngle]){
		translate([0,0,length]){
			rotate([i,0,0]){				
				if(length>minimumLength){
					link(length*scaleFactor,scaleFactor,minimumLength,branchingAngle,branchingOrder){
						scale([scaleFactor,scaleFactor,scaleFactor]){
							children();
						}
					}
				}
			}
		}
	}
}


myScale=.6;
myHeight=120;

link(length=myHeight,scaleFactor=myScale,minimumLength=myHeight*.5,branchingAngle=135,branchingOrder=6){
	cylinder(h=myHeight,d=30,center=false);
}
