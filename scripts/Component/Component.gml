/// @desc an abstract component class. Subclasses should be used instead, implementing the "execute" method and optionally subcomponents
/// @arg {String}						class				descriptive name of the implementing subclass, eg HealthComponent -> class="health"			
/// @arg {Array<Array<Real>>}			events				list of events in which the component has to be executed, eg: [[ev1_type, ev1_number], [ev2_type, ev2_number], ...]

function Component(class, events) constructor {
	
	execute = function(){
		// to implement in subclasses
	}
	
	#region utility methods
	
	/// @arg {Struct.ComponentManager}	manager		manager this component is being added to
	/// @arg {Real}						id			identifier of this component
	attach = function(manager, id){
		self.manager = manager;
		self.id = id;
	}
	
	detach = function(){
		self.manager = undefined;
		self.id = undefined;
	}
	
	#endregion
	
	#region initialize
	
	self.class = class;
	self.events = events;
	
	#endregion
}