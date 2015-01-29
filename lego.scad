// building Lego bricks - rdavis.bacs@gmail.com
// measurements taken from: 
//   http://www.robertcailliau.eu/Lego/Dimensions/zMeasurements-en.xhtml
// all copyrights and designs are property of their respective owners.

SPACE_BETWEEN_KNOBS = 8.0;
BRICK_HEIGHT = 9.6;
GAP_BETWEEN_BRICKS = 0.2;
BETWEEN_BRICKS_TOLERANCE = GAP_BETWEEN_BRICKS/2;
KNOB_DIAMETER = 4.8;
KNOB_HEIGHT = 1.8;
WALL_THICKNESS = 1.2;

CYLINDER_EXTERNAL_DIAMETER = SPACE_BETWEEN_KNOBS*sqrt(2)-KNOB_DIAMETER;
CYLINDER_INTERNAL_DIAMETER = KNOB_DIAMETER;
BEAM_CYLINDER_DIAMETER = 3.0;

PLATE_HEIGHT = BRICK_HEIGHT/3;

function radius(diameter) = diameter/2;

module build_knob() {
  cylinder(h = KNOB_HEIGHT, r = radius(KNOB_DIAMETER));
}

module build_brick_cylinder(height = BRICK_HEIGHT) {
  difference() {
    cylinder(h = height, r = radius(CYLINDER_EXTERNAL_DIAMETER));
    cylinder(h = height, r = radius(CYLINDER_INTERNAL_DIAMETER));
  }
}

module build_beam_cylinder(height = BRICK_HEIGHT) {
  cylinder(h = height, r = radius(BEAM_CYLINDER_DIAMETER));
}

module build_walls(width, depth, height = BRICK_HEIGHT) {
  inner_cube_width = width-2*WALL_THICKNESS;
  inner_cube_depth = depth-2*WALL_THICKNESS;
  inner_cube_height = height-WALL_THICKNESS;

  difference() {
    cube([width, depth, height]);
    translate([WALL_THICKNESS, WALL_THICKNESS, 0])
      cube([inner_cube_width, inner_cube_depth, inner_cube_height]);
  }
}

module place_brick_knobs(number_of_columns, number_of_rows, height) {
  for (j = [1:number_of_rows]) {
    for (i = [1:number_of_columns]) {
      translate([(2*i-1)*SPACE_BETWEEN_KNOBS/2, (2*j-1)*SPACE_BETWEEN_KNOBS/2, height])
      build_knob();
    }
  }
}

module place_beam_cylinders(number_of_cylinders, row_beam, height) {
  for (i = [1:number_of_cylinders]) {
    if (row_beam) {
      translate([SPACE_BETWEEN_KNOBS*i, SPACE_BETWEEN_KNOBS/2, 0])
        build_beam_cylinder(height);
    } else {
      translate([SPACE_BETWEEN_KNOBS/2, SPACE_BETWEEN_KNOBS*i, 0])
        build_beam_cylinder(height);
    }
  }
}

module place_brick_cylinders(number_of_rows, number_of_columns, height) {
  for (j = [1:number_of_rows-1]) {
    for (i = [1:number_of_columns-1]) {
      translate([SPACE_BETWEEN_KNOBS*i, SPACE_BETWEEN_KNOBS*j, 0])
        build_brick_cylinder(height);
    }
  }
}

module build_brick(number_of_columns, number_of_rows, height) {
  width = number_of_columns*SPACE_BETWEEN_KNOBS - 2*BETWEEN_BRICKS_TOLERANCE;
  depth = number_of_rows*SPACE_BETWEEN_KNOBS - 2*BETWEEN_BRICKS_TOLERANCE;
  row_beam = number_of_rows == 1;
  column_beam = number_of_columns == 1;
  
  build_walls(width, depth, height);
  place_brick_knobs(number_of_columns, number_of_rows, height);
  if (row_beam) {
    place_beam_cylinders(number_of_columns-1, true, height);
  } else if (column_beam) {
    place_beam_cylinders(number_of_rows-1, false, height);
  } else {
    place_brick_cylinders(number_of_rows, number_of_columns, height);
  }
}

module build_one_row_beam(number_of_knobs) {
  build_brick(number_of_knobs, 1, BRICK_HEIGHT);
}

module build_two_row_brick(number_of_columns) {
  build_brick(number_of_columns, 2, BRICK_HEIGHT);
}

module build_plate(number_of_columns, number_of_rows) {
  build_brick(number_of_columns, number_of_rows, PLATE_HEIGHT);
}


// let's build some parts!
build_two_row_brick(2);

translate([20, 0, 0])
build_two_row_brick(4);

translate([0, 20, 0])
build_one_row_beam(5);

translate([0, 30, 0])
build_plate(2, 2);

translate([0, -70, 0])
build_plate(10, 8);

translate([-10, 0, 0])
build_plate(1, 10);

translate([-40, -40, 0])
build_plate(3, 5);