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
	
	/// @desc returns the manager of the component
	/// @returns {Struct.ComponentManager}
	static get_manager = function(){
		return __.manager;
	}
	
	/// @desc returns the name of the component
	/// @returns {String}
	static get_name = function(){
		return __.name;
	}
	
	/// @desc returns the current state of the component as a boolean
	/// @returns {Bool}
	static is_active = function(){
		return __.is_active;
	}
	
	/// @desc disables execute method
	static deactivate = function(){
		
		// exit if already inactive
		if(!is_active()) return;
		__.is_active = false;
		
		// save a backup and replace the execute function with an empty one;
		deactivated_execute = execute;
		execute = function(ev_type, ev_num){};
	}
	
	/// @desc enables execute method
	static activate = function(){
		
		// exit if already active
		if(is_active()) return;
		__.is_active = true;
		
		execute = deactivated_execute;
	}
	
	/// @desc returns true if this component has the specified tag
	/// @arg {String} tag		tag to check
	/// @returns {Bool}
	static has_tag = function(tag){
		// wildcard: returns true for at least 1 tag
		if(tag == "*")
			return array_length(__.tags) != 0;
		
		return array_contains(__.tags, tag);
	}
	
	/// @desc returns an array containing all the tags of this component
	/// @arg {Bool} safe	ensures the returned array is safe to modify, false can be used for read-only purposes. defaults to true
	/// @returns {Array<String>}
	static get_tags = function(safe = true){
		
		// clone the tags array and return it safely (if requested)
		return safe ? variable_clone(__.tags, 0) : __.tags;
	}
	
	/// @desc allows addition of tags after creation
	/// @arg {String} tag		tag to add
	static add_tag = function(tag){
		
		// empty string check
		if(tag == ""){
			show_debug_message("WARNING in add_tag(): empty strings \"\" aren't allowed");
			return;
		}
		
		// wildcard check
		if(tag == "*"){
			show_debug_message($"WARNING in add_tag(): The tag \"*\" is reserved and cannot be used as a tag");
			return;
		}
		
		// exit if the tag already exists
		if(array_contains(__.tags, tag)){
			show_debug_message($"WARNING in add_tag(): the tag \"{tag}\" already exists");
			return;
		}
		
		// add to local array
		array_push(__.tags, tag);
		
		if(is_undefined(__.manager))
			return;
		
		// update the manager's internal structure
		var tag_map = __.manager.__.components_by_tag;
		if(is_undefined(tag_map[$ tag]))
			tag_map[$ tag] = [self];
		else
			array_push(tag_map[$ tag], self);
	}
	
	/// @desc allows removal of tags after creation
	/// @arg {String} tag		tag to remove
	static remove_tag = function(tag){
		
		// empty string check
		if(tag == ""){
			show_debug_message("WARNING in remove_tag(): empty strings \"\" aren't allowed");
			return;
		}
		
		// exit if the tag doesn't exist
		if(!array_contains(__.tags, tag)){
			show_debug_message($"WARNING in remove_tag(): the tag \"{tag}\" doesn't exist");
			return;
		}
		
		// remove from local array
		var local_array_index = array_get_index(__.tags, tag);
		array_swap_and_pop(__.tags, local_array_index);
		
		if(is_undefined(__.manager))
			return;
		
		// update the manager's internal structure
		var tag_array = __.manager.__.components_by_tag[$ tag];
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
		
		// empty string check
		if(old_tag == "" || new_tag == ""){
			show_debug_message("WARNING in replace_tag(): empty strings \"\" aren't allowed. Execution aborted");
			return;
		}
		
		// wildcard check
		if(old_tag == "*" || new_tag == "*"){
			show_debug_message("WARNING in replace_tag(): The tag \"*\" is reserved and cannot be used as a tag. Execution aborted");
			return;
		}
		
		// exit if the old tag doesn't exist
		if(!array_contains(__.tags, old_tag)){
			show_debug_message($"WARNING in replace_tag(): the tag \"{old_tag}\" doesn't exist. Execution aborted");
			return;
		}
		// exit if the new tag already exists
		if(array_contains(__.tags, new_tag)){
			show_debug_message($"WARNING in replace_tag(): the tag \"{new_tag}\" already exists. Execution aborted");
			return;
		}
		
		// replace in local array
		var local_array_index = array_get_index(__.tags, old_tag);
		__.tags[local_array_index] = new_tag;
		
		if(is_undefined(__.manager))
			return;
		
		// update the manager's internal structure
		
		// if the old tag array is found, remove the component from it
		var old_tag_array = __.manager.__.components_by_tag[$ old_tag];
		if(is_undefined(old_tag_array) || !array_contains(old_tag_array, self))
			return;
		var old_tag_array_index = array_get_index(old_tag_array, self);
		array_swap_and_pop(old_tag_array, old_tag_array_index);
		
		// add the component to the new tag array
		var tag_map = __.manager.__.components_by_tag;
		if(is_undefined(tag_map[$ new_tag]))
			tag_map[$ new_tag] = [self];
		else
			array_push(tag_map[$ new_tag], self);
	}
	
	#endregion
	
	#region initialize
	
	// remove duplicate tags
	tags = array_unique(tags);
	
	// wildcard check
	if(array_contains(tags, "*")){
		show_debug_message($"WARNING in Component initialization: The tag \"*\" is reserved and cannot be used as a tag");
		
		// remove wildcard tag from the array
		array_swap_and_pop(tags, array_get_index(tags, "*"));
	}
	
	// empty string check
	if(array_contains(tags, "")){
		show_debug_message($"WARNING in Component initialization: empty strings \"\" aren't allowed");
		
		// remove empty string tag from the array
		array_swap_and_pop(tags, array_get_index(tags, ""));
	}
	
	// private
	__ = {};
	with(__){
		self.is_active = true;
		self.name = name;
		self.tags = tags;
		self.events = events;
		self.manager = undefined;
	}
	
	var add_default_priority = function(val, i){
		var default_priority = 1;
		var priority_index = 2;
		var len = array_length(val);
		
		// print out the error if the length isn't correct
		if(len < priority_index)
			show_debug_message($"WARNING in Component initialization: Component with name \"{get_name()}\" as incomplete event at index {i}");
		
		// add the default priority if the array doesn't have it
		if(len <= priority_index)
			__.events[i][priority_index] = default_priority;
	}
	array_foreach(__.events, add_default_priority);
	#endregion
}