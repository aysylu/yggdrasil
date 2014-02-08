// Args are:
// num_cables - number of fiber optic cables
// zip_height - height of the ziplock
// zip_width - width of the ziplock
// cable_d - diameter of the cable
// channel_depth -- depth of the innermost wall of the channel inside the base
// cup_thickness -- thickness of the cable holder
// core_radius -- radius of the core pipe that connects the top and bottom of the sculpture
module weave_hugger(
    num_cables,
    zip_height,
    zip_width,
    cable_d,
    channel_depth,
    cup_thickness,
    core_radius) {

  // Calculate the dimensions of the base
  bridge_width = 2 * zip_width; // bridge between two zip ties
  r_eff = cable_d/2 + zip_width + cup_thickness; // effective radius
  side_polygon = bridge_width + 2 * r_eff; // length of the side of the polygon
  polygon_angle = 360/num_cables; // angle of the polygon
  substrate_circle_radius = side_polygon * sqrt(1/(2 - 2 * cos(polygon_angle)));

  //echo("substrate circle radius ", substrate_circle_radius);

  // Calculate the channel dimensions
  channel_radius = channel_depth / 2
    + side_polygon * side_polygon / (8 * channel_depth);
  substrate_center_to_side_polygon = sqrt(substrate_circle_radius * substrate_circle_radius
      - (side_polygon * side_polygon) / 4);
  polygon_to_circle_center = substrate_center_to_side_polygon + channel_radius - channel_depth;

  difference() {
    // the base
    cylinder(h=zip_height * 3, r=substrate_circle_radius, center=true);
    // cable cups
    for (i = [1 : num_cables]) {
      rotate([0,0,360/num_cables*i])
        translate([polygon_to_circle_center,0,0])
        cylinder(h=zip_height * 3 + 0.025, r=channel_radius - zip_width - cup_thickness, center=true, $fn=100);
    }
    // zip tie channels
    for (i = [1 : num_cables]) {
      difference() {
        rotate([0,0,360/num_cables*i])
          translate([polygon_to_circle_center,0,0])
          cylinder(h=zip_height + 0.025,r=channel_radius,center=true, $fn=100);
        rotate([0,0,360/num_cables*i])
          translate([polygon_to_circle_center,0,0])
          cylinder(h=zip_height + 0.05,r=channel_radius - zip_width,center=true, $fn=100);
      }
    }
    // hole in the middle for the core
    cylinder(h=zip_height * 3 + 0.2, r=core_radius, center=true, $fn=100);
  }
}

weave_hugger(
    num_cables = 36,
    zip_height = 4.572 + 0.1,
    zip_width = 1.32 + 0.1,
    cable_d = 9,
    channel_depth = 9,
    cup_thickness = 5,
    core_radius = 25);

/*
// miniature yggdrasil for David
weave_hugger(
    num_cables = 8,
    zip_height = 2.413 + 0.1,
    zip_width = 1.066 + 0.1,
    cable_d = 6,
    channel_depth = 6,
    cup_thickness = 3,
    core_radius = 8);
 */
