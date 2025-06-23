/// @desc Constructor for a ComponentManager, needed for using Components inside a project
/// @param {Asset.GMObject} obj		object inside which the components are managed
/// @param {struct}			comps	initial components, structured like this: {health: new HealthComponent(...), input: ...}

function ComponentManager(obj, comps = {}) constructor {
	
	// array that holds every component
	components = [];
	
	// fields that make each component accessible by name, storing the index to access it from components[]
	// (added dynamically)
	
	// 3-dimension array that makes each component accessible by event id, storing the index for components[] instead of the component itself
	// note: the array is structured like this: array [event_type] [event_number] -> array of components (for that specific event)
	event_components = [];
	
	execute = function(){
		var components_to_execute = event_components[event_type][event_number];
		var component_num = array_length(components_to_execute);
		
		for (var i = 0; i < component_num; ++i)
			components_to_execute[i].execute();
	}
	
	#region initialize
	
	object = obj;
	
	var keys = struct_get_names(comps);
	for (var i = 0; i < array_length(keys); ++i) {
		var key = keys[i]
		var val = struct_get(comps, key);
		set_component(key, val);
	}
	
	#endregion
	
	#region utility methods
	
	has_component = function(name){
		
		// check if the component reference is stored in a field
		return struct_exists(self, name);
	}
	
	get_component = function(name){
		
		// get index by name and use it to access the component
		var index = struct_get(self, name);
		
		if(index == undefined)
			return undefined;
			
		return components[index];
	}
	
	remove_component = function(name){
		
		// if the component doesn't exist, don't remove it
		// note: not checking the references is correct, assuming the component has been added using the proper methods
		var index = struct_get(self, name);
		if(index == undefined)
			return;
		
		// delete the component's reference from each event array
		var component = components[index];
		var events_num = array_length(component.event_ids);
		for (var i = 0; i < events_num; ++i) {
			
			// get event info
			var event_id = component.event_ids[i];
			var ev_type = event_id[0];
			var ev_num  = event_id[1];
			
			// find the correct index and delete the component's reference
			var components_ids = event_components[ev_type][ev_num];
		    var index_in_event = array_get_index(components_ids, index);
			array_delete(components_ids, index_in_event, 1);
		}
		
		// delete the component's reference as field
		struct_remove(self, name);
		
		// delete the component from the general array
		array_delete(components, index, 1);
	}
	
	set_component = function(name, component){
		
		// set the manager
		component.set_manager(self);
		
		// if it already exists, update the value, otherwise add it
		// note: this check handles correctly any value that might already be in another field, like the "object" field
		var index = struct_get(self, name);
		if(index != undefined){
			if(typeof(index) == "number")
				components[index] = component;
			
			return;
		}
		
		// add component as last element and get its index in the components[] array
		array_push(components, component);
		index = array_length(components)-1;
		
		// add the component's reference as a field
		struct_set(self, name, index);
		
		// add the component's reference to the respective event array(s)
		var events_num = array_length(component.event_ids);
		for (var i = 0; i < events_num; ++i) {
			
			// get event info
			var event_id = component.event_ids[i];
			var ev_type = event_id[0];
			var ev_num  = event_id[1];
			
			// check if the event number map exists and create it if it doesn't
			if(event_components[ev_type] == undefined)
				event_components[ev_type] = [];
			
			// same with the array of event components
			if(event_components[ev_type][ev_num] == undefined)
				event_components[ev_type][ev_num] = [];
			
			// add the reference to the array
			var components_ids = event_components[ev_type][ev_num];
			array_push(components_ids, index);
		}
	}
	
	#endregion
}