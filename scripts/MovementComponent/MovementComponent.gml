/*
	DEPENDENCIES:
		- MovementInputSubcomponent, for keyboard input or random input
	
	OPTIONAL:
		- MovementLogicSubcomponent, for custom movement (accelerating, moving as a sine wave, following an object etc.)
*/

/// @desc Component for basic linear movement, can be fine-tuned with a MovementLogicSubcomponent. requires setting an InputComponent with the appropriate method
/// @arg {String}							name				name of the component
/// @arg {Array<String>}					tags				tags of the component ("*" is reserved, so it must not be included)
/// @arg {Real}								x_spd				horizontal speed (in pixels), applied while receiving input
/// @arg {Real}								y_spd				vertical speed (in pixels), applied while receiving input
/// @arg {Bool}								fix_diagonal		if true, it will move at the the same speed even diagonally. ignored when using a MovementLogicSubcomponent. defaults to true
/// @arg {Array<Array<Real>>}				events				list of events (+ priority) in which the component has to be executed. defaults to [[ev_step, ev_step_normal, 1]]

function MovementComponent(name, tags, x_spd, y_spd, fix_diagonal = true, events = [[ev_step, ev_step_normal, 1]]) : Component(name, tags, events) constructor{
	
	/// @desc calculates and applies instant velocity
	/// @arg {Constant.EventType}	ev_type		type of the event in execution
	/// @arg {Constant.EventNumber} ev_num		number of the event in execution
	static execute = function(ev_type, ev_num){
		
		// apply custom logic or linear (default)
		if(move_logic != undefined) {
			dx = move_logic.get_dx();
			dy = move_logic.get_dy();
		}else{
			dx = x_spd * input.get_hdir();
			dy = y_spd * input.get_vdir();
			
			// normalize diagonal movement
			if(fix_diagonal && dx != 0 && dy != 0) {
				
				// equivalent to dividing by the square root
				static sqrt2 = sqrt(2);
				dx *= sqrt2/2;
				dy *= sqrt2/2;
			}
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
		
		if(is_undefined(input_src))
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
	
	/// @desc returns a variable that works as delta_time/1_000_000, but can take into account other variables, such as speed_multiplier
	/// @return {Real}
	static get_dt = function(){
		var dt = delta_time/1_000_000;
		
		dt *= speed_multiplier;
		
		return dt;
	}
	
	
	#region initialize
	
	// set subcomponents
	set_input_src(new MovementInputSubcomponent(undefined,undefined,undefined,undefined));
	set_move_logic_src(undefined);
	
	// constants for speed
	self.x_spd = x_spd;
	self.y_spd = y_spd;
	self.speed_multiplier = 1;
	
	// instant velocity
	self.dx = 0;
	self.dy = 0;
	
	// other parameters
	self.fix_diagonal = fix_diagonal;
	
	#endregion
}