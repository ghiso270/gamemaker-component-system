/// @desc  Constructor for an abstract subcomponent class, which provides additional functions usable by a component. Subclasses should be used instead

function Subcomponent() constructor{
	
	// custom methods should be added in subclasses
	
	#region utility methods
	
	/// @desc sets the parent of this subcomponent to the specified one
	/// @returns {Struct.Component}
	static get_parent = function(){
		return __.parent;
	}
	
	/// @desc sets the parent of this subcomponent to the specified one
	/// @arg {Struct.Component} parent	component that will have access to this subcomponent
	static set_parent = function(parent){
		__.parent = parent;
	}
	
	#endregion
	
	#region initialize
	
	// private
	__ = {};
	with(__){
		// assigned when attached to a component
		self.parent = undefined;
	}
	
	#endregion
}