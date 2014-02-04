// Args are:
// num_cables - number of fiber optic cables
// zip_height - height of the ziplock
// zip_width - width of the ziplock
// cable_d - diameter of the cable
// bridge_err -- slack added to the bridge
// cable_err -- slack added for fitting cables inside the structure
// hug_angle -- angle at which each cable is hugged in degrees
module electree_weave_hugger(num_cables,
							zip_height,
							zip_width,
							cable_d,
							bridge_err,
                             cable_err,
							hug_angle) {
  bridge_width = 2 * zip_width + bridge_err;
  r_eff = cable_d/2 + zip_width;
  side_polygon = bridge_width + 2 * r_eff;
  // side_polygon = d * sin(hug_angle * pi/360);
  polygon_angle = 360/num_cables;
  substrate_circle_radius = side_polygon * sqrt(1/(2 - 2 * cos(polygon_angle)));
  //intersection() {
  //  translate([1,1,0]) scale([1.0, 2.0]) circle(cable_d + 2 * zip_width);
  //  scale([1.0, 2.0]) circle(cable_d + zip_width);
  //}
  //difference() {
  //  circle(substrate_circle_radius);
  //  translate([10,0,0]) circle(cable_d);
  //}
  //polygon(points = [[0,0],[100,0],[0,100]], paths = [[0,1,2]]);
  //circle(substrate_circle_radius);
  //circle(substrate_circle_radius);
  for (i = [1 : num_cables]) {
    rotate([0,0,360/num_cables*i])
    translate([substrate_circle_radius,0,0])
    %circle(cable_d/2);
  }
  difference() {
    circle(substrate_circle_radius);
    for (i = [1 : num_cables]) {
      difference() {
        rotate([0,0,360/num_cables*i])
          translate([substrate_circle_radius,0,0])
          scale([1.2,1.1,1])
          %circle(cable_d/2 + zip_width);
        rotate([0,0,360/num_cables*i])
          translate([substrate_circle_radius,0,0])
          scale([1.2,1,1])
          %circle(cable_d/2);
      }
    }    
  }
}

module cable_channel() {
}

linear_extrude(height=9) electree_weave_hugger(8, 4.572, 1.32, 9, 1, 0, 120);