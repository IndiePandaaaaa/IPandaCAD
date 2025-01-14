// created by IndiePandaaaaa | Lukas

// for use with Lamptron HDD Rubber Screws PRO - https://www.caseking.de/lamptron-hdd-rubber-screws-pro-red-molt-075.html?__shop=2

use <Structures/Hexagon.scad>
use <Variables/Threading.scad>

$fn = 75;

// HDD IronWolf 20TB 3,5″
//height_HDD = 26.1;
//width_HDD = 101.85;
//depth_HDD = 146.99;

MODEL_TOLERANCE = 0.15;
TOLERANCE_HDD = 1;

UBASE_THICKNESS = 4;
POST_DEPTH = 7;
POST_DEPTH_SCREW_IN = 16;

WIDTH_HDD = 101.5;
HEIGHT_HDD = 26.5;
FAN_CaseMountingSocket_DISTANCE = 105; // 105 mm is the distance between screws for an 120 mm fan

HDD_BOTTOM_SCREW_DEPTH = 41.3;
HDD_BOTTOM_SCREW_POS_X = 3.2;
HDD_SATA_CONNECTOR_WIDTH = 53;
HDD_SATA_CONNECTOR_POS_X = 7.8;
HDD_SATA_CONNECTOR_HEIGHT = 9;
HDD_SATA_CONNECTOR_CABLE_DEPTH = 39.5;

RUBBER_HEIGHT = 2.3;
RUBBER_WIDTH_ADDITIONAL = 1.3;
RUBBER_HEIGHT_INTERNAL = 1.5;
RUBBER_OD = 10;
RUBBER_OD_ID = 6.2;

SCREW_LENGTH = 12 + 2;  // additionally 2mm for less tolerance issues with threading
SCREW_SOCKET_WIDTH = 10;

FULLMODEL_DEPTH = SCREW_LENGTH + HDD_BOTTOM_SCREW_DEPTH + 55; // ~ 112 mm
FULLMODEL_HEIGHT = HEIGHT_HDD + UBASE_THICKNESS + RUBBER_HEIGHT + 0.5; // ~ 34 mm total height
FULLMODEL_WIDTH = UBASE_THICKNESS * 2 + TOLERANCE_HDD * 2 + WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL;

module UBase(depth, height, hdd_width, hdd_tolerance, thickness, tolerance = 0.1) {
  linear_extrude(height = depth) {
    polygon([
        [0, 0],
        [thickness / 2, 0],
        [thickness / 2, thickness / 2],
        [thickness, thickness / 2],
        [thickness, 0],
        [thickness + hdd_tolerance * 2 + hdd_width, 0],
        [thickness + hdd_tolerance * 2 + hdd_width, thickness / 2],
        [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2, thickness / 2],
        [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2, 0],
        [thickness + hdd_tolerance * 2 + hdd_width + thickness, 0],
        [thickness + hdd_tolerance * 2 + hdd_width + thickness, height],
        [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2 - tolerance / 2, height],
        [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2 - tolerance / 2,
            height + thickness / 2 - tolerance],
        [thickness + hdd_tolerance * 2 + hdd_width + tolerance / 2, height + thickness / 2 - tolerance],
        [thickness + hdd_tolerance * 2 + hdd_width + tolerance / 2, thickness],
        [thickness - tolerance / 2, thickness],
        [thickness - tolerance / 2, height + thickness / 2 - tolerance],
        [thickness / 2 + tolerance / 2, height + thickness / 2 - tolerance],
        [thickness / 2 + tolerance / 2, height],
        [0, height],
      ]);
  }
}

module MountingHolesHDD(rubber_od, rubber_od_id, cutout_height) {
  height = 12;
  hdd_screw_width = 95.25;
  hdd_screw_depth = 44.45;
  module Hole(rubber_od, rubber_od_id, height, cutout_height) {
    translate([0, 0, height / 2])
      cylinder(height, d = rubber_od_id, $fs = 0.4, center = true);
    translate([0, 0, -height / 2 + cutout_height])
      cylinder(height, d = rubber_od, $fs = 0.4, center = true);
    translate([0, -rubber_od_id / 4 * 1, -height / 2 + cutout_height])
      cylinder(height, d = rubber_od, $fs = 0.4, center = true);
    translate([0, -rubber_od_id / 4 * 2, -height / 2 + cutout_height])
      cylinder(height, d = rubber_od, $fs = 0.4, center = true);
    translate([0, -rubber_od_id / 4 * 3, -height / 2 + cutout_height])
      cylinder(height, d = rubber_od, $fs = 0.4, center = true);
    translate([0, -rubber_od_id / 4 * 4, -height / 2 + cutout_height])
      cylinder(height, d = rubber_od, $fs = 0.4, center = true);
    translate([0, -rubber_od_id, height / 2])
      cylinder(height, d = rubber_od, $fs = 0.4, center = true);
  }
  translate([0, 0, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
  translate([0, hdd_screw_depth, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
  translate([hdd_screw_width, 0, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
  translate([hdd_screw_width, hdd_screw_depth, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
}

module ConnectorSpacer(width, depth, height, offset_x, bottom_screw_depth) {
  translate([offset_x, -depth - bottom_screw_depth + 2, -.1])
    cube([width, depth, height + 0.2]);
}

module CaseMountingSocket(width, depth, height, distance, full_width, for_cutout_only = false, screw_additional_od = .0)
{
  module ScrewHole(width_CaseMountingSocket, depth_CaseMountingSocket, height_CaseMountingSocket, position_x) {
    // https://de.wikipedia.org/wiki/Kernloch
    //  Gewinde	Steigung	Kernloch (core hole)
    //  M4	    x0.7	3.3
    //  M3	    x0.5	2.5
    for (i = [0:2]) {
      translate([position_x, -0.01, height_CaseMountingSocket / 3 / 2 + height_CaseMountingSocket / 3 * i])
        rotate([-90, 0, 0])
          cylinder(h = depth_CaseMountingSocket + 0.02, d = (i == 1 ? core_hole_M3() : core_hole_M4()) +
            screw_additional_od, center = false);
    }
  }

  for (i = [0:1]) {
    translate([(full_width - width) * i, 0, 0]) {
      screw_hole_pos_x = (full_width - distance) / 2 + (width - (full_width - distance)) * i;
      if (!for_cutout_only) {
        difference() {
          cube([width, depth, height], center = false);
          ScrewHole(width, depth, height, screw_hole_pos_x);
        }
      } else {
        ScrewHole(width, depth, height, screw_hole_pos_x);
      }
    }
  }
}

module hddBayStackable() {
  union() {
    difference() {
      translate([0, FULLMODEL_DEPTH, 0]) rotate([90, 0, 0])
        UBase(FULLMODEL_DEPTH, FULLMODEL_HEIGHT, WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL,
        TOLERANCE_HDD, UBASE_THICKNESS);

      translate([UBASE_THICKNESS + TOLERANCE_HDD / 2 + RUBBER_OD / 2,
            HDD_BOTTOM_SCREW_DEPTH + SCREW_LENGTH + 2, 0]) {
        MountingHolesHDD(RUBBER_OD, RUBBER_OD_ID, UBASE_THICKNESS - RUBBER_HEIGHT_INTERNAL);
        ConnectorSpacer(HDD_SATA_CONNECTOR_WIDTH, HDD_SATA_CONNECTOR_CABLE_DEPTH, HDD_SATA_CONNECTOR_HEIGHT,
          HDD_SATA_CONNECTOR_POS_X - HDD_BOTTOM_SCREW_POS_X, HDD_BOTTOM_SCREW_DEPTH);
      }

      vent_width = FULLMODEL_DEPTH - (SCREW_LENGTH + 2) - SCREW_LENGTH / 2;
      vent_height = FULLMODEL_HEIGHT - UBASE_THICKNESS * 2;
      vent_hex_od = 12;
      vent_pos_y = (SCREW_LENGTH + 2) + (vent_width - hexagon_get_used_width(vent_width, vent_hex_od)) / 2;
      vent_pos_z = (FULLMODEL_HEIGHT - hexagon_get_used_depth(vent_height, vent_hex_od)) / 2;

      rotate([90, 0, 90]) translate([vent_pos_y, vent_pos_z, 0])
        hexagon_pattern(vent_width, vent_height, FULLMODEL_WIDTH, vent_hex_od);

      pattern_width = FULLMODEL_WIDTH - (UBASE_THICKNESS + TOLERANCE_HDD + RUBBER_OD) * 2;
      pattern_hex_od = 19;
      pattern_pos_x = (FULLMODEL_WIDTH - hexagon_get_used_width(pattern_width, pattern_hex_od)) / 2;
      pattern_pos_y = SCREW_LENGTH + 7 + (FULLMODEL_DEPTH - (SCREW_LENGTH + 7) -
        hexagon_get_used_depth(FULLMODEL_DEPTH - (SCREW_LENGTH + 7), pattern_hex_od)) / 2;

      translate([pattern_pos_x, pattern_pos_y, -.1])
        hexagon_pattern(pattern_width, FULLMODEL_DEPTH - pattern_pos_y, UBASE_THICKNESS + .2, pattern_hex_od);

      // to prepare the space for the screws later
      translate([0, 0, UBASE_THICKNESS])
        CaseMountingSocket(SCREW_SOCKET_WIDTH, SCREW_LENGTH, FULLMODEL_HEIGHT - UBASE_THICKNESS,
        FAN_CaseMountingSocket_DISTANCE, FULLMODEL_WIDTH, true);
    }
    translate([0, 0, UBASE_THICKNESS])
      CaseMountingSocket(SCREW_SOCKET_WIDTH, SCREW_LENGTH, FULLMODEL_HEIGHT - UBASE_THICKNESS,
      FAN_CaseMountingSocket_DISTANCE, FULLMODEL_WIDTH, false);
  }
}

module fan_frame(screw_distance, disk_height, frame_width, screw_diameter = 4, thickness = 2.5, disk_count = 3,
additional_stabilization = false, tolerance = .1) {
  frame_id = screw_distance - 2 * screw_diameter;
  frame_thickness = thickness * 4;

  translate([frame_width / 2, frame_width / 2, 0]) union() {
    difference() {
      translate([-frame_width / 2, -frame_width / 2, 0])
        cube([frame_width, frame_width, frame_thickness]);
      translate([-frame_id / 2, -(additional_stabilization ? frame_id : frame_width + .1) / 2, -.1])
        cube([frame_id, additional_stabilization ? frame_id : frame_width + .2, frame_thickness + .2]);
      translate([-frame_id / 2, -frame_width / 2 - .1, -thickness])
        cube([frame_id, frame_width + .2, frame_thickness]);

      // fan Screws
      for (i = [0:3]) {
        rotate([0, 0, 90 * i])
          translate([screw_distance / 2, screw_distance / 2, -.1])
            cylinder(d = screw_diameter == 4 ? core_hole_M4() : core_hole_M3(), h = frame_thickness + .2);
      }

      // mounting screws
      mounting_start_z = (frame_width - disk_height * disk_count) / 2 + .5;
      rotate([90, 0, 0]) translate([-frame_width / 2, 0, -frame_width / 2]) {
        for (i = [0:disk_count - 1]) {
          translate([0, 0, mounting_start_z + disk_height * i]) {
            CaseMountingSocket((frame_width - frame_id) / 2, frame_thickness * 2, disk_height - UBASE_THICKNESS,
            screw_distance, frame_width, for_cutout_only = true, screw_additional_od = .8);
            remaining_frame_thickness = 3;
            translate([0, remaining_frame_thickness, 0])
              CaseMountingSocket((frame_width - frame_id) / 2, frame_thickness - remaining_frame_thickness, disk_height
                - UBASE_THICKNESS, screw_distance, frame_width, for_cutout_only = true, screw_additional_od = 4);
          }
        }
      }
    }
    if (additional_stabilization) {
      // frame stabilization/cable blocker
      translate([-frame_width / 2, -frame_width / 2, frame_thickness - thickness]) for (i = [1:disk_count - 1]) {
        translate([(frame_width - frame_id - .2) / 2, disk_height * i, 0])
          cube([frame_id + .2, screw_diameter * 2, thickness]);
      }
    }
  }
}

translate([0, .5, ((FAN_CaseMountingSocket_DISTANCE + 4 * 2) - 3 * FULLMODEL_HEIGHT) / 2]) {
  for (i = [0:2]) {
    translate([0, 0, FULLMODEL_HEIGHT * i]) hddBayStackable();
  }
}

rotate([90, 0, 0]) fan_frame(FAN_CaseMountingSocket_DISTANCE, FULLMODEL_HEIGHT, FULLMODEL_WIDTH);
