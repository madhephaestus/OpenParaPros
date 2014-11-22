
xDimen = 200;
yDimen = 120;
zDimen = 210;

xTip = -95;
yTip = -100;

module placeMount(){
	translate([xTip,yTip,zDimen])
		rotate([10,-25,0])
			children();
}

module getStlInput(){
	import("amputeeLeftModel.stl", convexity=3);
	
}

module getMount(){
	difference(){
		cylinder(r=25,h=30);
		for(i=[0:60:359]){
			rotate([0,0,i])
				translate([20,0,.1])
					cylinder(r=2.5,h=30);
		}
	}
}

module getCupShell(){
	
	cupScale = .1;
	
	
	translate([0,(yDimen*cupScale)/2,.1]){
		scale(1+cupScale){
			getStlInput();
		}	
	}
	placeMount(){
		getMount();
	}
}



difference(){
	getCupShell();
	getStlInput();
	// pin hole
	placeMount(){
		translate([0,0,-30])
			cylinder(r=5,h=60);
	}
}