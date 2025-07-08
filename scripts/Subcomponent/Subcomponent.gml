/// @desc  Constructor for an abstract subcomponent class, which provides additional functions usable by a component. Subclasses should be used instead

function Subcomponent() constructor{
	
	// custom methods should be added in subclasses
	
	#region utility methods
	
	/// @desc should be called when adding to a component
	/// @arg {Struct.Component} parent	component that will have access to this subcomponent
	attach = function(parent){
		self.parent = parent;
	}
	
	/// @desc should be called when removing from a component
	detach = function(){
		self.parent = undefined;
	}
	
	#endregion
	
	#region initialize
	
	// assigned when attached to a component
	self.parent = undefined;
	
	#endregion
}