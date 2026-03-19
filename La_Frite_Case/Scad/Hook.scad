// Previous variables from Base_Shape_Volume
//$fn = $preview ? 5 : 100;
//tolerance = 0.4;
//aWidth = 56+tolerance;
//aDepth = 65.5+tolerance;
//aHeight = 15;
//edgeRadius = 2;

// Previous variables from Base_Perimeter_Outline
//perimeterThickness=4;

// Variables from Lower_Plate
rimCut = 1;
cornerSize = 6;

// New variables
hookHeight = 18;
hookWidth = cornerSize-1;
hookThickness = 1;

// Import variables from Base_Shape_Volume.scad
include <Base_Perimeter_Outline.scad>

module drawRim() {
    translate([0,0,0]) resize([hookWidth,hookThickness/10,(rimCut*10/10)], auto=[false,false,false]) cube();
    translate([0,0.1,0]) resize([hookWidth,hookThickness/10,(rimCut*9/10)], auto=[false,false,false]) cube();
    translate([0,0.2,0]) resize([hookWidth,hookThickness/10,(rimCut*8/10)], auto=[false,false,false]) cube();
    translate([0,0.3,0]) resize([hookWidth,hookThickness/10,(rimCut*7/10)], auto=[false,false,false]) cube();
    translate([0,0.4,0]) resize([hookWidth,hookThickness/10,(rimCut*6/10)], auto=[false,false,false]) cube();
    translate([0,0.5,0]) resize([hookWidth,hookThickness/10,(rimCut*5/10)], auto=[false,false,false]) cube();
    translate([0,0.6,0]) resize([hookWidth,hookThickness/10,(rimCut*4/10)], auto=[false,false,false]) cube();
    translate([0,0.7,0]) resize([hookWidth,hookThickness/10,(rimCut*3/10)], auto=[false,false,false]) cube();
    translate([0,0.8,0]) resize([hookWidth,hookThickness/10,(rimCut*2/10)], auto=[false,false,false]) cube();
    translate([0,0.9,0]) resize([hookWidth,hookThickness/10,(rimCut*1/10)], auto=[false,false,false]) cube();
}

module drawClaw() {
    union() {
        translate([0,1,0]) cube([hookWidth,5,hookThickness+2]);
        translate([0,1,3]) drawRim();
        difference() {
            translate([0,1+3.9,2.5]) rotate(a=[0,90,0]) cylinder(hookWidth,r=1.25);
            translate([0,6,1.1]) cube([hookWidth,3,2]);
        }
    }
}

module drawSmallerClaw() {
    difference() {
        union() {
            translate([0,0.7,0]) cube([hookWidth,5,hookThickness+2]);
            difference() {
                translate([0,1+4.2,2.5]) rotate(a=[0,90,0]) cylinder(hookWidth,r=1.25);
                translate([0,6.1-tolerance,-3.1]) cube([hookWidth,3,20]);
            }
            translate([0,0.7,3]) resize([0,0,0.5], false) drawRim();
        }
        translate([0,6.5-tolerance,-2]) cube([hookWidth,1,4]);
        translate([0,0,0]) cube([hookWidth,20,1]);
    }
}

module drawPaddedHook() {
    union() {
        cube([hookWidth,hookThickness,hookHeight]);
        translate([0,0.5,0]) drawClaw();
        translate([hookWidth,0.5,hookHeight]) rotate(a=[180,0,180]) drawClaw();
        translate([0,1,0]) cube([hookWidth,0.5,hookHeight]);
    }
}

module drawHook() {
    difference() {
        union() {
            cube([hookWidth,hookThickness,hookHeight]);
            translate([0,0.2,0]) drawSmallerClaw();
            translate([hookWidth,0.2,hookHeight]) rotate(a=[180,0,180]) drawSmallerClaw();
            translate([0,1,0]) cube([hookWidth,(tolerance/2),hookHeight]);
        }
        translate([0,0,1]) drawRim();
        translate([hookWidth,0,hookHeight-1]) rotate(a=[180,0,180]) drawRim();
        cube([hookWidth,2,1]);
        translate([0,0,hookHeight-1]) cube([hookWidth,2,1]);
    }
}

translate([0,0,0]) rotate([0,90,0]) drawHook();