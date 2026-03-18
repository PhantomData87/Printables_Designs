// Import objects
use <Lower_plate.scad>
use <Upper_plate.scad>
$fn = $preview ? 5 : 100;

union() {
    plateHoled();
    rotate(a=[180,0,180]) translate([0,0,-18]) plateHoledUp();
}