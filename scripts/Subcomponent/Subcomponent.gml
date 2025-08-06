/// @desc  Constructor for an abstract subcomponent class, which provides additional functions usable by a component. Subclasses should be used instead

function Subcomponent() constructor{
	
	// custom methods should be added in subclasses
	
	#region utility methods
	
	/// @desc sets the parent of this subcomponent to the specified one
	/// @arg {Struct.Component} parent	component that will have access to this subcomponent
	static attach = function(parent){
		self.parent = parent;
	}
	
	/// @desc removes this subcomponent's reference to its parent
	static detach = function(){
		self.parent = undefined;
	}
	
	#endregion
	
	#region initialize
	
	// assigned when attached to a component
	self.parent = undefined;
	
	#endregion
}