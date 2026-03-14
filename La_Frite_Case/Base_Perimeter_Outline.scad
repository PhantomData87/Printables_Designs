// Previous variables from Base_Shape_Volume
//$fn = $preview ? 5 : 100;
//tolerance = 0.1;
//aWidth = 56+tolerance;
//aDepth = 65.5+tolerance;
//aHeight = 15;
//edgeRadius = 2;

// New Variables
perimeterThickness=4;

// Import variables from Base_Shape_Volume.scad
include <Base_Shape_Volume.scad>

// Draw perimeter
module perimeter() {
    difference(){
        // Spawn in slightly larger object
        resize([aWidth+perimeterThickness,aDepth+perimeterThickness,aHeight]) innerShape();
        
        // Spawn in example
        innerShape();
        
        // Cutoff
    }
}