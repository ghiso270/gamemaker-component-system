/*
	DEPENDENCIES:
		- MovementInputSubcomponent, for keyboard input or random input
	
	OPTIONAL:
		- MovementLogicSubcomponent, for custom movement (accelerating, moving as a sine wave, following an object etc.)
*/

/// @desc Component for basic linear movement, can be fine-tuned with a MovementLogicSubcomponent
/// @arg {Real}								x_spd				horizontal speed (in pixels), applied while receiving input
/// @arg {Real}								y_spd				vertical speed (in pixels), applied while receiving input
/// @arg {Struct.MovementInputSubcomponent}	input_src			subcomponent that handles the input
/// @arg {Bool}								fix_diagonal		if true, it will move at the the same speed even diagonally. ignored when using a MovementLogicSubcomponent. defaults to true
/// @arg {Bool}								ignore_game_speed	if true, it won't account for global.game_speed value. defaults to false
/// @arg {Bool}								ignore_pause		if true, it will move even when the game is paused. defaults to false
/// @arg {Array<Array<Real>>}				events				list of events in which the component has to be executed, eg: [[ev1_type, ev1_number], [ev2_type, ev2_number], ...]

function MovementComponent(x_spd, y_spd, input_src, fix_diagonal = true, ignore_game_speed = false, ignore_pause = false, events = [[ev_step, ev_step_normal]]) : Component("movement", events) constructor{
	
	/// @desc calculates instant velocity and applies it
	execute = function(){
		
		// if missing input source or if the game is paused, abort
		if(input == undefined || (global.game_pause && !ignore_pause))
			return;
		
		// apply custom logic or linear (default)
		if(move_logic != undefined) {
			dx = move_logic.get_dx();
			dy = move_logic.get_dy();
		}else{
			dx = x_spd * input.get_hdir();
			dy = y_spd * input.get_vdir();
			
			// normalize diagonal movement
			if(fix_diagonal && dx != 0 && dy != 0) {
				dx *= 0.7071;
				dy *= 0.7071;
			}
		}
		
		// game_speed can make it faster (like 2x) or slower (0.5x) depending on the values
		if(!ignore_game_speed){
			dx *= global.game_speed;
			dy *= global.game_speed;
		}
		
		update_pos();
	}
	
	/// @desc updates x and y values of the GM Object
	update_pos = function(){
		manager.object.x += dx * get_dt();
		manager.object.y += dy * get_dt();
	}
	
	/// @arg {Struct.MovementInputSubcomponent}	input_src		subcomponent that handles the input
	set_input_src = function(input_src){
		self.input = input_src;
		
		if(input_src == undefined)
			return;
			
		input_src.attach(self);
	}
	
	/// @arg {Struct.MovementLogicSubcomponent,undefined}	move_logic_src		subcomponent that handles custom movement (such as moving as a sine wave, following an object ecc.)
	set_move_logic_src = function(move_logic_src){
		self.move_logic = move_logic_src;
		
		if(move_logic_src == undefined)
			return;
			
		move_logic_src.attach(self);
	}
	
	/// @desc returns a variable that works as delta_time/1_000_000, but can take into account other variables, such as game_speed
	get_dt = function(){
		if(!ignore_pause && global.game_pause)
			return 0;
		
		var dt = delta_time/1_000_000;
		if(!ignore_game_speed)
			dt *= global.game_speed;
		
		return dt;
	}
	
	
	#region initialize
	
	// set subcomponents
	set_input_src(input_src);
	set_move_logic_src(undefined);
	
	// constants for speed
	self.x_spd = x_spd;
	self.y_spd = y_spd;
	
	// instant velocity
	self.dx = 0;
	self.dy = 0;
	
	// other parameters
	self.fix_diagonal = fix_diagonal;
	self.ignore_game_speed = ignore_game_speed;
	self.ignore_pause = ignore_pause;
	
	#endregion
}