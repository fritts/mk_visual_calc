//translate([0,40,-10/2])cube([340,310,10],center=true);
//Defines
sin60 = 0.866025;
cos60 = 0.5;
explode = 0.0;   // set > 0.0 to push the parts apart
frame_motor_h = 40;
 
frame_extrusion_l = 240; //length of extrusions for horizontals, need cut length
frame_extrusion_h = 600; //length of extrusions for towers, need cut length
frame_extrusion_w = 15;
frame_r = ((frame_extrusion_l/2) + 11)/sin60;
frame_size = frame_r + explode;//151.5 + explode;
frame_offset = frame_r * cos60 + frame_extrusion_w + explode;//92 + explode;    // distance from center to center of t_slot
frame_depth = 15/2;
frame_top = frame_extrusion_h - 30 + explode;

//rail_depth= 13;//17.55 - 7.5;   // for mgn12 rails
//rail_depth= 17.55 - 7.5;   // 17.55 from the tower_slides.scad file
//rail_depth = 25; // the further the carriage is from the slider, the shoert the diagonal rod and we regain max z
//truck_depth=0;

rail_length = 400;
rail_r_offset = frame_depth + explode;
rail_depth = 8 + explode; // mgn12C rail is 8mm high
truck_depth = 5 + explode; // mgn12C rail is 8mm high
rail_z_offset = 98; // distance from top of motor fram to bottom of rail

endstop_h = 15;
endstop_depth = 9 + 3.5;
carriage_depth = 13;
carriage_r_offset = carriage_depth/2 + rail_depth + truck_depth + frame_depth + explode;
carriage_length = 40;
carriage_pivot_offset = 30.5; // the distance from the bottom of the carriage tot he pivot point
carriage_z = 140;

// diagonal rods
effector_offset = 20; // horizontal distance from center to pivot from effector.scad
delta_min_angle = 28; // the minimul angle of the diagonal rod as full extension while still being ont he print surface  
DELTA_SMOOTH_ROD_OFFSET = ((frame_extrusion_l + 11)/2)/sin60;
DELTA_RADIUS = DELTA_SMOOTH_ROD_OFFSET-effector_offset-(rail_depth +truck_depth + carriage_depth/2)	;
DELTA_DIAGONAL_ROD =((DELTA_RADIUS*2)-effector_offset)/cos(delta_min_angle); // rember we need to subtract the effect offset so we account for keeping the hotend tip on the edge of the build surface
rod_r = 6/2; // 6mm carbon fiber rods?
delta_rod_angle = acos(DELTA_RADIUS/DELTA_DIAGONAL_ROD); // angle of delta diagonal rod when homed
delta_vert_l = sqrt((DELTA_DIAGONAL_ROD*DELTA_DIAGONAL_ROD)-(DELTA_RADIUS*DELTA_RADIUS));  //the distance from the pivot ont he effecto tot he pivot on the carriage
surface_r = DELTA_SMOOTH_ROD_OFFSET * sin(30) + effector_offset - frame_depth ;


echo("DELTA_RADIUS:");
echo(DELTA_RADIUS);
echo("DELTA_SMOOTH_ROD_OFFSET:");
echo(DELTA_SMOOTH_ROD_OFFSET);
echo("DELTA_DIAGONAL_ROD:");
echo(DELTA_DIAGONAL_ROD);
echo("DELTA vertical length:");
echo(delta_vert_l);
echo("delta_rod_angle:");
echo(delta_rod_angle);
echo("Build plate radius:");
echo(surface_r);

frame_color=[0.9,0.25,0.9,0.98];
frame_color2=[0.9,0.3,0.9,0.88];
rod_color=[0.1,0.1,0.1,0.88];
t_slot_color="silver";
rail_color = [1,1,1,1];

calc_slider_z = frame_motor_h + rail_z_offset + rail_length - carriage_length - delta_vert_l - endstop_h;
effector_z = calc_slider_z;
effector_h = 8; //height of effector so we can get it centered. From effector.scad
plate_d = surface_r * 2;
plate_z = frame_motor_h+2.5+5+3;
top_d = frame_size * 2;

calc_carriage_z = frame_motor_h + effector_z + delta_vert_l - carriage_pivot_offset;
hotend_l = 30;
calc_max_z = calc_carriage_z - ( plate_z + hotend_l + delta_vert_l);
echo("Max Build Height:");
echo(calc_max_z);



$fn=60;
//Horizontal t-slot
//X-Y
translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2])rotate([0,90,0]) color(t_slot_color) extrusion_15(frame_extrusion_l);
translate([-frame_extrusion_l/2,-frame_offset,frame_motor_h-2.5])rotate([0,90,0]) color(t_slot_color)extrusion_15(frame_extrusion_l);

//Y-Z
rotate([0,0,120]){
translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2])rotate([0,90,0]) color(t_slot_color)extrusion_15(frame_extrusion_l);
translate([-frame_extrusion_l/2,-frame_offset,frame_motor_h-2.5])rotate([0,90,0]) color(t_slot_color)extrusion_15(frame_extrusion_l);
}

//X-Z
rotate([0,0,-120]){
translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2]) rotate([0,90,0])color(t_slot_color)extrusion_15(frame_extrusion_l);
translate([-frame_extrusion_l/2,-frame_offset,frame_motor_h-2.5]) rotate([0,90,0])color(t_slot_color)extrusion_15(frame_extrusion_l);
}


//motor_frame
translate([-(sin60*frame_size),-(cos60*frame_size),0-explode]) rotate([0,0,-60])color(frame_color)import("frame_motor.stl"); //x-tower
translate([(sin60*frame_size),-(cos60*frame_size),0-explode]) rotate([0,0,60])color(frame_color)import("frame_motor.stl");   //y-tower
translate([0,frame_size,0-explode])rotate([0,0,180]) color(frame_color)import("frame_motor.stl");       //z-tower


//vertical t-slot
translate([-(sin60*frame_size),-(cos60*frame_size),0]) rotate([0,0,-60])color(t_slot_color)extrusion_15(frame_extrusion_h);  //x-tower
translate([(sin60*frame_size),-(cos60*frame_size),0]) rotate([0,0,60])color(t_slot_color)extrusion_15(frame_extrusion_h);   //y-tower
translate([0,frame_size,0]) rotate([0,0,180])color(t_slot_color)extrusion_15(frame_extrusion_h);   //z-tower


//top frame
translate([-(sin60*frame_size),-(cos60*frame_size),frame_top+explode]) rotate([0,0,-60])color(frame_color)import("frame_top.stl"); //x-tower
translate([(sin60*frame_size),-(cos60*frame_size),frame_top+explode]) rotate([0,0,60])color(frame_color)import("frame_top.stl");   //y-tower
translate([0,frame_size,frame_top+explode]) rotate([0,0,180])color(frame_color)import("frame_top.stl");       //z-tower

//Top t-slot
translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2 + frame_top]) rotate([0,90,0])color(t_slot_color)extrusion_15(frame_extrusion_l); //X-Y
rotate([0,0,120])translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2 + frame_top]) rotate([0,90,0])color(t_slot_color)extrusion_15(frame_extrusion_l); //Y-Z
rotate([0,0,-120])translate([-frame_extrusion_l/2,-frame_offset,frame_extrusion_w/2 + frame_top]) rotate([0,90,0])color(t_slot_color)extrusion_15(frame_extrusion_l); //X-Z


/*//slides
translate([-(sin60*(frame_size)),-(cos60*(frame_size)),calc_carriage_z])rotate([0,0,-60])color(frame_color)import("tower_slides.stl");
translate([(sin60*(frame_size)),-(cos60*(frame_size)),calc_carriage_z])rotate([0,0,60])color(frame_color)import("tower_slides.stl");
translate([0,frame_size,calc_carriage_z])rotate([0,0,180])color(frame_color)import("tower_slides.stl");*/

//rails
translate([-(sin60*(frame_size-rail_r_offset)),-(cos60*(frame_size-rail_r_offset)),frame_motor_h+rail_z_offset])
 rotate([0,0,-60])color(rail_color)import("rail_400mm.stl"); //x-tower rail
translate([(sin60*(frame_size-rail_r_offset)),-(cos60*(frame_size-rail_r_offset)),frame_motor_h+rail_z_offset]) rotate([0,0,60])color(rail_color)import("rail_400mm.stl"); //y-tower rail
translate([0,frame_size-rail_r_offset,frame_motor_h+rail_z_offset])
 rotate([0,0,180])color(rail_color)import("rail_400mm.stl"); //z-tower rail
//trucks mgn12H
translate([-(sin60*(frame_size-rail_r_offset)),-(cos60*(frame_size-rail_r_offset)),calc_carriage_z-3.35]) rotate([0,0,-60])color("green")import("mgn12c.stl"); //z-tower truck
translate([(sin60*(frame_size-rail_r_offset)),-(cos60*(frame_size-rail_r_offset)),calc_carriage_z-3.35]) rotate([0,0,60])color("green")import("mgn12c.stl"); //z-tower truck
translate([0,frame_size-rail_r_offset,calc_carriage_z-3.35]) rotate([0,0,180])color("green")import("mgn12c.stl"); //z-tower truck


//Carriages
translate([-(sin60*(frame_size-carriage_r_offset)),-(cos60*(frame_size-carriage_r_offset)),calc_carriage_z])  rotate([90,0,120])translate([0,carriage_length/2-4,-carriage_depth/2,])color(frame_color2)import("carriage.stl"); //x-tower rail
translate([(sin60*(frame_size-carriage_r_offset)),-(cos60*(frame_size-carriage_r_offset)),calc_carriage_z])  rotate([90,0,60+180])translate([0,carriage_length/2-4,-carriage_depth/2,])color(frame_color)import("carriage.stl"); //y-tower rail
translate([0,frame_size-carriage_r_offset,calc_carriage_z]) rotate([90,0,0])translate([0,carriage_length/2-4,-carriage_depth/2,])color(frame_color)import("carriage.stl"); //z-tower rail

//endstops
//X tower
translate([-(sin60*(frame_size-endstop_depth)),-(cos60*(frame_size-endstop_depth)),frame_motor_h+rail_z_offset-endstop_h]) rotate([0,0,-60+180])color(frame_color)import("endstop.stl"); //x-tower lower endstop
translate([-(sin60*(frame_size-endstop_depth)),-(cos60*(frame_size-endstop_depth)),frame_motor_h+rail_z_offset+rail_length]) rotate([0,0,-60+180])color(frame_color)import("endstop.stl"); //x-tower upper endstop
//Y tower
translate([(sin60*(frame_size-endstop_depth)),-(cos60*(frame_size-endstop_depth)),frame_motor_h+rail_z_offset-endstop_h]) rotate([0,0,60+180])color(frame_color)import("endstop.stl"); //x-tower lower endstop
translate([(sin60*(frame_size-endstop_depth)),-(cos60*(frame_size-endstop_depth)),frame_motor_h+rail_z_offset+rail_length]) rotate([0,0,60+180])color(frame_color)import("endstop.stl"); //x-tower upper endstop
//z tower
translate([0,frame_size-endstop_depth,frame_motor_h+rail_z_offset-endstop_h])rotate([0,0,0])color(frame_color)import("endstop.stl"); //x-tower lower endstop
translate([0,frame_size-endstop_depth,frame_motor_h+rail_z_offset+rail_length])
 rotate([0,0,0])color(frame_color)import("endstop.stl"); //x-tower upper endstop


//effector
translate([0,0,frame_motor_h + effector_h/2 + effector_z])
 rotate([0,0,60])color(frame_color)import("effector.stl"); //x-tower upper endstop
//plate
translate([0,0,plate_z])color([1.0,1.0,1.0,0.5])cylinder(h=5,r=plate_d/2,center=true,$fn=120);
//translate([0,0,frame_top+15])color([0,120,120,0.5])cylinder(h=5,r=top_d/2,center=true,$fn=120);

//Diagonal Rods
for(i=[0:2]) {
  rotate(i*120) {
   translate([20,20,frame_motor_h + effector_h/2 + effector_z]) rotate([-(90-delta_rod_angle),0,0]) color(rod_color) cylinder(h=DELTA_DIAGONAL_ROD, r=rod_r);
   translate([-20,20,frame_motor_h + effector_h/2 + effector_z]) rotate([-(90-delta_rod_angle),0,0]) color(rod_color) cylinder(h=DELTA_DIAGONAL_ROD, r=rod_r);
  }
}


// This module is used to create a dynamic length extrusion from a 1000mm extrusion STL file
module extrusion_15(len=240){
  difference(){
    import("1515_1000mm.stl", convexity=10);
    translate([-10,-10,len])cube([20,20,(1000-len)+2]);
  }

}