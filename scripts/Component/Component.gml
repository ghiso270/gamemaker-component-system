/// @desc an abstract component class. Subclasses should be used instead, implementing the "execute" method
/// @arg {String}						class				descriptive name of the implementing subclass, eg HealthComponent -> class="health"			
/// @arg {Array<Array<Real>>}			events				list of events in which the component has to be executed, eg: [[ev1_type, ev1_number], [ev2_type, ev2_number], ...]
/// @arg {Array<Struct.Subcomponent>}	subcomponents		array of initial subcomponents

function Component(class, events, subcomponents = []) constructor {
	
	execute = function(){
		// to implement in subclasses
	}
	
	#region initialize
	
	self.class = class;
	self.events = events;
	
	// assigned when attached to a manager
	self.id = undefined;
	self.manager = undefined;
	
	// map that matches a class name to an array of subcomponents of that class
	self.subcomponents_by_class = {};
	
	// array containing all subcomponents, indexed by ID
	self.subcomponents = [];
	
	var len = array_length(subcomponents);
	for (var i = 0; i < len; ++i)
		add_subcomponent(subcomponents[i]);
	
	#endregion
	
	#region utility methods
	
	/// @arg {String} class	class to check
	/// @returns {Bool}
	has_subcomponent_class = function(class){
		var class_array = struct_get(subcomponents_by_class, class);
		return (class_array != undefined && array_length(class_array) > 0);
	}
	
	/// @arg {Real} is	id of the subcomponent to check
	/// @returns {Bool}
	has_subcomponent = function(id){
		return (array_length(subcomponents) > id);
	}
	
	/// @desc returns the subcomponent with the specified ID. it is recommended to check has_subcomponent(id) beforehand
	/// @arg {Real} id	id of the subcomponent to return
	/// @returns {Struct.Subcomponent}
	get_subcomponent = function(id){
		return subcomponents[id];
	}
	
	/// @arg {String} class	class of the subcomponent array to return
	/// @returns {Array<Struct.Subcomponent>}
	get_subcomponents_by_class = function(class){
		return struct_get(subcomponents_by_class, class);
	}
	
	/// @arg {Real} id	id of the subcomponent to remove
	remove_subcomponent = function(id){
		
		// if the subcomponent doesn't exist,skip
		if(!has_subcomponent(id))
			return;
			
		var subcomp = get_component(id);
		
		// delete the subcomponent from the array
		array_delete(subcomponents, id, 1);
		
		// delete the subcomponent from the class map
		var class_array = struct_get(subcomponents_by_class, subcomp.class);
		var class_index = array_get_index(class_array, subcomp);
		array_delete(class_array, class_index, 1);
	}
	
	/// @arg {String} class		class of subcomponents to remove
	remove_subcomponent_class = function(class){
		
		// if the subcomponent doesn't exist, don't remove it
		if(!has_subcomponent_class(class))
			return;
		
		// remove each subcomponent from the general array
		var class_array = struct_get(subcomponents_by_class, class);
		var len = array_length(class_array);
		for (var i = 0; i < len; ++i)
			array_delete(subcomponents, class_array[i].id, 1);
		
		// delete the class itself, the garbage collector handles the rest
		struct_remove(subcomponents_by_class, class);
	}
	
	/// @arg {Struct.Subcomponent} subcomponent		subcomponent to add
	add_subcomponent = function(subcomponent){
		
		// add to the array
		var new_id = array_length(subcomponents);
		subcomponents[new_id] = subcomponent;
		
		// add to the class map
		var class_array = struct_get(subcomponents_by_class, subcomponent.class);
		if(class_array == undefined)
			struct_set(subcomponents_by_class, subcomponent.class, [subcomponent]);
		else
			array_push(class_array, subcomponent);
		
		// attach the subcomponent
		subcomponent.attach(self, new_id);
	}
	
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
}