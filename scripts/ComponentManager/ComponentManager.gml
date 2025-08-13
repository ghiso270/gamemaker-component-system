/// @desc Constructor for a ComponentManager, needed for using Components inside a project
/// @arg {Id.Instance}		obj				object inside which the components are managed
/// @arg {Array<Struct.Component>}			components		array of initial components

function ComponentManager(obj, components = []) constructor {
	
	/// @desc executes all the necessary components for the current (or the specified) event
	/// @arg {Constant.EventType}	ev_type		type of event to perform. defaults to the current one
	/// @arg {Constant.EventNumber} ev_num		the specific event constant or value. defaults to the current one
	static execute = function(ev_type = event_type, ev_num = event_number){
		if(is_paused)
			return;
		
		if(array_length(components_by_event) < 1)
			return;
		
		var components_by_type = components_by_event[ev_type];
		if(is_undefined(components_by_type))
			return;
		
		// if the resulting array is undefined, the length will be 0, skipping the loop
		var components_to_execute = components_by_type[$ ev_num];
		var component_num = array_length(components_to_execute);
		
		for (var i = 0; i < component_num; ++i)
				components_to_execute[i].component.execute(ev_type, ev_num);
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
		return components_by_name[$ name];
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
			
			var ev_type = comp.events[i][0];
			var ev_num = comp.events[i][1];
			var priority = comp.events[i][2];
			var arr = components_by_event[ev_type][$ ev_num];
			var len = array_length(arr);
			
			// binary search to find the first occurrence of the correct priority
			// after that, linear search
			// because bin search doesn't work correctly with same-key-different-value structures
			var low = 0;
			var high = len - 1;
			var mid = 0;
			while (high >= low) {
				mid = low + floor((high - low) / 2);
				
				// If first occurrence is in right subarray
				if (priority < arr[mid].priority)
					low = mid + 1;
		
				// If first occurrence is in left subarray (also when priority is equal)
				else
					high = mid - 1;
			}
			var j = low;
			for (; j < len; ++j){
			    if(arr[j].component == comp)
					break;
			}
			array_delete(arr, j, 1);
		}
		
		// delete from the name map
		struct_remove(components_by_name, name);
		
		// detachement should happen after, to access the manager during destroy() method
		if(to_destroy)
			comp.destroy();
		
		comp.detach();
		
		// finally, loop through all the tags to remove the item from
		var tags = comp.get_tags();
		var tags_num = array_length(tags);
		for(var i = 0; i < tags_num; ++i){
			
			// get the array of components with the specified tag
			var tag_array = components_by_tag[$ tags[i]];
			if(is_undefined(tag_array))
				continue;
			
			// if the array is found, remove the component from it
			var tag_array_index = array_get_index(tag_array, comp);
			array_delete(tag_array, tag_array_index, 1);
		}
	}
	
	/// @desc adds the specified component to memory, for execution and management
	/// @arg {Struct.Component} component		component to add
	static add_component = function(component){
		if(has_component(component.name)){
			show_debug_message($"WARNING: The name \"{component.name}\" already exists");
			return;
		}
		
		// loop through all the tags
		var tags = component.get_tags();
		var tags_num = array_length(tags);
		for(var i = 0; i < tags_num; ++i){
			
			// create the tag array with the component in it (if it doesn't already exist)
			if(is_undefined(components_by_tag[$ tags[i]]))
				components_by_tag[$ tags[i]] = [component];
			else
				// add the component to the tag array
				array_push(components_by_tag[$ tags[i]], component);
		}
		
		// add to general array
		array_push(components, component);
		
		// add to name map
		components_by_name[$ component.name] = component;
		
		// add to event array
		var events_num = array_length(component.events);
		for (var i = 0; i < events_num; ++i) {
			var ev_type = component.events[i][0];
			var ev_num = component.events[i][1];
			var priority = component.events[i][2];
			
			// create the event number array if it doesn't exist already
			if(array_length(components_by_event) <= ev_type)
				components_by_event[ev_type] = {};
			
			// create the event components array if it doesn't exist already
			if(is_undefined(components_by_event[ev_type][$ ev_num]))
				components_by_event[ev_type][$ ev_num] = [];
			
			// binary search to find the best position for the component
			// (sorted by descending priority)
			var arr = components_by_event[ev_type][$ ev_num];
			var low = 0;
			var high = array_length(arr) - 1;
			var mid = 0;
			while (high >= low) {
				mid = low + floor((high - low) / 2);
				
				// it is assumed that the component isn't already in the array
				// so the middle check can be skipped, only left/right are checked
		
				// If element is in left subarray
				if (priority > arr[mid].priority)
					high = mid - 1;
		
				// If element is in right subarray
				else
					low = mid + 1;
			}
			
			array_insert(arr, low, {priority: priority, component: component});
		}

		// attach the component
		component.attach(self);
	}
	
	/// @desc returns the number of components (in this manager) that share the specified tag. it will return -1 if the tag doesn't exist
	/// @arg {String} tag	tag to get the count of
	/// @returns {Real}
	static tag_count = function(tag){
		
		// return the total number of components
		if(tag == "*")
			return array_length(components);
		
		var comps = components_by_tag[$ tag];
		if(is_undefined(comps))
			return -1;
		
		return array_length(comps);
	}
	
	/// @desc equivalent of tag_count > 0 (returns false even if the tag exists but has no components)
	/// @arg {String} tag	tag to check
	/// @returns {Bool}
	static tag_exists = function(tag){
		return (tag_count(tag) > 0);
	}
	
	/// @desc returns an array containing all the components (in this manager) that share the specified tag
	/// @arg {String} tag	tag of the components to return
	/// @returns {Array<Struct.Component>}
	static tag_get_components = function(tag){
		
		// allows to access ALL components with a specific tag
		if(tag == "*")
			return variable_clone(components, 0);
		
		// clone the components array and return it safely
		return variable_clone(components_by_tag[$ tag], 0);
	}
		
	/// @desc removes all the components (in this manager) that share the specified tag.
	/// @arg {String} tag	tag of the components to remove
	/// @arg {Bool} to_destroy	if set to true, the destroy method of the component will be performed. defaults to true
	/// @arg {Bool} remove_tag	if set to true, the tag itself will be removed from the map (instead of just leaving an empty array). defaults to false
	static tag_remove_components = function(tag, to_destroy = true, remove_tag = false){
		if(tag == "*"){
			var len = array_length(components);
			if(to_destroy){
				for (var i = 0; i < len; ++i)
					components[i].destroy();
			}
			
			// separate detachment to allow communication during destroy() method
			for (var i = 0; i < len; ++i)
				components[i].detach();
		
			self.components = [];
			self.components_by_name = {};
			self.components_by_event = [];
			
			if(remove_tag){
				self.components_by_tag = {};
				return;
			}
			
			var clear_tag_arrays = function(key, val){
				self.components_by_tag[$ key] = [];
			}
			struct_foreach(self.components_by_tag, clear_tag_arrays);
			
			return;
		}
		
		// get the array of components
		var comps = variable_clone(components_by_tag[$ tag], 0);
		if(is_undefined(comps))
			return;
		
		if(remove_tag)
			struct_remove(components_by_tag, tag);
		
		// loop through all the components to delete them
		var len = array_length(comps);
		for (var i = 0; i < len; ++i)
		    remove_component(comps[i].name, to_destroy);
	}
	
	/// @desc executes a function on all the components with a specified tag
	/// @arg {String} tag		tag of the components for which the function should run
	/// @arg {Function} func	function called for each component - takes 1 argument (component) and returns nothing
	static tag_foreach = function(tag, func) {
		
		// if the tag is "*", take all components regardless of tag
		var comps = (tag == "*" ? components : components_by_tag[$ tag]);
		
		// run the function on each component
		var len = array_length(comps);
		for (var i = 0; i < len; ++i)
			func(comps[i]);
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
		self.components_by_tag = {};
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
	
	// map that matches a tag to an array of components
	self.components_by_tag = {};
	
	// similar to a 3-dimension array that makes each component accessible by event id.
	// structured like this: array [event_type] -> struct[$ event_number] -> array of {component: ___, priority: ___}
	self.components_by_event = [];
	
	self.object = obj;
	
	self.is_paused = false;
	
	// add each component
	array_foreach(components, function(val, idx){add_component(val)});

	#endregion
}