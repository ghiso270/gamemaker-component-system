/// @desc an abstract component class. Subclasses should be used instead, implementing the "execute" method and optionally subcomponents
/// @arg {String}						name				name of the component
/// @arg {Array<String>}				tags				tags of the component ("*" is reserved, so it should not be included)
/// @arg {Array<Array<Real>>}			events				list of events in which the component has to be executed, with the priority as third value (higher number goes first), eg: [[ev_type, ev_number, priority], ...]. the priority is optional and defaults to 1

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
	
	/// @desc returns an array containing all the tags of this component
	/// @returns {Array<String>}
	static get_tags = function(){
		
		// clone the tags array and return it safely
		return variable_clone(tags, 0);
	}
	
	/// @desc returns true if this component has the specified tag
	/// @arg {String} tag		tag to check
	/// @returns {Bool}
	static has_tag = function(tag){
		return array_contains(tags, tag);
	}
	
	/// @desc allows addition of tags after creation
	/// @arg {String} tag		tag to add
	static add_tag = function(tag){
		
		// add to local array
		array_push(tags, tag);
		
		if(is_undefined(manager))
			return;
		
		// update the manager's internal structure
		var tag_map = manager.components_by_tag;
		if(is_undefined(tag_map[$ tag]))
			tag_map[$ tag] = [self];
		else
			array_push(tag_map[$ tag], self);
	}
	
	/// @desc allows removal of tags after creation
	/// @arg {String} tag		tag to remove
	static remove_tag = function(tag){
		
		// exit if the tag doesn't exist
		if(!array_contains(tags, tag))
			return;
		
		// remove from local array
		var local_array_index = array_get_index(tags, tag);
		array_swap_and_pop(tags, local_array_index);
		
		if(is_undefined(manager))
			return;
		
		// update the manager's internal structure
		
		var tag_array = manager.components_by_tag[$ tag];
		if(is_undefined(tag_array) || !array_contains(tag_array, self))
			return;
			
		// if the array is found, remove the component from it
		var tag_array_index = array_get_index(tag_array, self);
		array_swap_and_pop(tag_array, tag_array_index);
	}
	
	/// @desc allows removal of tags after creation
	/// @arg {String} old_tag		tag to replace	
	/// @arg {String} new_tag		name to replace the old tag with		
	static replace_tag = function(old_tag, new_tag){
		
		// exit if the tag doesn't exist
		if(!array_contains(tags, old_tag))
			return;
		
		// replace in local array
		var local_array_index = array_get_index(tags, old_tag);
		tags[local_array_index] = new_tag;
		
		if(is_undefined(manager))
			return;
		
		// update the manager's internal structure
		
		// if the old tag array is found, remove the component from it
		var old_tag_array = manager.components_by_tag[$ old_tag];
		if(is_undefined(old_tag_array) || !array_contains(old_tag_array, self))
			return;
		var old_tag_array_index = array_get_index(old_tag_array, self);
		array_swap_and_pop(old_tag_array, old_tag_array_index);
		
		// add the component to the new tag array
		var tag_map = manager.components_by_tag;
		if(is_undefined(tag_map[$ new_tag]))
			tag_map[$ new_tag] = [self];
		else
			array_push(tag_map[$ new_tag], self);
	}
	
	#endregion
	
	#region initialize
	
	self.is_active = true;
	self.name = name;
	self.tags = tags;
	self.events = events;
	
	if(array_contains(tags, "*"))
		show_debug_message($"WARNING: The tag \"*\" is reserved and should not be used as a tag");
	
	var add_default_priority = function(val, i){
		var default_priority = 1;
		var priority_index = 2;
		var len = array_length(val);
		
		// print out the error if the length isn't correct
		if(len < priority_index)
			show_debug_message($"WARNING: Component with name \"{self.name}\" has incomplete event at index {i}");
		
		// add the default priority if the array doesn't have it
		if(len <= priority_index)
			self.events[i][priority_index] = default_priority;
	}
	array_foreach(self.events, add_default_priority);
	#endregion
}