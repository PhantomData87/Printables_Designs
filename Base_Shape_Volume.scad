// Reduce render time in preview
$fn = $preview ? 5 : 100;

// Approximation of measurement
tolerance = 0.1;
aWidth = 56+tolerance;
aDepth = 65.5+tolerance;
aHeight = 15;
edgeRadius = 2;

// Draw approximated height and size of Le-Frita board
module innerShape() {
    union() {
        // Corner upper right
        intersection() {
            // Spawn in cube to be sliced
            translate([0,0,0])
            cube([aWidth,aDepth,aHeight],center=true);
            
            translate([aWidth/2 - edgeRadius,aDepth/2- edgeRadius,0])
            cylinder(h=aHeight, r=edgeRadius, center=true);
        }

        // Corner bottom right
        intersection() {
            // Spawn in cube to be sliced
            translate([0,0,0])
            cube([aWidth,aDepth,aHeight],center=true);
            
            translate([aWidth/2 - edgeRadius,-(aDepth/2- edgeRadius),0])
            cylinder(h=aHeight, r=edgeRadius, center=true);
        }

        // Corner upper left
        intersection() {
            // Spawn in cube to be sliced
            translate([0,0,0])
            cube([aWidth,aDepth,aHeight],center=true);
            
            translate([-(aWidth/2 - edgeRadius),aDepth/2 - edgeRadius,0])
            cylinder(h=aHeight, r=edgeRadius, center=true);
        }

        // Corner bottom left
        intersection() {
            // Spawn in cube to be sliced
            translate([0,0,0])
            cube([aWidth,aDepth,aHeight],center=true);
            
            translate([-(aWidth/2 - edgeRadius),-(aDepth/2 - edgeRadius),0])
            cylinder(h=aHeight, r=edgeRadius, center=true);
        }
        
        // Spawn in a smaller cube to fill in
        cube([aWidth,aDepth-edgeRadius*2,aHeight],center=true);
        cube([aWidth-edgeRadius*2,aDepth,aHeight],center=true);
    }
}

// Render
//innerShape();