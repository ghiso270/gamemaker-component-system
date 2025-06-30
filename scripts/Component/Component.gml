/// @desc Constructor for an abstract component class. Subclasses should be used instead, implementing the "execute" and "destroy" methods
/// @arg {Array}	event_ids			list of events in which the component has to be executed, eg: [[ev1_type, ev1_number], [ev2_type, ev2_number], ...]
/// @arg {struct}	subcomponents		initial components, structured like this: {health: new HealthComponent(...), input: ...}

function Component(event_ids, subcomponents = {}) constructor{
	execute = function(){
		// to implement in subclasses
	}
	
	destroy = function(){
		// to implement in subclasses
	}
	
	#region initialize
	
	self.event_ids = event_ids;
	self.subcomponents = {};
	
	var keys = struct_get_names(subcomponents);
	for (var i = 0; i < array_length(keys); ++i) {
		var key = keys[i]
		var val = struct_get(subcomponents, key);
		set_subcomponent(key, val);
	}
	
	#endregion
	
	#region utility methods
	
	/// @arg {String} name	name of the subcomponent to check
	has_subcomponent = function(name){
		return struct_exists(subcomponents, name);
	}
	
	/// @arg {String} name	name of the subcomponent to return
	get_subcomponent = function(name){
		return struct_get(subcomponents, name);
	}
	
	/// @arg {String} name	name of the subcomponent to remove
	remove_subcomponent = function(name){
		
		// if the subcomponent doesn't exist, don't remove it
		if(!struct_exists(subcomponents, name))
			return;
		
		// delete the subcomponent as field
		struct_remove(subcomponents, name);
	}
	
	/// @arg {String} name							name of the subcomponent to set
	/// @arg {Struct.Subcomponent} subcomponent		value to set to
	set_subcomponent = function(name, subcomponent){
		subcomponent.set_parent(self);
		struct_set(subcomponents, name, subcomponent);
	}
	
	/// @arg {Struct.ComponentManager} manager manager for this component
	set_manager = function(manager){
		self.manager = manager;
	}
	
	get_manager = function(){
		return manager;
	}
	
	#endregion
}