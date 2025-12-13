/// @desc a Component that manages states for an entity
/// @arg {String}				name				name of the component
/// @arg {Array<String>}		tags				tags of the component ("*" is reserved, so it must not be included)
/// @arg {Bool}					debug				whether or not to print debug messages
/// @arg {Array<Array<Real>>}	events				list of events (+ priority) in which the component has to be executed. defaults to [[ev_step, ev_step_normal, 1]]

function StateMachineComponent(name, tags, debug = false, events = [[ev_step, ev_step_normal, 1]]) : Component(name, array_push_and_return(tags, "::StateMachineComponent"), events) constructor{
	
	/// @desc update each state
	/// @arg {Constant.EventType}	ev_type		type of the event in execution
	/// @arg {Constant.EventNumber} ev_num		number of the event in execution
	static execute = function(ev_type = event_type, ev_num = event_number){
		if(is_undefined(__.state))
			return;
		
		// helper variables
		__.already_changed = false;
		var next_states = __.state_data[$ __.state].next_states;
		var update_state = function(new_state, condition){
			
			// avoid useless iterations
			if(__.already_changed) {
				if(__.debug && condition(self))
					show_debug_message($"[WARNING: State Machine] state change conflict with {new_state}");
				return;
			}
			// check condition and chenge state
			if(condition(self)){
				change_state(new_state);
				__.already_changed = true;
			}
		}
		
		// update state
		struct_foreach(next_states, update_state);
		
		// execute state step
		__.step(ev_type, ev_num, self);
	}
	
	/// @desc lets you add state with custom actions
	/// @arg {String}	name			unique state name
	/// @arg {Struct}	next_states		map[new_state] -> condition, the condition must be a function that takes in input 1 arg (scope) and returns either true (change state to new_state) or false
	/// @arg {Function}	step			action of the state that is executed every event specified in the State Machine. takes in input 3 args (ev_type, ev_num, scope)
	/// @arg {Function}	on_enter		function executed only when the state changes from another state to this. takes in input 1 arg (scope)
	/// @arg {Function}	on_exit			function executed only when the state changes from this to another state. takes in input 1 arg (scope)
	static add_state = function(name, next_states, step, on_enter = function(scope){}, on_exit = function(scope){}){
		__.state_data[$ name] = {};
		with(__.state_data[$ name]){
			self.next_states = next_states;
			self.step		 = step;
			self.on_enter	 = on_enter;
			self.on_exit	 = on_exit;
		};
		
		if(__.debug)
			show_debug_message($"[State Machine] added state {name}");
	}
	
	/// @desc lets you add state with custom actions
	/// @arg {String}	init_state	name of the state to start in
	static start = function(init_state){
		
		// only works once
		if(!is_undefined(__.state)){
			if(__.debug)
				show_debug_message("[WARNING: State Machine] has already started");
			return;
		}
		
		// basically a copy of change_state() but safer since it doesn't execute undefined functions
		__.state = init_state;
		__.step = __.state_data[$ init_state].step;
		var on_enter_new = __.state_data[$ init_state].on_enter;
		on_enter_new(self);
		
		
		if(__.debug)
			show_debug_message($"[State Machine] started as {init_state}");
	}
	
	/// @desc returns the name of the current state (or undefined if the machine hasn't started yet)
	/// @returns {String}
	static get_state = function(){
		return __.state;
	}
	
	/// @desc returns the name of the current state (or undefined if the machine hasn't started yet)
	/// @arg {String}	state	name of the state to get the data of
	/// @returns {Struct}
	static get_state_data = function(state){
		return __.state_data[$ state];
	}
	
	/// @desc lets you add state with custom actions
	/// @arg {String}	new_state	name of the state to change to
	static change_state = function(new_state){
		if(__.debug && !struct_exists(__.state_data, new_state)){
			show_debug_message($"[ERROR: State Machine] {new_state} doesn't exist");
			return;
		}
		
		var on_enter_new = __.state_data[$ new_state].on_enter;
		var on_exit_old = __.state_data[$ __.state].on_exit;
		
		if(__.debug)
			show_debug_message($"[State Machine] {__.state} -> {new_state}");
		
		// update current state and step and execute enter/exit functions
		on_exit_old(self);
		__.state = new_state;
		__.step = __.state_data[$ __.state].step;
		on_enter_new(self);
	}
	
	// private
	with(__){
		self.debug = debug;
		
		// current state
		self.state = undefined;
		
		// current step function
		self.step = undefined;
		
		// matches name to a struct like this: {next_states, step, on_enter, on_exit}
		self.state_data = {};
	}
}