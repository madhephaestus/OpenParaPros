

module link(length=20,scaleFactor=.9,maximumDepth=3,depthCurrent=0,branchingAngle=60,branchingOrder=2){
	children(0);
<<<<<<< HEAD
	for(i = [-branchingOrder:1:branchingOrder]){
=======
	for(i = [0:(branchingAngle*2)/(branchingOrder):branchingAngle]){
>>>>>>> branch 'master' of https://github.com/madhephaestus/OpenParaPros.git
		translate([0,0,length]){
<<<<<<< HEAD
			rotate([i*branchingAngle,0,0]){				
=======

			rotate([i-20,0,0]){				
>>>>>>> branch 'master' of https://github.com/madhephaestus/OpenParaPros.git
				if(maximumDepth>depthCurrent){
					link(length*scaleFactor,scaleFactor,maximumDepth,depthCurrent+1,branchingAngle,branchingOrder){
						scale([scaleFactor,scaleFactor,scaleFactor]){
							children(0);
						}
						//pass through the second object to the next layer down with out scaling
						children(1);
					}
<<<<<<< HEAD
				}else{
					//children(1);
=======
>>>>>>> branch 'master' of https://github.com/madhephaestus/OpenParaPros.git
				}
				//At each intersection
				children(1);
				
			}
		}
	}
}


<<<<<<< HEAD
myScale=.5;
myHeight=100;
=======
myScale=.7;
myHeight=120;
>>>>>>> branch 'master' of https://github.com/madhephaestus/OpenParaPros.git

<<<<<<< HEAD
link(length=myHeight,scaleFactor=myScale,maximumDepth=5,branchingAngle=60,branchingOrder=1){
=======
link(length=myHeight,scaleFactor=myScale,maximumDepth=6,branchingAngle=80,branchingOrder=2){
>>>>>>> branch 'master' of https://github.com/madhephaestus/OpenParaPros.git
	cylinder(h=myHeight,d=10,center=false);
	rotate([0,90,0])
		cylinder(h=myHeight/5,d=2,center=false);
}
