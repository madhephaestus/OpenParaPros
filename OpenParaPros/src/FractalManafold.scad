

module link(length=20,scaleFactor=.9,maximumDepth=3,depthCurrent=0,branchingAngle=60,branchingOrder=2){
	children(0);
	for(i = [0:(branchingAngle*2)/(branchingOrder):branchingAngle]){
		translate([0,0,length]){

			rotate([i-20,0,0]){				
				if(maximumDepth>depthCurrent){
					link(length*scaleFactor,scaleFactor,maximumDepth,depthCurrent+1,branchingAngle,branchingOrder){
						scale([scaleFactor,scaleFactor,scaleFactor]){
							children(0);
						}
						//pass through the second object to the next layer down with out scaling
						children(1);
					}
				}
				//At each intersection
				children(1);
				
			}
		}
	}
}


myScale=.7;
myHeight=120;

link(length=myHeight,scaleFactor=myScale,maximumDepth=6,branchingAngle=80,branchingOrder=2){
	cylinder(h=myHeight,d=10,center=false);
	rotate([0,90,0])
		cylinder(h=myHeight/5,d=2,center=false);
}
