// created by IndiePandaaaaa|Lukas
TOLERANCE = 0.2; // to the pen
CHAMFER = 1;
$fn = 75;

PEN_DIAMETER_LARGE = 12;
PEN_DIAMETER_SMALL = 3.5;
PEN_TIP_HEIGHT = 13; // distance between the large and small diameter in height

PEN_STAND_ANGLE = 42; // not yet implemented

PEN_STAND_ADDITIONAL_RADIUS = 14;
PEN_STAND_ADDITIONAL_SIZE = 3;

rotate_extrude() {
    polygon([
            [PEN_DIAMETER_LARGE / 2 + TOLERANCE, 0],
            [PEN_DIAMETER_LARGE / 2 + TOLERANCE + PEN_STAND_ADDITIONAL_RADIUS, 0],
            [PEN_DIAMETER_LARGE / 2 + TOLERANCE + PEN_STAND_ADDITIONAL_RADIUS, PEN_TIP_HEIGHT +
                PEN_STAND_ADDITIONAL_SIZE * 2 - CHAMFER],
            [PEN_DIAMETER_LARGE / 2 + TOLERANCE + PEN_STAND_ADDITIONAL_RADIUS - CHAMFER, PEN_TIP_HEIGHT +
                PEN_STAND_ADDITIONAL_SIZE * 2],
            [PEN_DIAMETER_LARGE / 2 + TOLERANCE + PEN_STAND_ADDITIONAL_SIZE / 2, PEN_TIP_HEIGHT +
                PEN_STAND_ADDITIONAL_SIZE * 2],
            [PEN_DIAMETER_LARGE / 2 + TOLERANCE, PEN_TIP_HEIGHT + PEN_STAND_ADDITIONAL_SIZE],
            [PEN_DIAMETER_SMALL / 2 + TOLERANCE, PEN_STAND_ADDITIONAL_SIZE],
            [PEN_DIAMETER_LARGE, PEN_STAND_ADDITIONAL_SIZE],
            [PEN_DIAMETER_LARGE, 0],
        ]);
}