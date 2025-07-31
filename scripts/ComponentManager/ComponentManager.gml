/// @desc Constructor for a ComponentManager, needed for using Components inside a project
/// @arg {Id.Instance}		obj				object inside which the components are managed
/// @arg {Array<Struct.Component>}			components		array of initial components

function ComponentManager(obj, components = []) constructor {
	
	static execute = function(){
		if(array_length(components_by_event) < 1)
			return;
		
		var components_by_type = components_by_event[event_type];
		if(is_undefined(components_by_type))
			return;
		
		// if the resulting array is undefined, the length will be 0, skipping the loop
		var components_to_execute = components_by_type[$ event_number];
		var component_num = array_length(components_to_execute);
		
		for (var i = 0; i < component_num; ++i)
				components_to_execute[i].execute();
	}
	
	#region utility methods
	
	/// @arg {String} name	name of the component to check
	/// @returns {Bool}
	static has_component = function(name){
		return struct_exists(components_by_name, name);
	}
	
	/// @arg {String} name	name of the component to return
	/// @returns {Array<Struct.Component>}
	static get_component = function(name){
		return struct_get(components_by_name, name);
	}
	
	/// @arg {String} name		name of the component to remove
	/// @arg {Bool} to_destroy	if set to true, the destroy method of the component will be performed. defaults to true
	static remove_component = function(name, to_destroy = true){
		// if the component doesn't exist, don't remove it
		if(!has_component(name)){
			show_debug_message($"WARNING: The name \"{name}\" doesn't exist");
			return;
		}
		
		var comp = get_component(name);
		
		// delete from the general array
		var idx = array_get_index(components, comp);
		array_delete(components, idx, 1);
		
		// delete from the event array
		var events_num = array_length(comp.events);
		for (var i = 0; i < events_num; ++i) {
			
			// find the correct index to delete the component
			var ev_id = comp.events[i];
			var event_array = components_by_event[ev_id[0]][$ ev_id[1]];
			var event_idx = array_get_index(event_array, comp);
			
			array_delete(event_array, event_idx, 1);
		}
		
		// delete from the name map
		struct_remove(components_by_name, name);
		
		// detach and optionally destroy the component
		comp.detach();
		if(to_destroy)
			comp.destroy();
	}
	
	/// @arg {Struct.Component} component		component to add
	static add_component = function(component){
		if(has_component(component.name)){
			show_debug_message($"WARNING: The name \"{component.name}\" already exists");
			return;
		}
		
		// add to general array
		array_push(components, component);
		
		// add to name map
		struct_set(components_by_name, component.name, component);
		
		// add to event array
		var events_num = array_length(component.events);
		for (var i = 0; i < events_num; ++i) {
			var ev_id = component.events[i];
			
			// create the event number array if it doesn't exist already
			if(array_length(components_by_event) <= ev_id[0])
				components_by_event[ev_id[0]] = {};
			
			// create the event components array if it doesn't exist already
			if(is_undefined(components_by_event[ev_id[0]][$ ev_id[1]]))
				components_by_event[ev_id[0]][$ ev_id[1]] = [];
			
			array_push(components_by_event[ev_id[0]][$ ev_id[1]], component);
		}

		// attach the component
		component.attach(self);
	}
	
	static destroy = function() {
		var len = array_length(components);
		for (var i = 0; i < len; ++i)
			components[i].destroy();
		
		// separate detachment to allow communication during destroy() function
		for (var i = 0; i < len; ++i)
			components[i].detach();
		
		self.components = [];
		self.components_by_name = {};
		self.components_by_event = [];
	}
	
	#endregion
	
	#region initialize
	
	// array containing all components, indexed by ID
	self.components = [];
	
	// map that matches a name to a component
	self.components_by_name = {};
	
	// similar to a 3-dimension array that makes each component accessible by event id.
	// structured like this: array [event_type] -> struct[$ event_number] -> array of components
	self.components_by_event = [];
	
	self.object = obj;
	
	// add each component
	array_foreach(components, function(val, idx){add_component(val)});
	/*
	var len = array_length();
	for (var i = 0; i < len; ++i)
		add_component(components[i]);
	*/
	#endregion
}