/*

// ATTENTION: dogshit component
// TODO: refactor all this once the state machine is finished

/// @desc Component for basic linear movement, can be fine-tuned with a sbc_MotionLogic. requires setting an InputComponent with the appropriate method
/// @arg {String}							name				name of the component
/// @arg {Array<String>}					tags				tags of the component ("*" is reserved, so it must not be included)
/// @arg {Real}								spd					speed (in pixels), applied while receiving input
/// @arg {Function}							normalize			function applied to the vector [dx,dy] after they are calculate. takes as input the [dx,dy] vector and returns nothing. defaults to empty function.
/// @arg {Array<Array<Real>>}				events				list of events (+ priority) in which the component has to be executed. defaults to [[ev_step, ev_step_normal, 1]]

function cmp_Motion(name, tags, spd, normalize = function(vec){}, events = [[ev_step, ev_step_normal, 1]]) : Component(name, array_push_and_return(tags, "::cmp_Motion"), events) constructor{
	
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
			if(fix_diagonal) {
				
				// equivalent to dividing by the square root
				
				dx *= half_sqrt2;
				dy *= half_sqrt2;
			}
		}
		
		update_pos();
	}
	
	/// @desc changes x and y values of the GM Object based on speed
	static update_pos = function(){
		manager.get_object().x += dx * get_dt();
		manager.get_object().y += dy * get_dt();
	}
	
	/// @desc sets the input source to the specified one
	/// @arg {Struct.MotionInputSubcomponent}	input_src		subcomponent that handles the input
	static set_input_src = function(input_src){
		self.input = input_src;
		
		if(is_undefined(input_src))
			return;
			
		input_src.attach(self);
	}
	
	/// @desc allows custom movement logic through the use of a component
	/// @arg {Struct.sbc_MotionLogic,undefined}	move_logic_src		subcomponent that handles custom movement (such as moving as a sine wave, following an object ecc.)
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
	
	self.spd = spd;
	
	// modified when the game changes speed to freeze (0), go twice as fast (2) or twice as slow (0.5)
	self.speed_multiplier = 1;
	
	// instant velocity
	self.dx = 0;
	self.dy = 0;
	
	// other parameters
	self.normalize = (self.normalize != true) ? normalize : function(vec){
		if(vec[0] == 0 || vec[1] == 0)
			return;
		
		// the same as dividing by the square root of 2
		static half_sqrt2 = sqrt(2)/2;
		vec[0]*=half_sqrt2;
		vec[1]*=half_sqrt2;
	}
	
	#endregion
}
*/