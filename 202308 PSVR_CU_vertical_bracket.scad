// created by IndiePandaaaaa|Lukas

use <Parts/Screw.scad>
use <Parts/ZipTiePoint.scad>

MATERIAL_THICKNESS = 2.5;
TOLERANCE = 0.1;

SQUARE_WIDTH = 7.7;
SQUARE_EDGE_OFFSET = 11.5;
BRACKET_DEPTH = 77;  // distance between standoff points
BRACKET_HEIGHT = 25;
CU_THICKNESS = 39;
SCREWS = 5;
SCREW_DIAMETER = 3.5;

SCREW_SOCKET_WIDTH = 14;
FN = 100;

difference() {
    linear_extrude(BRACKET_DEPTH + SQUARE_WIDTH * 2) {
        polygon([
                [0, 0],
                [SCREW_SOCKET_WIDTH + MATERIAL_THICKNESS, 0],
                [SCREW_SOCKET_WIDTH + MATERIAL_THICKNESS, CU_THICKNESS + TOLERANCE],
                [SCREW_SOCKET_WIDTH + MATERIAL_THICKNESS + BRACKET_HEIGHT,
                    CU_THICKNESS + TOLERANCE],
                [SCREW_SOCKET_WIDTH + MATERIAL_THICKNESS + BRACKET_HEIGHT,
                        CU_THICKNESS + TOLERANCE + MATERIAL_THICKNESS],
                [SCREW_SOCKET_WIDTH, CU_THICKNESS + TOLERANCE + MATERIAL_THICKNESS],
                [SCREW_SOCKET_WIDTH, (CU_THICKNESS + TOLERANCE) / 2 + MATERIAL_THICKNESS],
                [0, MATERIAL_THICKNESS],
            ]);
    }
    for (i = [0:SCREWS - 1]) {
        distance = BRACKET_DEPTH / SCREWS;
        translate([SCREW_SOCKET_WIDTH / 2, MATERIAL_THICKNESS, SQUARE_WIDTH * 2 + distance / 2 + distance * i]) rotate([
            270, 0, 0]) {
            screw(SCREW_DIAMETER, 12, true);
            cylinder(d = SCREW_DIAMETER * 3, h = CU_THICKNESS, $fn = FN);
        }
    }
    translate([SCREW_SOCKET_WIDTH + MATERIAL_THICKNESS + BRACKET_HEIGHT - SQUARE_EDGE_OFFSET *1.5,
        CU_THICKNESS, SQUARE_WIDTH])
        cube([SQUARE_WIDTH * 3, SQUARE_WIDTH + TOLERANCE, SQUARE_WIDTH + TOLERANCE]);
}