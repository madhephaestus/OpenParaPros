

module link(length=20,scaleFactor=.9,maximumDepth=3,depthCurrent=0,branchingAngle=60,branchingOrder=2){
	children(0);
	for(i = [-branchingAngle:(branchingAngle*2)/(branchingOrder-1):branchingAngle]){
		translate([0,0,length]){
			rotate([i,0,0]){				
				if(maximumDepth>depthCurrent){
					link(length*scaleFactor,scaleFactor,maximumDepth,depthCurrent+1,branchingAngle=60,branchingOrder=2){
						scale([scaleFactor,scaleFactor,scaleFactor]){
							children();
						}
					}
				}else{
					children(1);
				}
			}
		}
	}
}


myScale=.6;
myHeight=120;

link(length=myHeight,scaleFactor=myScale,maximumDepth=8,branchingAngle=60,branchingOrder=2){
	cylinder(h=myHeight,d=10,center=false);

	cylinder(h=myHeight/5,d=10,center=false);
}
