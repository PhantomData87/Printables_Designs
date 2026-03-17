// Previous variables from Base_Shape_Volume
//$fn = $preview ? 5 : 100;
//tolerance = 0.1;
//aWidth = 56+tolerance;
//aDepth = 65.5+tolerance;
//aHeight = 15;
//edgeRadius = 2;

// Previous variables from Base_Perimeter_Outline
//perimeterThickness=4;

// Lower_plate similar variables
rimHeight = 7;
cornerSize=6;
boardOffsetZ=1; // About 1mm of space the board takes up
airFlowMaxHeight = rimHeight-boardOffsetZ*2-1;
boardAirFlowWidth=7.9;
boardAirFlowSpacer=1.5;
plasticHookWidth=boardAirFlowWidth*2;
floorHeight=1;
rimCut=1;

// New Variables
airFlowHeight=rimHeight-5;

// Import variables from Base_Shape_Volume.scad
include <Base_Perimeter_Outline.scad>

// Draw loose plate
module upperPlate() {
    union() {
        // Rim
        translate([0,0,(rimHeight/2)]) resize([0,0,rimHeight], auto=[false,false,false]) perimeter();
        
        // Floor
        translate([0,0,(floorHeight/2)]) resize([0,0,floorHeight], [false,false,false]) innerShape();
        
        // Inserts for cutout
        translate([-(aWidth/2)-(perimeterThickness*3/8),-(aDepth/2)+cornerSize+(plasticHookWidth+boardAirFlowSpacer)+(tolerance/2),rimHeight]) cube([(perimeterThickness/4),(aDepth)-cornerSize*2-(plasticHookWidth+boardAirFlowSpacer)-tolerance,(boardOffsetZ/2)]);
        translate([(aWidth/2)+(perimeterThickness/8),-(aDepth/2)+cornerSize+(tolerance/2),rimHeight]) cube([(perimeterThickness/4),(aDepth)-cornerSize*2-(plasticHookWidth+boardAirFlowSpacer)-tolerance,(boardOffsetZ/2)]);
    }
        
         // IO Extensions (Magic numbers beware!)
            // USB-C port
        translate([-(aWidth/2)+41.75,-(aDepth/2)-(perimeterThickness/2),rimHeight]) resize([8,perimeterThickness/2,2.5-(tolerance/2)]) cube();
}

module plateHoledUp() {
    airFlowPoints=[
        [0,0,0], // 0
        [perimeterThickness,0,0], // 1
        [perimeterThickness,boardAirFlowWidth,0], // 2
        [0,boardAirFlowWidth,0], // 3
        [0,0,airFlowMaxHeight], // 4
        [perimeterThickness,0,airFlowMaxHeight], // 5
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
        upperPlate();
        
        // Calculate for loop conditions
        holeStart=cornerSize;
        holeIncrement=boardAirFlowWidth+boardAirFlowSpacer;
        holeEnd=(aDepth)-cornerSize-boardAirFlowWidth;
        
        // Use a loop to etch in holes on both sides of board to provide airflow
        for (i=[holeStart:holeIncrement:holeEnd-plasticHookWidth-boardAirFlowSpacer]) translate([(aWidth/2),-(aDepth/2)+i,airFlowHeight]) polyhedron(airFlowPoints,airFlowFaces);
        for (i=[holeStart+plasticHookWidth+boardAirFlowSpacer:holeIncrement:holeEnd]) translate([-(aWidth/2)-perimeterThickness,-(aDepth/2)+i,airFlowHeight]) polyhedron(airFlowPoints,airFlowFaces);
    
        // IO Cuts (Magic numbers beware!)
            // Ethernet port
        translate([-(aWidth/2)+24.25+0.075+(tolerance/2),-(aDepth/2)-perimeterThickness,rimHeight-2-(tolerance/2)]) resize([16.5+tolerance,perimeterThickness,10]) cube();
            // Generic USB ports
        translate([-(aWidth/2)+9.8+(tolerance/2)+6,(aDepth/2),rimHeight-1.75-(tolerance/2)]) resize([13.6+tolerance,perimeterThickness,5.5]) cube();
        translate([-(aWidth/2)+27.9+(tolerance/2)+6,(aDepth/2),rimHeight-1.75-(tolerance/2)]) resize([13.6+tolerance,perimeterThickness,5.5]) cube();
            // HDMI port
        translate([-(aWidth/2)+7.2+(tolerance/2),-(aDepth/2)-perimeterThickness,rimHeight-1.5-(tolerance/2)]) resize([15.3+tolerance,perimeterThickness,2]) cube();
        
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
    
        // Cutout floor faces
            // GPIO cuts
                // 40 pin headers
        translate([-(aWidth/2)+0.25,-(aDepth/2)+cornerSize,0]) cube([5.9,aDepth-cornerSize*2,floorHeight]);
                // 4 pin headers
        translate([-(aWidth/2)+5.9+0.75,-(aDepth/2)+cornerSize+6.5,0]) cube([2.9,12,floorHeight]);
                // 3 pin headers
        translate([-(aWidth/2)+5.9+2.9+0.75+11,-(aDepth/2)+cornerSize+5.35,0]) cube([2.9,9,floorHeight]);
                // 4 pin headers left side
        translate([(aWidth/2)-10.35,-(aDepth/2)+cornerSize+3.65,0]) cube([2.9,12,floorHeight]);
            // Top Grill vents
    }
}
plateHoledUp();