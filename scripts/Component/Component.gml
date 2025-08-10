/// @desc an abstract component class. Subclasses should be used instead, implementing the "execute" method and optionally subcomponents
/// @arg {String}						name				name of the component
/// @arg {Array<String>}				tags				tags of the component ("*" is reserved, so it must not be included)
/// @arg {Array<Array<Real>>}			events				list of events in which the component has to be executed, eg: [[ev1_type, ev1_number], [ev2_type, ev2_number], ...]

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
		array_delete(tags, local_array_index, 1);
		
		if(is_undefined(manager))
			return;
		
		// update the manager's internal structure
		
		var tag_array = manager.components_by_tag[$ tag];
		if(is_undefined(tag_array) || !array_contains(tag_array, self))
			return;
			
		// if the array is found, remove the component from it
		var tag_array_index = array_get_index(tag_array, self);
		array_delete(tag_array, tag_array_index, 1);
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
		array_delete(old_tag_array, old_tag_array_index, 1);
		
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
	
	#endregion
}