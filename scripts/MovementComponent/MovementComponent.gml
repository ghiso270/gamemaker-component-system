/*
	DEPENDENCIES:
		- MovementInputSubcomponent, for keyboard input or random input
	
	OPTIONAL:
		- MovementLogicSubcomponent, for custom movement (accelerating, moving as a sine wave, following an object etc.)
*/

/// @desc Component for basic linear movement, can be fine-tuned with a MovementLogicSubcomponent
/// @arg {String}							name				name of the component
/// @arg {Array<String>}					tags				tags of the component ("*" is reserved, so it must not be included)
/// @arg {Real}								x_spd				horizontal speed (in pixels), applied while receiving input
/// @arg {Real}								y_spd				vertical speed (in pixels), applied while receiving input
/// @arg {Struct.MovementInputSubcomponent}	input_src			subcomponent that handles the input
/// @arg {Bool}								fix_diagonal		if true, it will move at the the same speed even diagonally. ignored when using a MovementLogicSubcomponent. defaults to true
/// @arg {Bool}								ignore_game_speed	if true, it won't account for global.game_speed value. defaults to false
/// @arg {Bool}								ignore_pause		if true, it will move even when the game is paused. defaults to false
/// @arg {Array<Array<Real>>}				events				list of events in which the component has to be executed. defaults to [[ev_step, ev_step_normal]]

function MovementComponent(name, tags, x_spd, y_spd, input_src, fix_diagonal = true, ignore_game_speed = false, ignore_pause = false, events = [[ev_step, ev_step_normal]]) : Component(name, tags, events) constructor{
	
	/// @desc calculates and applies instant velocity
	/// @arg {Constant.EventType}	ev_type		type of the event in execution
	/// @arg {Constant.EventNumber} ev_num		number of the event in execution
	static execute = function(ev_type, ev_num){
		
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
	
	/// @desc changes x and y values of the GM Object based on speed
	static update_pos = function(){
		manager.object.x += dx * get_dt();
		manager.object.y += dy * get_dt();
	}
	
	/// @desc sets the input source to the specified one
	/// @arg {Struct.MovementInputSubcomponent}	input_src		subcomponent that handles the input
	static set_input_src = function(input_src){
		self.input = input_src;
		
		if(input_src == undefined)
			return;
			
		input_src.attach(self);
	}
	
	/// @desc allows custom movement logic through the use of a component
	/// @arg {Struct.MovementLogicSubcomponent,undefined}	move_logic_src		subcomponent that handles custom movement (such as moving as a sine wave, following an object ecc.)
	static set_move_logic_src = function(move_logic_src){
		self.move_logic = move_logic_src;
		
		if(move_logic_src == undefined)
			return;
		
		move_logic_src.attach(self);
	}
	
	/// @desc returns a variable that works as delta_time/1_000_000, but can take into account other variables, such as game_speed
	/// @return {Real}
	static get_dt = function(){
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