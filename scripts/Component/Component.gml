/// @desc an abstract component class. Subclasses should be used instead, implementing the "execute" method and optionally subcomponents
/// @arg {String}						name				name of the component
/// @arg {Array<String>}				tags				tags of the component
/// @arg {Array<Array<Real>>}			events				list of events in which the component has to be executed, eg: [[ev1_type, ev1_number], [ev2_type, ev2_number], ...]

function Component(name, tags, events) constructor {
	
	/// @arg {Constant.EventType}	ev_type		type of the event in execution
	/// @arg {Constant.EventNumber} ev_num		number of the event in execution
	static execute = function(ev_type, ev_num){
		// to implement in subclasses
	}
	
	static destroy = function(){
		// to implement in subclasses
	}
	
	#region utility methods
	
	/// @desc sets the manager of this component to the specified one
	/// @arg {Struct.ComponentManager}	manager		manager this component is being added to
	static attach = function(manager){
		self.manager = manager;
	}
	
	/// @desc removes this component's reference to its manager
	static detach = function(){
		self.manager = undefined;
	}
	
	/// @desc enables execute method
	static activate = function(){
		
		// exit if already active
		if(is_active) return;
		is_active = true;
		
		execute = deactivated_execute;
	}
	
	/// @desc disables execute method
	static deactivate = function(){
		
		// exit if already inactive
		if(!is_active) return;
		is_active = false;
		
		// save a backup and replace the execute function with an empty one;
		deactivated_execute = execute;
		execute = function(ev_type, ev_num){};
	}
	
	#endregion
	
	#region initialize
	
	self.is_active = true;
	self.name = name;
	self.tags = tags;
	self.events = events;
	
	#endregion
}