

module link(length=20,scaleFactor=.9,maximumDepth=3,depthCurrent=0,branchingAngle=60,branchingOrder=2){
	children(0);
	for(i = [-branchingOrder:1:branchingOrder]){
		translate([0,0,length]){
			rotate([i*branchingAngle,0,0]){				
				if(maximumDepth>depthCurrent){
					link(length*scaleFactor,scaleFactor,maximumDepth,depthCurrent+1,branchingAngle,branchingOrder){
						scale([scaleFactor,scaleFactor,scaleFactor]){
							children();
						}
					}
				}else{
					//children(1);
				}
			}
		}
	}
}


myScale=.5;
myHeight=100;

link(length=myHeight,scaleFactor=myScale,maximumDepth=5,branchingAngle=60,branchingOrder=1){
	cylinder(h=myHeight,d=10,center=false);

	cylinder(h=myHeight/5,d=10,center=false);
}
