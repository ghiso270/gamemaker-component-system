/// @desc  Constructor for an abstract subcomponent class, which provides additional functions usable by a component. Subclasses should be used instead

function Subcomponent() constructor {
	
	// custom methods should be added in subclasses
	
	#region utility methods
	
	/// @desc sets the parent of this subcomponent to the specified one
	/// @returns {Struct.Component}
	static get_parent = function(){
		return __.parent;
	}
	
	/// @desc sets the parent of this subcomponent to the specified one (should be considered a PRIVATE method)
	/// @arg {Struct.Component} parent	component that will have access to this subcomponent
	static set_parent = function(parent){
		__.parent = parent;
	}
	
	/// @desc returns an array containing all classes of the subcomponent
	static get_classes = function(){
		return struct_get_names(__.classes);
	}
	
	/// @desc returns whether or not the object is an instance of a class
	/// @arg {String} class	name to check (must start with "::")
	static has_class = function(class){
		return struct_exists(__.classes, class);
	}
	
	/// @desc adds a class (should be considered a PROTECTED method)
	/// @arg {String} class	name to add (must start with "::")
	static add_class = function(class){
		__.classes[$ class] = true;
	}
	
	#endregion
	
	#region initialize
	
	// private
	__ = {};
	with(__){
		// assigned when attached to a component
		self.parent = undefined;
		
		// accounts for inheritance
		self.classes = {};
	}
	
	add_class("::Subcomponent");
	
	#endregion
}