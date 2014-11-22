
xDimen = 200;
yDimen = 120;
zDimen = 210;

xTip = -75;
yTip = -90;

module getStlInput(){
	import("amputeeLeftModel.stl", convexity=3);
	
}

module getMount(){
	difference(){
		cylinder(r=25,h=30);
		for(i=[0:30:359]){
			rotate([0,0,i])
				translate([20,0,.1])
					cylinder(r=2.5,h=30);
		}
		translate([0,0,.1])
			cylinder(r=5,h=30);
	}
}

module getCupShell(){
	
	cupScale = .1;
	
	
	translate([0,(yDimen*cupScale)/2,.1]){
		scale(1+cupScale){
			getStlInput();
		}	
	}
	translate([xTip,yTip,zDimen]){
		getMount();
	}
}



difference(){
	getCupShell();
	getStlInput();
	// pin hole
	translate([xTip,yTip,zDimen-30])
		cylinder(r=5,h=60);
}