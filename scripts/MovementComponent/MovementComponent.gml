/*
	DEPENDENCIES:
		- MovementInputSubcomponent, for keyboard input or random input
	
	OPTIONAL:
		- AccelerationSubcomponent, for variation of speed
		- SpeedLimitSubcomponent, to set maximum/minimum values of speed
*/

/// @desc Component for basic movement, can be fine-tuned with subcomponents. requires one MovementInputSubcomponent, doesn't support multiple
/// @param {Real} x_spd		horizontal speed (in pixels), applied while receiving input
/// @param {Real} y_spd		vertical speed (in pixels), applied while receiving input
/// @param {Array<Array<Real>>} events 
/// @param {Array<Struct.Subcomponent>} subcomponents 
function MovementComponent(x_spd, y_spd, events = [[ev_step, ev_step_normal]], subcomponents = []) : Component("movement", [[ev_step, ev_step_normal]], subcomponents) constructor{
	self.x_spd = x_spd;
	self.y_spd = y_spd;
	
	execute = function(){
		if(!has_subcomponent_class("move-input"))
			return;
		
		var input = get_subcomponents_by_class("move-input")[0];
		var dx = x_spd * (input.check_right() - input.check_left());
		var dy = y_spd * (input.check_down() - input.check_up());
		
		move(dx,dy);
	}
	
	move = function(dx, dy){
		manager.object.x += dx;
		manager.object.y += dy;
	}
}