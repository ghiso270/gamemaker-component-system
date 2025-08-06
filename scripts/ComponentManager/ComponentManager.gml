/// @desc Constructor for a ComponentManager, needed for using Components inside a project
/// @arg {Id.Instance}		obj				object inside which the components are managed
/// @arg {Array<Struct.Component>}			components		array of initial components

function ComponentManager(obj, components = []) constructor {
	
	/// @desc executes all the necessary components for the current event
	static execute = function(){
		if(is_paused)
			return;
		
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
	
	/// @desc returns whether or not a component with the specified name exists inside this manager
	/// @arg {String} name	name of the component to check
	/// @returns {Bool}
	static has_component = function(name){
		return struct_exists(components_by_name, name);
	}
	
	/// @desc returns the specified component
	/// @arg {String} name	name of the component to return
	/// @returns {Struct.Component}
	static get_component = function(name){
		return struct_get(components_by_name, name);
	}
	
	/// @desc removes the specified component from memory, optionally destroying it
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
		
		// detachement should happen after, to access the manager during destroy() method
		if(to_destroy)
			comp.destroy();
		
		comp.detach();
	}
	
	/// @desc adds the specified component to memory, for execution and management
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
	
	/// @desc terminates this manager, clearing its memory and destroying all of its components
	static destroy = function() {
		var len = array_length(components);
		for (var i = 0; i < len; ++i)
			components[i].destroy();
		
		// separate detachment to allow communication during destroy() method
		for (var i = 0; i < len; ++i)
			components[i].detach();
		
		self.components = [];
		self.components_by_name = {};
		self.components_by_event = [];
	}
	
	/// @desc pauses this manager, meaning the execute method will skip (starting from the next execution)
	static pause = function() {
		is_paused = true;
	}
	
	/// @desc resumes this manager, meaning the execute method will run normally until paused again
	static resume = function() {
		is_paused = false;
	}
	
	/// @desc returns a multi-line string containing the components in this manager, each line structured as "N - Component", N starting from 1
	/// @arg {Bool}		active_only			If true, inactive components will be hidden. Defaults to false
	/// @arg {Function} expand_criteria		Function called for each component - takes 1 argument (component) and returns a bool (true: show 1-line JSON, false: only show the name). By default only show names
	/// @arg {Bool}		hide_substructs		If true, structs inside components (like subcomponents) will be hidden (manager is always hidden). Defaults to false
	/// @return {String}
	static list_components = function(active_only = false, expand_criteria = function(component){return false}, hide_substructs = false) {
		var out = "";
		
		var len = array_length(components);
		var len_digits = string_length(string(len));
		
		var comp_num = 1;
		
		var json_filter;
		if(hide_substructs)
			json_filter = function(key, val){
				if(is_struct(val) && key != "")
					return "...";
			
				return val;
			}
		else
			json_filter = function(key, val){
				if(key == "manager")
					return "...";
			
				return val;
			}
		
		for (var i = 0; i < len; ++i) {
			
			// skip inactives
			if(active_only && !components[i].is_active)
				continue;
			
			// write ordinal number with padding
			var ordinal = string(comp_num++);
		    out += string_repeat(" ", len_digits - string_length(ordinal)) + ordinal + " - ";
			
			// write component (json or name)
			out += expand_criteria(components[i]) ? json_stringify(components[i], false, json_filter) : components[i].name;
			out += "\n";
		}
		
		return out;
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
	
	self.is_paused = false;
	
	// add each component
	array_foreach(components, function(val, idx){add_component(val)});

	#endregion
}