// Previous variables from Base_Shape_Volume
//$fn = $preview ? 5 : 100;
//tolerance = 0.4;
//aWidth = 56+tolerance;
//aDepth = 65.5+tolerance;
//aHeight = 15;
//edgeRadius = 2;

// Previous variables from Base_Perimeter_Outline
//perimeterThickness=4;

// New variables
beamHeight = 5;
rimHeight = beamHeight+6;
beamXOffset = 1; // Always add one to offset wall depth
cornerSize=6;
cornerStudOffsetX=3.8;
cornerStudOffsetY=4.5;
cornerStudOffsetYExtra=0.5;
cornerStudRadius=1; // Diameter of stud is around 3mm, but allowed a tolerance of 0.5mm
boardOffsetZ=1; // About 1mm of space the board takes up
airFlowMaxHeight = rimHeight-boardOffsetZ*2-beamHeight;
boardAirFlowWidth=5.6;
boardAirFlowSpacer=1.5;
floorHeight=1;
rimCut=1;

// Import variables from Base_Shape_Volume.scad
include <Base_Perimeter_Outline.scad>
// Include function from hook
use <Hook.scad>

// Draw loose plate
module bottomPlate() {
    union() {
        // Rim
        translate([0,0,(rimHeight/2)]) resize([0,0,rimHeight], auto=[false,false,false]) perimeter();
        
        // Corner filling bottom left
        union() {
            // Spawn in cylinder 
            translate([-(aWidth/2)-edgeRadius+cornerSize,-(aDepth/2)-edgeRadius+cornerSize,0]) cylinder(h=beamHeight, r=edgeRadius);
            // Fill in Gaps to align with cylinder
            translate([-(aWidth/2)-(edgeRadius/2)+beamXOffset,-(aDepth/2),0]) resize([cornerSize,cornerSize-edgeRadius,beamHeight], auto=[false,false,false]) cube();
            translate([-(aWidth/2)-(edgeRadius/2)+beamXOffset,-(aDepth/2),0]) resize([cornerSize-edgeRadius,cornerSize,beamHeight], auto=[false,false,false]) cube();
        }
        
        // Corner filling upper left
        union() {
            // Spawn in cylinder
            translate([-(aWidth/2)-edgeRadius+cornerSize,(aDepth/2)+edgeRadius-cornerSize,0]) cylinder(h=beamHeight, r=edgeRadius);
            // Fill in Gaps to align with cylinder
            translate([-(aWidth/2)-(edgeRadius/2)+beamXOffset,(aDepth/2)-(cornerSize-edgeRadius),0]) resize([cornerSize,cornerSize-edgeRadius,beamHeight], auto=[false,false,true]) cube();
            translate([-(aWidth/2)-(edgeRadius/2)+beamXOffset,(aDepth/2)-cornerSize,0]) resize([cornerSize-edgeRadius,cornerSize,beamHeight], auto=[false,false,true]) cube();
        }
        
        // Corner filling bottom right
        union() {
            // Spawn in cylinder
            translate([(aWidth/2)+edgeRadius-cornerSize,-(aDepth/2)-edgeRadius+cornerSize,0]) cylinder(h=beamHeight, r=edgeRadius);
            // Fill in Gaps to align with cylinder
            translate([(aWidth/2)-cornerSize,-(aDepth/2),0]) resize([cornerSize,cornerSize-edgeRadius,beamHeight], auto=[false,false,true]) cube();
            translate([(aWidth/2)-(cornerSize-edgeRadius),-(aDepth/2),0]) resize([cornerSize-edgeRadius,cornerSize,beamHeight], auto=[false,false,true]) cube();
        }
        
        // Corner filling top right
        union() {
            // Spawn in cylinder
            translate([(aWidth/2)+edgeRadius-cornerSize,(aDepth/2)+edgeRadius-cornerSize,0]) cylinder(h=beamHeight, r=edgeRadius);
            // Fill in Gaps to align with cylinder
            translate([(aWidth/2)-cornerSize,(aDepth/2)-(cornerSize-edgeRadius),0]) resize([cornerSize,cornerSize-edgeRadius,beamHeight], auto=[false,false,true]) cube();
            translate([(aWidth/2)-(cornerSize-edgeRadius),(aDepth/2)-cornerSize,0]) resize([cornerSize-edgeRadius,cornerSize,beamHeight], auto=[false,false,true]) cube();
        }
        
        // Corner Stud bottom left
        translate([-(aWidth/2)+cornerStudOffsetX,-(aDepth/2)+cornerStudOffsetY-cornerStudOffsetYExtra,beamHeight]) cylinder(h=boardOffsetZ, r=cornerStudRadius);
        
        // Corner Stud upper left
        translate([-(aWidth/2)+cornerStudOffsetX,(aDepth/2)-cornerStudOffsetY-cornerStudOffsetYExtra,beamHeight]) cylinder(h=boardOffsetZ, r=cornerStudRadius);
        
        // Corner Stud bottom right
        translate([(aWidth/2)-cornerStudOffsetX,-(aDepth/2)+cornerStudOffsetY-cornerStudOffsetYExtra,beamHeight]) cylinder(h=boardOffsetZ, r=cornerStudRadius);
        
        // Corner Stud upper right
        translate([(aWidth/2)-cornerStudOffsetX,(aDepth/2)-cornerStudOffsetY-cornerStudOffsetYExtra,beamHeight]) cylinder(h=boardOffsetZ, r=cornerStudRadius);
        
        // Floor
        translate([0,0,(floorHeight/2)]) resize([0,0,floorHeight], [false,false,false]) innerShape();
    }
}

module plateHoled() {
    airFlowPoints=[
        [0,0,0], // 0
        [perimeterThickness,0,0], // 1
        [perimeterThickness,boardAirFlowWidth,0], // 2
        [0,boardAirFlowWidth,0], // 3
        [0,boardAirFlowWidth,airFlowMaxHeight], // 4
        [perimeterThickness,boardAirFlowWidth,airFlowMaxHeight], // 5
    ];
    airFlowFaces=[
        [4,5,1,0], // Front
        [5,4,3,2], // Top/Back
        [4,0,3], // Left
        [5,2,1], // Right
        [0,1,2,3], // Bottom
    ];
    
    // Draw case airFlow spaces, cut space for i/o, and inserts
    difference() {
        // Refer to base plate to start modifying
        bottomPlate();
        
        // Calculate for loop conditions
        holeStart=cornerSize;
        holeIncrement=boardAirFlowWidth+boardAirFlowSpacer;
        holeEnd=(aDepth)-cornerSize;
        
        // Use a loop to etch in holes on both sides of board to provide airflow
        for (i=[holeStart:holeIncrement:holeEnd]) translate([(aWidth/2),-(aDepth/2)+i,beamHeight+boardOffsetZ]) polyhedron(airFlowPoints,airFlowFaces);
        for (i=[holeStart:holeIncrement:holeEnd]) translate([-(aWidth/2)-perimeterThickness,-(aDepth/2)+i,beamHeight+boardOffsetZ]) polyhedron(airFlowPoints,airFlowFaces);
    
        // IO Cuts (Magic numbers beware!)
            // USB-C port
        translate([-(aWidth/2)+cornerSize+0.8-(tolerance/2),-(aDepth/2)-perimeterThickness,beamHeight+boardOffsetZ-(tolerance/2)]) resize([8+tolerance,perimeterThickness,6]) cube();
            // Ethernet port
        translate([-(aWidth/2)+cornerSize+9.625-(tolerance/2),-(aDepth/2)-perimeterThickness,beamHeight-3-(tolerance/2)]) resize([16.5+tolerance,perimeterThickness,10]) cube();
            // HDMI port
        translate([-(aWidth/2)+cornerSize+27.925-(tolerance/2),-(aDepth/2)-perimeterThickness,beamHeight+boardOffsetZ+1-(tolerance/2)]) resize([15.3+tolerance,perimeterThickness,10]) cube();
            // IR sensor hole
        translate([(aWidth/2)-cornerSize-3.5-(tolerance/2)-1.7,(aDepth/2)+perimeterThickness,beamHeight+boardOffsetZ+2.25-(tolerance/2)]) rotate([90,0,0]) cylinder(h=perimeterThickness,r=1.8); 
            // Generic USB ports
        translate([(aWidth/2)-cornerSize-10.325-(tolerance/2)-13.6,(aDepth/2),beamHeight+boardOffsetZ-(tolerance/2)+1.25]) resize([13.6+tolerance,perimeterThickness,5.5]) cube();
        translate([(aWidth/2)-cornerSize-28.425-(tolerance/2)-13.6,(aDepth/2),beamHeight+boardOffsetZ-(tolerance/2)+1.25]) resize([13.6+tolerance,perimeterThickness,5.5]) cube();
        
        // Cutout inserts
        translate([-(aWidth/2)-(perimeterThickness*3/8)-(tolerance/2),-(aDepth/2)+cornerSize,rimHeight-(boardOffsetZ/2)-(tolerance/2)]) cube([(perimeterThickness/4)+tolerance,(aDepth)-cornerSize*2,(boardOffsetZ/2)+(tolerance/2)]);
        translate([(aWidth/2)+(perimeterThickness/8)-(tolerance/2),-(aDepth/2)+cornerSize,rimHeight-(boardOffsetZ/2)-(tolerance/2)]) cube([(perimeterThickness/4)+tolerance,(aDepth)-cornerSize*2,(boardOffsetZ/2)+(tolerance/2)]);
        
        // Cutout rim
        resize([aWidth+8.1,aDepth+8.1,(rimCut*10/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+7.9,aDepth+7.9,(rimCut*9/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+7.7,aDepth+7.7,(rimCut*8/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+7.5,aDepth+7.5,(rimCut*7/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+7.3,aDepth+7.3,(rimCut*6/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+7.1,aDepth+7.1,(rimCut*5/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+6.9,aDepth+6.9,(rimCut*4/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+6.7,aDepth+6.7,(rimCut*3/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+6.5,aDepth+6.5,(rimCut*2/10)], auto=[false,false,false]) perimeter();
        resize([aWidth+6.3,aDepth+6.3,(rimCut*1/10)], auto=[false,false,false]) perimeter();
        
        // Cutout spot for hook
            // bottom right
        translate([(aWidth/2)+(perimeterThickness/2),-(aDepth/2)+0.5-(tolerance/2),0]) rotate([0,0,90]) drawPaddedHook();
        translate([(aWidth/2)+(perimeterThickness/2),-(aDepth/2)+0.5+(tolerance/2),0]) rotate([0,0,90]) drawPaddedHook();
            // upper left
        translate([-(aWidth/2)-(perimeterThickness/2),(aDepth/2)-0.5-(tolerance/2),0]) rotate([0,0,-90]) drawPaddedHook();
        translate([-(aWidth/2)-(perimeterThickness/2),(aDepth/2)-0.5+(tolerance/2),0]) rotate([0,0,-90]) drawPaddedHook();
    }  
}
plateHoled();