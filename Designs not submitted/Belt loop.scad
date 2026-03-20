// Variables
beltHeight = 10;
perimeterThickness = 2.5;
beltLoopWidth=8;
beltLoopDepth=40;

// Import variables from Base_Shape_Volume.scad
include <../La_Frite_Case/Scad/Base_Shape_Volume.scad>

// Draw perimeter
module perimeter() {
    difference(){
        // Spawn in slightly larger object
        resize([beltLoopWidth+perimeterThickness*2,beltLoopDepth+perimeterThickness*2,beltHeight]) innerShape();
        
        // Cutoff center
        translate([-beltLoopWidth/2,-beltLoopDepth/2,-beltHeight/2]) cube([beltLoopWidth,beltLoopDepth,beltHeight]);
    }
}

perimeter();