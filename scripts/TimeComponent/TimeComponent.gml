/// @desc a Component that handles timers, chronometers, current time and delta-time
/// @arg {String}			name				name of the component
/// @arg {Array<String>}	tags				tags of the component ("*" is reserved, so it must not be included)
/// @arg {Array<Real>}		event				single event (including priority) in which the component has to be executed. defaults to [ev_step, ev_step_normal, 1]

function TimeComponent(name, tags, event = [ev_step, ev_step_normal, 1]) : Component(name, array_push_and_return(tags, "::TimeComponent"), [event]) constructor{
	
	/// @desc 
	/// @arg {Constant.EventType}	ev_type		type of the event in execution
	/// @arg {Constant.EventNumber} ev_num		number of the event in execution
	static execute = function(ev_type = event_type, ev_num = event_number){
		// TODO
	}
	
	static get_delta_time = function(){
		// TODO
	}
	
	static change_game_speed = function(){
		// TODO
	}
	
	static get_current_time = function(){
		// TODO
	}
	
	#region timers
	
	static add_timer = function(ms){
		// TODO
	}
	
	static change_timer = function(timer_id, ms){
		// TODO
	}
	
	static remove_timer = function(timer_id){
		// TODO
	}
	
	#endregion
	
	#region chronometers
	
	static add_chronometer = function(precise = false){
		// TODO
	}
	
	static remove_chronometer = function(chronometer_id){
		// TODO
	}
	
	#endregion
	
	// private data
	with(__){
		
		// speed multiplier (makes the timers go slower)
		self.game_speed = 1;
		
		// holds a list of indexes in the array of timers that don't contain a timer, to minimize the allocation of new memory
		self.timers = new PoolingSubcomponent();
		self.chronometers = new PoolingSubcomponent();
	}
}