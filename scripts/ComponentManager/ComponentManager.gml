/// @desc Constructor for a ComponentManager, needed for using Components inside a project
/// @arg {Id.Instance}		obj				object inside which the components are managed
/// @arg {Array<Struct.Component>}			components		array of initial components

function ComponentManager(obj, components = []) constructor {
	
	execute = function(){
		if(array_length(components_by_event) < 1)
			return;
			
		if(array_length(components_by_event[event_type]) < 1)
			return;
		
		var components_to_execute = components_by_event[event_type][event_number];
		var component_num = array_length(components_to_execute);
		
		for (var i = 0; i < component_num; ++i)
			components_to_execute[i].execute();
	}
	
	#region utility methods
	
	/// @arg {String} class	class to check
	/// @returns {Bool}
	has_component_class = function(class){
		var class_array = struct_get(components_by_class, class);
		return (class_array != undefined && array_length(class_array) > 0);
	}
	
	/// @arg {Real} is	id of the component to check
	/// @returns {Bool}
	has_component = function(id){
		return (array_length(components) > id);
	}
	
	/// @desc returns the component with the specified ID. it is recommended to check has_component(id) beforehand
	/// @arg {Real} id	id of the component to return
	/// @returns {Struct.Component}
	get_component = function(id){
		return components[id];
	}
	
	/// @arg {String} class	class of the component array to return
	/// @returns {Array<Struct.Component>}
	get_components_by_class = function(class){
		return struct_get(components_by_class, class);
	}
	
	
	/// @arg {Real} id	id of the component to remove
	remove_component = function(id){
		
		// if the component doesn't exist, skip
		if(!has_component(id))
			return;
			
		var comp = get_component(id);
		
		// delete the component from the general array
		array_delete(components, id, 1);
		
		// delete the component from the class map
		var class_array = struct_get(components_by_class, comp.class);
		var class_index = array_get_index(class_array, comp);
		array_delete(class_array, class_index, 1);
		
		// delete the component from the event array
		var events_num = array_length(comp.events);
		for (var i = 0; i < events_num; ++i) {
			
			// find the correct index to delete the component
			var ev_id = comp.events[i];
			var event_array = components_by_event[ev_id[0], ev_id[1]];
		    var event_idx = array_get_index(event_array, comp);
			array_delete(event_array, event_idx, 1);
		}
	}
	
	/// @arg {String} class		class of components to remove
	remove_component_class = function(class){
		
		// if the component doesn't exist, don't remove it
		if(!has_component_class(class))
			return;
		
		// remove each component from the general array and the event array
		var class_array = struct_get(components_by_class, class);
		var len = array_length(class_array);
		for (var i = 0; i < len; ++i){
			
			// delete from the general array
			var comp = class_array[i];
			array_delete(components, comp.id, 1);
		
			// delete from the event array
			var events_num = array_length(comp.events);
			for (var j = 0; j < events_num; ++j) {
			
				// find the correct index to delete the component
				var ev_id = comp.events[j];
				var event_array = components_by_event[ev_id[0], ev_id[1]];
			    var event_idx = array_get_index(event_array, comp);
				array_delete(event_array, event_idx, 1);
			}
		}
		
		// delete the class itself, the garbage collector handles the rest
		struct_remove(components_by_class, class);
	}
	
	/// @arg {Struct.Component} component		component to add
	add_component = function(component){
		
		// add to the array
		var new_id = array_length(components);
		components[new_id] = component;
		
		// add to the class map
		var class_array = struct_get(components_by_class, component.class);
		if(class_array == undefined)
			struct_set(components_by_class, component.class, [component]);
		else
			array_push(class_array, component);
		
		// add to the event array
		var events_num = array_length(component.events);
		for (var j = 0; j < events_num; ++j) {
			var ev_id = component.events[j];
			// check if the event number array exists and create it if it doesn't
			if(array_length(components_by_event) <= ev_id[0])
				components_by_event[ev_id[0]] = [];
			
			// same with the array of event components
			if(array_length(components_by_event[ev_id[0]]) <= ev_id[1])
				components_by_event[ev_id[0], ev_id[1]] = [];
				
			array_push(components_by_event[ev_id[0], ev_id[1]], component);
		}
		
		// attach the component
		component.attach(self, new_id);
	}
	
	destroy = function() {
		var len = array_length(components);
		for (var i = 0; i < len; ++i)
			components[i].destroy();
		
		// separate detachment to allow communication in destroy() function
		for (var i = 0; i < len; ++i)
			components[i].detach();
		
		self.components = [];
		self.components_by_class = {};
		self.components_by_event = [];
	}
	
	#endregion
	
	#region initialize
	
	// array containing all components, indexed by ID
	self.components = [];
	
	// map that matches a class name to an array of components of that class
	self.components_by_class = {};
	
	// 3-dimension array that makes each component accessible by event id
	// note: the array is structured like this: array [event_type] [event_number] -> array of components
	self.components_by_event = [];
	
	self.object = obj;
	
	var len = array_length(components);
	for (var i = 0; i < len; ++i)
		add_component(components[i]);
	
	#endregion
}