/// @desc an abstract component class. Subclasses should be used instead, implementing the "execute" method and optionally subcomponents
/// @arg {String}						name				name of the component		
/// @arg {Array<Array<Real>>}			events				list of events in which the component has to be executed, eg: [[ev1_type, ev1_number], [ev2_type, ev2_number], ...]

function Component(name, events) constructor {
	
	execute = function(){
		// to implement in subclasses
	}
	destroy = function(){
		// to implement in subclasses
	}
	
	#region utility methods
	
	/// @arg {Struct.ComponentManager}	manager		manager this component is being added to
	attach = function(manager){
		self.manager = manager;
	}
	
	detach = function(){
		self.manager = undefined;
	}
	
	activate = function(){
		
		// exit if already active
		if(is_active) return;
		is_active = true;
		
		execute = deactivated_execute;
	}
	
	deactivate = function(){
		
		// exit if already inactive
		if(!is_active) return;
		is_active = false;
		
		// save a backup and replace the execute function with an empty one;
		deactivated_execute = execute;
		execute = function(){};
	}
	
	#endregion
	
	#region initialize
	self.is_active = true;
	self.name = name;
	self.events = events;
	
	#endregion
}